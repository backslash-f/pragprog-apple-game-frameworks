//
//  GameViewController.swift
//  hog
//
//  Created by Tammy Coron on 10/31/2020.
//  Copyright © 2020 Just Write Code LLC. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // TODO: Add Game Center Observers
    // TODO: Authenticate the Local GC Player
    
    // Create the view
    if let view = self.view as! SKView? {
      
      // Create the scene
      let scene = LobbyScene(fileNamed: "LobbyScene")
      
      // Set the scale mode to scale to fill the view window
      scene?.scaleMode = .aspectFill
      
      // Present the scene
      view.presentScene(scene)
      
      // Set the view options
      view.ignoresSiblingOrder = false
      view.showsPhysics = false
      view.showsFPS = false
      view.showsNodeCount = false
    }
  }
  
  override var shouldAutorotate: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .allButUpsideDown
    } else {
      return .all
    }
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  // MARK: - GAME CENTER NOTIFICATION HANDLERS
  
  // TODO: Add Game Center Notification Handlers
}
