//
//  Player.swift
//  hog
//
//  Created by Tammy Coron on 10/31/20.
//

import SpriteKit
import GameplayKit

class Player: NSObject {
  
  var mainStateMachine: GKStateMachine!
  
  var name: String!
  var isHuman: Bool!
  
  var totalPoints: Int = 0 {
    didSet {
      tPointsLabel?.text = "\(totalPoints)"
    }
  }
  
  var pointsThisRound: Int = 0 {
    didSet {
      rPointsLabel?.text = "\(pointsThisRound)"
    }
  }
  
  var totalRolls: Int = 0
  var rollsThisRound: Int = 0
  
  weak var scorecard: SKSpriteNode?
  
  lazy var tPointsLabel: SKLabelNode? = {
    scorecard?.childNode(withName: "totalPoints") as? SKLabelNode
  }()
  
  lazy var rPointsLabel: SKLabelNode? = {
    scorecard?.childNode(withName: "roundPoints") as? SKLabelNode
  }()
  
  lazy var turnIndicator: SKSpriteNode? = {
    scorecard?.childNode(withName: "turnIndicator") as? SKSpriteNode
  }()
  
  init(_ pNumber: Int = 0, name: String = "Computer", isHuman: Bool = false) {
    
    super.init()
    
    self.name = name
    self.isHuman = isHuman
    
    self.mainStateMachine =
      GKStateMachine(states: [WaitingForTurn(player: self),
                              TurnInProgress(player: self),
                              RollInProgress(player: self)])
  }
  
  func beginTurn() {
    turnIndicator?.alpha = 1
  }
  
  func rolled(_ number: Int) {
    mainStateMachine.enter(TurnInProgress.self)
  }
  
  func endTurn() {
    turnIndicator?.alpha = 0
  }
}
