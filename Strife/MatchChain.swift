//
//  MatchChain.swift
//  Strife
//
//  Created by Nico Hämäläinen on 08/10/15.
//  Copyright © 2015 sizeof.io. All rights reserved.
//

import Foundation

/// Available match chain types
///
/// - Horizontal: Pieces match in a row
/// - Vertical:   Pieces match in a column
/// - Mixed:      Pieces match and overlap in both a row and a column
enum MatchChainType {
  case Horizontal
  case Vertical
  case Mixed
}

// MARK: - CustomStringConvertible

extension MatchChainType: CustomStringConvertible {
  var description: String {
    switch self {
    case .Horizontal: return "Horizontal"
    case .Vertical: return "Vertical"
    case .Mixed: return "Mixed"
    }
  }
}

class MatchChain {
  var pieces = [Piece]()
  var type: MatchChainType
  
  /// The length of this chain
  var length: Int {
    return pieces.count
  }
  
  /// Create a new MatchChain of a given type
  ///
  /// - parameter type: The `MatchChainType` of this chain.
  ///
  /// - returns: The newly created MatchChain
  init(type: MatchChainType) {
    self.type = type
  }
  
  /// Add a Piece to this chain
  ///
  /// - parameter piece: The Piece to add
  func addPiece(piece: Piece) {
    pieces.append(piece)
  }
  
  /// Get the first Piece in the chain
  ///
  /// - returns: The Piece that's first
  func firstPiece() -> Piece {
    return pieces[0]
  }
  
  /// Get the last Piece in the chain
  ///
  /// - returns: The Piece that's last
  func lastPiece() -> Piece {
    return pieces[pieces.count - 1]
  }
}

// MARK: - CustomStringConvertible

extension MatchChain: CustomStringConvertible {
  var description: String {
    return "\(type) Chain: \(pieces)"
  }
}

// MARK: - Hashable

extension MatchChain: Hashable {
  var hashValue: Int {
    return pieces.reduce(0) { $0.hashValue ^ $1.hashValue }
  }
}

// MARK: - Equatable

extension MatchChain: Equatable { }

func ==(lhs: MatchChain, rhs: MatchChain) -> Bool {
  return lhs.pieces == rhs.pieces
}