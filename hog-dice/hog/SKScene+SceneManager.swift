//
//  SKScene+SceneManager.swift
//  valsrevenge
//
//  Created by Tammy Coron on 10/16/20.
//  Copyright © 2020 Just Write Code LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

extension SKScene {
  
  func startNewGame() {

  }
  
  
  func loadGameScene() {

    // Create actions to load the next scene
    let wait = SKAction.wait(forDuration: 0.50)
    let block = SKAction.run {
      
      // Load 'GameScene.sks' as a GKScene
      if let scene = GKScene(fileNamed: "GameScene") {
        
        // Get the SKScene from the loaded GKScene
        if let sceneNode = scene.rootNode as! GameScene? {
          
          // Copy gameplay related content over to the scene
          sceneNode.entities = scene.entities
          sceneNode.graphs = scene.graphs
          
          // Set the scale mode to scale to fit the window
          sceneNode.scaleMode = .aspectFill
          
          // Present the scene
          self.view?.presentScene(sceneNode, transition:
            SKTransition.doorsOpenHorizontal(withDuration: 1.0))
          
          // Update the layout
          // sceneNode.didChangeLayout()
        }
      } else {
        print("Can't load game scene.")
      }
    }
    
    // Run the actions in sequence
    run(SKAction.sequence([wait, block]))
  }
  
  func loadGameOverScene() {
    print("Attempting to load the game over scene.")
    
    // Create actions to load the game over scene
    let wait = SKAction.wait(forDuration: 0.50)
    let block = SKAction.run {
      if let scene = GameOverScene(fileNamed: "GameWonScene") {
        scene.scaleMode = .aspectFill
        
        self.view?.presentScene(scene, transition:
          SKTransition.doorsOpenHorizontal(withDuration: 1.0))
      } else {
        print("Can't load game over scene.")
      }
    }
    
    // Run the actions in sequence
    run(SKAction.sequence([wait, block]))
  }
}
