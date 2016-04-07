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
    case .Melee:   return "melee"
    case .Ranged:  return "ranged"
    case .Healing: return "healing"
    case .Magic:   return "magic"
    case .Coin:    return "coin"
    }
  }
}

/// Represents a single Piece on a board
class Piece {
  /// The column (y) the Piece is in
  var column: Int
  /// The row (x) the Piece is in
  var row: Int
  /// The type of the Piece
  var type: PieceType
  /// The sprite used to display this piece
  lazy var sprite: SKSpriteNode = {
    return SKSpriteNode(texture: SKTextureAtlas(named: "Pieces").textureNamed(self.type.description))
  }()
  
  init(column: Int, row: Int, type: PieceType) {
    self.column = column
    self.row = row
    self.type = type
  }
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

// MARK: - Hashable

extension Piece: Hashable {
  var hashValue: Int {
    return column + row + type.rawValue
  }
}