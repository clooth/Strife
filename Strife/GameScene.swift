//
//  GameScene.swift
//  Strife
//
//  Created by Nico Hämäläinen on 08/10/15.
//  Copyright (c) 2015 sizeof.io. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

  // Nodes
  
  // Our main container
  let sceneLayer = SKNode()
  let sceneSprite = SKSpriteNode()
  var boardNode: BoardNode
  
  let backgroundSprite = SKSpriteNode(imageNamed: "backdrop")
  
  // MARK: Initializers
  
  override init(size: CGSize) {
    let screenFrame = UIScreen.mainScreen().bounds
    
    backgroundSprite.size = CGSize(width: screenFrame.width, height: screenFrame.height)
    boardNode = BoardNode(size: CGSize(width: screenFrame.width, height: screenFrame.width))
    
    super.init(size: size)
    postInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func postInit() {
    self.backgroundColor = UIColor.brownColor()
    
    self.anchorPoint = CGPoint(x: 0, y: 0)
    addChild(sceneLayer)
    
    // Add the game board to the scene
    backgroundSprite.position = CGPointMake(self.size.width/2, self.size.height/2)
    backgroundSprite.zPosition = 500
    sceneLayer.addChild(backgroundSprite)
    boardNode.position = CGPoint(x: 0, y: 0)
    sceneLayer.addChild(boardNode)
    boardNode.board.resetPieces()
    
//    var playerA = Player(battle: battle, party: Party(units: []))
//    playerA.party.addUnit(Unit(name: "Jesus", constitution: 10, strength: 10, battle: battle))
//    
//    var playerB = Player(battle: battle, party: Party(units: []))
//    playerB.party.addUnit(Unit(name: "Sheep", constitution: 10, strength: 10, battle: battle))
//    
//    battle.players.append(playerA)
//    battle.players.append(playerB)
//    
//    battle.setup()
//    battle.start()
  }
  
  // MARK: Events
  
  
  // MARK: Board handling
  
  func shuffle()
  {
    dispatch_async(dispatch_get_main_queue()) {
      // Delete the old pieces sprites, but not the pieces.
      self.boardNode.removeAllPieceSprites()
      
      // Fill up the level with shuffled pieces, and add sprites
      let newPieces = self.boardNode.board.shufflePieces()
      self.boardNode.createSpritesForPieces(newPieces)
    }
  }
  
  func handleMatches()
  {
    // Detect if there are any matches left.
    let chains = boardNode.board.removeMatches()
    
    // If there are no more matches, then the player gets to move again.
    // TODO: Can only move again if 4 or more tiles in any of the chains
    if chains.count == 0 {
      beginNextTurn()
      return
    }
    
    // animate matches
    boardNode.animateMatchedPieces(chains) {
      
      // Handle attacks
//      for unit in self.battle.currentPlayer().party.units {
//        if !self.battle.currentOpponent().party.isDead() {
//          unit.attackRandomEnemy()
//        }
//      }
      
      // shift down
      let cols = self.boardNode.board.fillBoardHoles()
      self.boardNode.animateFallingPieces(cols) {
        // add new runes
        let cols = self.boardNode.board.fillUpPieces()
        self.boardNode.animateNewPieces(cols) {
          // repeat
          self.handleMatches()
        }
      }
    }
  }
  
  func beginNextTurn() {
    // End the turn in the game
//    self.battle.endTurn()
    
    // Detect possible moves
    if boardNode.board.hasPossibleMoves() == false {
      shuffle()
    }
    
    // Allow moving again
    userInteractionEnabled = true
  }
  
  func handleBoardMove(move: BoardMove) {
    self.userInteractionEnabled = false
    
    if boardNode.board.isPossibleMove(move) {
      boardNode.board.performMove(move)
      boardNode.animateMove(move, isInvalid: false, completion: handleMatches)
    }
    else {
      boardNode.animateMove(move, isInvalid: true) {
        self.userInteractionEnabled = true
      }
    }
  }
}
