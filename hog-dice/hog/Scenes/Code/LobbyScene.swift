//
//  LobbyScene.swift
//  hog
//
//  Created by Tammy Coron on 10/31/2020.
//  Copyright © 2020 Just Write Code LLC. All rights reserved.
//

import SpriteKit

class LobbyScene: SKScene {
  
  // MARK: - PROPERTIES
  
  private lazy var playSoloButton: SKSpriteNode = {
    childNode(withName: "button_playSolo") as! SKSpriteNode
  }()
  
  private lazy var playLocalButton: SKSpriteNode = {
    childNode(withName: "button_playLocal") as! SKSpriteNode
  }()
  
  private lazy var findMatchButton: SKSpriteNode = {
    childNode(withName: "button_findMatch") as! SKSpriteNode
  }()
  
  private lazy var gameCenterButton: SKSpriteNode = {
    childNode(withName: "button_gameCenter") as! SKSpriteNode
  }()
  
  // ** TEST CODE (For Simulator Only) **
  // This code lets you easily test win/lose scene
  // without having to play the game
  #if targetEnvironment(simulator)
  private var isTest: Bool = true
  
  private lazy var chipsButton: SKSpriteNode = {
    childNode(withName: "chips") as! SKSpriteNode
  }()
  private lazy var diceButton: SKSpriteNode = {
    childNode(withName: "dice") as! SKSpriteNode
  }()
  #endif
  
  // MARK: - INIT METHODS
  
  override func didMove(to view: SKView) {
    
    // TODO: Add code to reset the match data
    // TODO: Add Game Center Observers
  }
  
  // MARK: - TOUCH HANDLERS
  
  /* ############################################################ */
  /*                 TOUCH HANDLERS STARTS HERE                   */
  /* ############################################################ */
  
  func touchDown(atPoint pos : CGPoint) {
    let nodeAtPoint = atPoint(pos)
    
    if playSoloButton.contains(nodeAtPoint) {
      loadGameScene(gameType: GameType.soloMatch)
    } else if playLocalButton.contains(nodeAtPoint) {
      loadGameScene(gameType: GameType.localMatch)
    } else if findMatchButton.contains(nodeAtPoint) {
      // TODO: Add code to open find match
    } else if gameCenterButton.contains(nodeAtPoint) {
      // TODO: Add code to open Game Center
    }
    
    // ** TEST CODE (For Simulator Only) **
    // This code lets you easily test win/lose scene
    // without having to play the game
    #if targetEnvironment(simulator)
    if chipsButton.contains(nodeAtPoint) {
      loadGameOverScene(isWinner: false)
    }
    else if diceButton.contains(nodeAtPoint) {
      loadGameOverScene(isWinner: true)
    }
    #endif
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches {self.touchDown(atPoint: t.location(in: self))}
  }
}
