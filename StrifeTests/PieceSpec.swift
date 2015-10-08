//
//  PieceSpec.swift
//  Strife
//
//  Created by Nico Hämäläinen on 08/10/15.
//  Copyright © 2015 sizeof.io. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Strife

class PieceSpec: QuickSpec {
  override func spec() {
    
    it("should provide random piece types") {
      var seenTypes: Set<PieceType> = Set()
      for var i = 0; i < 100; i++ {
        seenTypes.insert(PieceType.randomPiece())
      }
      expect(seenTypes.count).to(equal(PieceType.count))
    }
    
    it("should print PieceType description properly") {
      let testMap: [PieceType: String] = [
        .Melee: "Melee",
        .Ranged: "Ranged",
        .Healing: "Healing",
        .Magic: "Magic",
        .Coin: "Coin"
      ]
      for (type, name) in testMap.enumerate() {
        expect()
      }
    }
    
    it("should print Piece description properly") {
      let piece = Piece(column: 5, row: 4, type: .Melee)
      expect(piece.description).to(equal("5x4: Melee"))
    }
    
  }
}