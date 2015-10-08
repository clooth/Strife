//
//  Piece.swift
//  Strife
//
//  Created by Nico Hämäläinen on 08/10/15.
//  Copyright © 2015 sizeof.io. All rights reserved.
//

import Foundation
import SpriteKit

/// Represents a single piece type on the board
enum PieceType: Int {
  /// Melee attack piece
  case Melee
  /// Ranged attack piece
  case Ranged
  /// Healing piece
  case Healing
  /// Magic attack piece
  case Magic
  /// Coin piece
  case Coin
  
  /// The count of items in this enumeration
  static var count: Int {
    var max: Int = 0
    while let _ = self.init(rawValue: ++max) {}
    return max
  }
  
  /// Returns a random piece type
  ///
  /// - returns: A random PieceType
  static func randomPiece() -> PieceType {
    return PieceType(rawValue: Int(arc4random_uniform(UInt32(count))))!
  }
}

extension PieceType: CustomStringConvertible {
  var description: String {
    switch self {
    case .Melee:   return "Melee"
    case .Ranged:  return "Ranged"
    case .Healing: return "Healing"
    case .Magic:   return "Magic"
    case .Coin:    return "Coin"
    }
  }
}

struct Piece {
  var column: Int
  var row: Int
  var type: PieceType
}

// MARK: - CustomStringConvertible

extension Piece: CustomStringConvertible {
  var description: String { return "\(column)x\(row): \(type)" }
}

// MARK: - Equatable

extension Piece: Equatable {}
func ==(lhs: Piece, rhs: Piece) -> Bool {
  return lhs.column == rhs.column && lhs.row == rhs.row && lhs.type == rhs.type
}