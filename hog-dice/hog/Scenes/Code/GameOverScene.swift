//
//  GameOverScene.swift
//  hog
//
//  Created by Tammy Coron on 10/31/2020.
//  Copyright © 2020 Just Write Code LLC. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
  
  // MARK: - PROPERTIES
  
  var isWinner: Bool = false
  
  private lazy var leaderboardButton: SKSpriteNode = {
    childNode(withName: "button_leaderboard") as! SKSpriteNode
  }()
  
  private lazy var achievementsButton: SKSpriteNode = {
    childNode(withName: "button_achievements") as! SKSpriteNode
  }()
  
  private lazy var lobbyButton: SKSpriteNode = {
    childNode(withName: "button_lobby") as! SKSpriteNode
  }()
  
  private lazy var winNode: SKNode = {
    childNode(withName: "win_node")!
  }()
  
  private lazy var loseNode: SKNode = {
    childNode(withName: "lose_node")!
  }()
  
  // MARK: - INIT METHODS
  
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    
    if isWinner == true {
      winNode.alpha = 1
      loseNode.alpha = 0
      
      GameData.shared.wins += 1
      
    } else {
      winNode.alpha = 0
      loseNode.alpha = 1
    }
    
    // Save local data
    GameData.shared.saveDataWithFileName("gamedata.json")
    
    // TODO: Add code to report score and achievements
  }
  
  // MARK: - TOUCH HANDLERS
  
  /* ############################################################ */
  /*                 TOUCH HANDLERS STARTS HERE                   */
  /* ############################################################ */
  
  func touchDown(atPoint pos : CGPoint) {
    let nodeAtPoint = atPoint(pos)
    
    if leaderboardButton.contains(nodeAtPoint) {
      // TODO: Add code to open Leaderboards
    } else if achievementsButton.contains(nodeAtPoint) {
      // TODO: Add code to open Achievements
    } else if lobbyButton.contains(nodeAtPoint) {
      loadLobbyScene()
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches {self.touchDown(atPoint: t.location(in: self))}
  }
}
