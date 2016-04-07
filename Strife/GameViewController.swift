//
//  GameViewController.swift
//  Strife
//
//  Created by Nico Hämäläinen on 08/10/15.
//  Copyright (c) 2015 sizeof.io. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
  
  var scene: GameScene!
  
  // MARK: IBOutlets
  
  @IBOutlet weak var titleLabel: UILabel!
  
  // MARK: View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Hide labels initially
    titleLabel.layer.opacity = 0.0
    
    showLabel()
    
    // No multitouch support (yet)
    let skView = self.view as! SKView
    skView.multipleTouchEnabled = false
    skView.showsFPS = true
    skView.showsDrawCount = true
    skView.showsQuadCount = true
    skView.showsNodeCount = true
    skView.ignoresSiblingOrder = true
    
    // Create and configure the scene.
    self.scene = GameScene(size: skView.bounds.size)
    self.scene.scaleMode = .AspectFill
    
    // Present the scene.
    skView.presentScene(self.scene)
    
    SKTextureAtlas.preloadTextureAtlases([SKTextureAtlas(named: "Pieces")]) {
      dispatch_async(dispatch_get_main_queue()) {
        self.hideLabel {
          self.scene.boardNode.animateInitialBoard {
          }
          self.scene.shuffle()
        }
      }
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func shouldAutorotate() -> Bool {
    return true
  }
  
  override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    return [.Portrait, .PortraitUpsideDown]
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  // MARK: Animations
  
  func showLabel() {
    UIView.animateWithDuration(0.5, delay: 0.5, options: .CurveEaseOut, animations: {
      self.titleLabel.layer.opacity = 1.0
      }, completion: nil)
  }
  
  func hideLabel(callback: () -> ()) {
    UIView.animateWithDuration(0.5, delay: 0.5, options: .CurveEaseOut, animations: {
      self.titleLabel.layer.opacity = 0.0
    }, completion: { finished in
      self.titleLabel.removeFromSuperview()
      callback()
    })
  }
}
