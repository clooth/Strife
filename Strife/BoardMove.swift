//
//  BoardMove.swift
//  Strife
//
//  Created by Nico Hämäläinen on 08/10/15.
//  Copyright © 2015 sizeof.io. All rights reserved.
//

import Foundation

/// Represents a single swap of two pieces on the board
struct BoardMove {
  let pieceA: Piece
  let pieceB: Piece
}

// MARK: - CustomStringConvertible

extension BoardMove: CustomStringConvertible {
  var description: String { return "\(pieceA) <-> \(pieceB)" }
}

// MARK: - Hashable

extension BoardMove: Hashable {
  var hashValue: Int {
    return pieceA.hashValue ^ pieceB.hashValue
  }
}

// MARK: - Equatable

extension BoardMove: Equatable { }

func ==(lhs: BoardMove, rhs: BoardMove) -> Bool {
  return (lhs.pieceA == rhs.pieceA && lhs.pieceB == rhs.pieceB) ||
    (lhs.pieceB == rhs.pieceA && lhs.pieceA == rhs.pieceB)
}