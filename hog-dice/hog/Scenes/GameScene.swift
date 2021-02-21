//
//  GameScene.swift
//  hog
//
//  Created by Tammy Coron on 10/28/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  
  // MARK: - PROPERTIES
  
  var entities = [GKEntity]()
  var graphs = [String : GKGraph]()
  
  private var lastUpdateTime : TimeInterval = 0
  
  // Properties (Buttons)
  private lazy var lobbyButton: SKSpriteNode = {
    childNode(withName: "button_lobby") as! SKSpriteNode
  }()
  
  private lazy var rollButton: SKSpriteNode = {
    childNode(withName: "button_roll") as! SKSpriteNode
  }()
  
  private lazy var passButton: SKSpriteNode = {
    childNode(withName: "button_pass") as! SKSpriteNode
  }()
  
  // Properties (In-Game Play)
  private lazy var dice: SKSpriteNode = {
    childNode(withName: "dice") as! SKSpriteNode
  }()
  
  private lazy var message: SKLabelNode = {
    childNode(withName: "message") as! SKLabelNode
  }()
  
  private lazy var yourScore: SKSpriteNode = {
    childNode(withName: "your_score") as! SKSpriteNode
  }()
  
  private lazy var theirScore: SKSpriteNode = {
    childNode(withName: "their_score") as! SKSpriteNode
  }()
  
  private var gameModel = GameModel()
  
  private var pulseAction: SKAction {
    let scaleDown = SKAction.scale(to: 0.85, duration: 0.3)
    let scaleUp = SKAction.scale(to: 1.0, duration: 0.3)
    let scaleSequence = SKAction.sequence([scaleDown, scaleUp])
    
    let fadeIn = SKAction.fadeIn(withDuration: 0.3)
    let fadeOut = SKAction.fadeOut(withDuration: 0.3)
    let fadeSequence = SKAction.sequence([fadeOut, fadeIn])
    
    return SKAction.group([scaleSequence, fadeSequence])
  }
  
  // MARK: - INIT METHODS
  
  override func sceneDidLoad() {
    self.lastUpdateTime = 0
  }
  
  override func didMove(to view: SKView) {
    setupLocalGame()
  }
  
  // MARK: - GAMEPLAY METHODS
  
  func setupLocalGame() {
    let player1 = Player(name: "Player 1", isHuman: true)
    player1.scorecard = yourScore
    
    let player2 = Player(name: "Player 2", isHuman: true)
    player2.scorecard = theirScore
    
    gameModel.addPlayers(p1: player1, p2: player2)
  }
  
  func rollDice() {
    
    guard gameModel.playerCanRoll() else {
      print("*** Player can't roll right now! ***")
      return
    }
    
    print("Player is rolling...")
    
    message.text = "🎲🎲🎲🎲🎲🎲"
    message.run(SKAction.repeatForever(pulseAction), withKey: "pulse")
    
    let roll = gameModel.rollDice()
    
    // Roll the die
    dice.run(roll.animation, completion: {
      self.dice.texture = self.gameModel.diceTextures[roll.number - 1]
      
      self.message.removeAction(forKey: "pulse")
      
      if roll.number == 1 {
        self.message.text = "You pushed your luck!"
        
        self.gameModel.resetRoll()
        self.gameModel.rollBackPointsThisRound()
        
        self.passPlay()
        
      } else {
        self.message.text = "Player rolled a \(roll.number)."
        
        self.gameModel.updatePointsThisRound(roll.number)
        self.gameModel.updateTotalPoints(roll.number)
        
        self.gameModel.resetRoll()
      }
    })
  }
  
  func passPlay() {
    gameModel.nextPlayer()
  }
  
  func visitLobby() {
    
  }
  
  // MARK: - TOUCH METHODS
  
  func touchDown(atPoint pos : CGPoint) {
    let nodeAtPoint = atPoint(pos)
    
    if rollButton.contains(nodeAtPoint) {
      rollDice()
    } else if passButton.contains(nodeAtPoint) {
      passPlay()
    } else if lobbyButton.contains(nodeAtPoint) {
      visitLobby()
    }
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    
  }
  
  func touchUp(atPoint pos : CGPoint) {
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchDown(atPoint: t.location(in: self)) }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
  }
  
  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
    
    // Initialize _lastUpdateTime if it has not already been
    if (self.lastUpdateTime == 0) {
      self.lastUpdateTime = currentTime
    }
    
    // Calculate time since last update
    let dt = currentTime - self.lastUpdateTime
    
    // Update entities
    for entity in self.entities {
      entity.update(deltaTime: dt)
    }
    
    self.lastUpdateTime = currentTime
  }
}
