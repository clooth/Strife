//
//  Board.swift
//  Strife
//
//  Created by Nico Hämäläinen on 08/10/15.
//  Copyright © 2015 sizeof.io. All rights reserved.
//

import Foundation

class Board {
  var columns: Int = 0
  var rows: Int = 0
  var pieces: Array2D<Piece>
  
  init(columns: Int, rows: Int) {
    self.columns = columns
    self.rows = rows
    self.pieces = Array2D<Piece>(columns: columns, rows: rows)
  }
}

// MARK: - Board Manipulation

extension Board {
  /// Shuffle the board until there are no more matches
  ///
  /// - returns: The final shuffled set of pieces
  func shufflePieces() -> Set<Piece> {
    // Place to hold the pieces
    var set = Set<Piece>()
    
    // Keep shuffling the pieces until there are no more matches
    repeat { pieces.shuffle() } while hasMatches()
    
    // Build the shuffled board result
    for row in 0..<columns {
      for col in 0..<rows {
        pieces[col, row]?.column = col
        pieces[col, row]?.row = row
        set.insert(pieces[col, row]!)
      }
    }
    
    return set
  }
  
  /// Check if there are any matches on the board
  ///
  /// - returns: True if there are
  func hasMatches() -> Bool {
    var hasMatches: Bool = false
    
    for row in 0..<columns {
      for col in 0..<rows {
        let type: PieceType = pieces[col, row]!.type
        
        // Check for vertical and horizontal matches for the current piece
        let verticalMatch   = (col >= 2 && pieces[col - 1, row]?.type == type && pieces[col - 2, row]?.type == type)
        let horizontalMatch = (row >= 2 && pieces[col, row - 1]?.type == type && pieces[col, row - 2]?.type == type)
        
        if verticalMatch || horizontalMatch {
          hasMatches = true
          break
        }
      }
    }
    
    return hasMatches
  }
  
  /// Reset the whole board with new pieces
  ///
  /// - returns: The new board pieces
  func resetPieces() -> Set<Piece> {
    var set = Set<Piece>()
    
    for row in 0..<columns {
      for col in 0..<rows {
        // Pick a random piece type and make sure it doesn't cause a match
        var type: PieceType
        repeat {
          type = PieceType.randomPiece()
        } while (col >= 2 &&
          pieces[col - 1, row]?.type == type &&
          pieces[col - 2, row]?.type == type)
          ||
          (row >= 2 &&
            pieces[col, row - 1]?.type == type &&
            pieces[col, row - 2]?.type == type)
        
        // Create new piece and add it to the set
        let piece = Piece(column: col, row: row, type: type)
        pieces[col, row] = piece
        set.insert(piece)
      }
    }
    
    return set
  }
  
  
  // MARK: Performing Moves
  
  func performMove(move: BoardMove) {
    let (columnA, rowA) = (move.pieceA.column, move.pieceA.row)
    let (columnB, rowB) = (move.pieceB.column, move.pieceB.row)
    
    pieces[columnA, rowA] = move.pieceB
    move.pieceB.column = columnA
    move.pieceB.row = rowA
    
    pieces[columnB, rowB] = move.pieceA
    move.pieceA.column = columnB
    move.pieceA.row = rowB
  }
  
  // MARK: Removing matches from the board
  
  func removeMatches() -> Set<MatchChain> {
    var horizontalChains = horizontalMatches()
    var verticalChains   = verticalMatches()
    var mixedChains      = Set<MatchChain>()
    
    // Mixed matches
    // TODO: Move into own method
    for horzChain in horizontalChains {
      for vertChain in verticalChains {
        let intersection = Set(horzChain.pieces).intersect(Set(vertChain.pieces))
        if intersection.count > 0 {
          let chain = MatchChain(type: .Mixed)
          chain.pieces = Array(Set(horzChain.pieces).union(Set(vertChain.pieces)))
          mixedChains.insert(chain)
          
          horizontalChains.remove(horzChain)
          verticalChains.remove(vertChain)
        }
      }
    }
    
    let chains = mixedChains.union(horizontalChains).union(verticalChains)
    removeChains(chains)
    
    return chains
  }
  
  // Remove all the pieces from the board in the given chains
  private func removeChains(chains: Set<MatchChain>) {
    for chain in chains {
      for piece in chain.pieces {
        pieces[piece.column, piece.row] = nil
      }
    }
  }
  
  // MARK: Filling the board
  
  // Detects where there are holes and shifts any pieces down to fill up those
  // holes.
  func fillBoardHoles() -> [[Piece]] {
    // The columns where we have holes
    var cols = [[Piece]]()
    
    // Loop through the rows, from bottom to top. It's handy that our row 0 is
    // at the bottom already. Because we're scanning from bottom to top, this
    // automatically causes an entire stack to fall down to fill up a hole.
    // We scan one column at a time.
    for column in 0..<columns {
      var array = [Piece]()
      
      // Go through each row
      for row in 0..<rows {
        // If there's no piece at this location
        if pieces[column, row] == nil {
          // Scan upwards
          for lookup in (row + 1)..<rows {
            if let piece = pieces[column, lookup] {
              // Swap piece with hole
              pieces[column, lookup] = nil
              pieces[column, row] = piece
              piece.row = row
              
              // Return an array of pieces that have fallen down.
              // Array is ordered for animation purposes.
              array.append(piece)
              
              // No need to scan up more
              break
            }
          }
        }
      }
      
      if !array.isEmpty {
        cols.append(array)
      }
    }
    
    return cols
  }
  
  // MARK: Create new pieces to fill up holes at the top
  func fillUpPieces() -> [[Piece]] {
    var cols: [[Piece]] = [[Piece]]()
    
    for col in 0..<columns {
      var array = [Piece]()
      
      // Scan top to bottom
      for var row = rows - 1; row >= 0 && pieces[col, row] == nil; --row {
        // If slot is empty
        if pieces[col, row] == nil {
          // Create piece
          let piece = Piece(column: col, row: row, type: PieceType.randomPiece())
          pieces[col, row] = piece
          array.append(piece)
        }
      }
      
      if !array.isEmpty {
        cols.append(array)
      }
    }
    
    return cols
  }
}


// MARK: Querying the board

extension Board {
  // MARK: Finding pieces
  
  // Get a piece from a specific column and row
  func pieceAtColumn(column: Int, row: Int) -> Piece? {
    assert(column >= 0 && column < columns)
    assert(row >= 0 && row < rows)
    return pieces[column, row]
  }
  
  // MARK: Finding possible moves
  
  // Find all possible moves the board allows
  func detectPossibleMoves() -> Set<BoardMove> {
    var set = Set<BoardMove>()
    
    for row in 0..<rows {
      for col in 0..<columns {
        // If there's a piece there
        if let piece = pieces[col, row] {
          
          // Can we swap this with the one above?
          if col < columns - 1 {
            // Is there a piece in this spot?
            if let other = pieces[col + 1, row] {
              // Swap them
              pieces[col, row] = other
              pieces[col + 1, row] = piece
              
              // Is either of them part of the chain?
              if hasChainAtColumn(col + 1, row: row) || hasChainAtColumn(col, row: row) {
                set.insert(BoardMove(pieceA: piece, pieceB: other))
              }
              
              // Swap them back
              pieces[col, row] = piece
              pieces[col + 1, row] = other
            }
          }
          
          // Can we swap this with the one above?
          if row < rows - 1 {
            if let other = pieces[col, row + 1] {
              // Swap them
              pieces[col, row] = other
              pieces[col, row + 1] = piece
              
              // Is either of them part of the chain?
              if hasChainAtColumn(col, row: row + 1) || hasChainAtColumn(col, row: row) {
                set.insert(BoardMove(pieceA: piece, pieceB: other))
              }
              
              // Swap them back
              pieces[col, row] = piece
              pieces[col, row + 1] = other
            }
          }
          
        }
      }
    }
    
    return set
  }
  
  var possibleMoves: Set<BoardMove> {
    get {
      return detectPossibleMoves()
    }
  }
  
  // Validate a given BoardMove
  func isPossibleMove(move: BoardMove) -> Bool {
    return possibleMoves.contains(move)
  }
  
  // Whether or not we have possible moves left on the board
  func hasPossibleMoves() -> Bool {
    return possibleMoves.count > 0
  }
  
  // MARK: Finding chains
  
  private func hasChainAtColumn(column: Int, row: Int) -> Bool
  {
    // Here we have ! because we know there's a piece there
    let type = pieces[column, row]!.type
    
    // Here we do ? because there may be no piece there; if there isn't then
    // the loop will terminate because it is != type. (So there is no
    // need to check whether pieces[i, row] != nil.)
    var horzLength = 1
    for var i = column - 1; i >= 0 && pieces[i, row]?.type == type; --i, ++horzLength { }
    for var i = column + 1; i < columns && pieces[i, row]?.type == type; ++i, ++horzLength { }
    if horzLength >= 3 { return true }
    
    var vertLength = 1
    for var i = row - 1; i >= 0 && pieces[column, i]?.type == type; --i, ++vertLength { }
    for var i = row + 1; i < rows && pieces[column, i]?.type == type; ++i, ++vertLength { }
    return vertLength >= 3
  }
  
  // MARK: Finding matches
  
  func horizontalMatches() -> Set<MatchChain> {
    var set = Set<MatchChain>()
    
    for row in 0..<rows {
      // Skip the last two columns
      for var col = 0; col < columns - 2; {
        if let piece = pieces[col, row] {
          let type = piece.type
          
          // If the next two are the same type
          if pieces[col + 1, row]?.type == type && pieces[col + 2, row]?.type == type {
            // Add all to a chain
            let chain = MatchChain(type: .Horizontal)
            repeat {
              chain.addPiece(pieces[col, row]!)
              ++col
            } while col < columns && pieces[col, row]?.type == type
            
            set.insert(chain)
            continue
          }
          
          // No match, skip
          ++col
        }
      }
    }
    
    return set
  }
  
  func verticalMatches() -> Set<MatchChain> {
    var set = Set<MatchChain>()
    
    for col in 0..<columns {
      // Skip the last two columns
      for var row = 0; row < rows - 2; {
        if let piece = pieces[col, row] {
          let type = piece.type
          
          // If the next two are the same type
          if pieces[col, row + 1]?.type == type && pieces[col, row + 2]?.type == type {
            // Add all to a chain
            let chain = MatchChain(type: .Horizontal)
            repeat {
              chain.addPiece(pieces[col, row]!)
              ++row
            } while row < rows && pieces[col, row]?.type == type
            
            set.insert(chain)
            continue
          }
          
          // No match, skip
          ++row
        }
      }
    }
    
    return set
  }
  
}