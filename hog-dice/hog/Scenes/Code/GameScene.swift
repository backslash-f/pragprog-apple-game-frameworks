//
//  GameScene.swift
//  hog
//
//  Created by Tammy Coron on 10/31/2020.
//  Copyright © 2020 Just Write Code LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

// MARK: - GAME TYPES

enum GameType {
  case soloMatch
  case localMatch
  case remoteMatch
}

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
  
  // Preload button textures
  let rollButtonTextureEnabled = SKTexture(imageNamed: "button_roll")
  let rollButtonTextureDisabled = SKTexture(imageNamed: "button_roll_disabled")
  
  let passButtonTextureEnabled = SKTexture(imageNamed: "button_pass")
  let passButtonTextureDisabled = SKTexture(imageNamed: "button_pass_disabled")
  
  // Properties (In-Game Play)
  private lazy var dice: SKSpriteNode = {
    childNode(withName: "dice") as! SKSpriteNode
  }()
  
  private lazy var message: SKLabelNode = {
    childNode(withName: "message") as! SKLabelNode
  }()
  
  private lazy var rollsThisRound: SKLabelNode = {
    childNode(withName: "rolls_this_round") as! SKLabelNode
  }()
  
  private lazy var yourScore: SKSpriteNode = {
    childNode(withName: "your_score") as! SKSpriteNode
  }()
  
  private lazy var theirScore: SKSpriteNode = {
    childNode(withName: "their_score") as! SKSpriteNode
  }()
  
  // Pre-load shared action
  private var pulseAction: SKAction {
    let scaleDown = SKAction.scale(to: 0.85, duration: 0.3)
    let scaleUp = SKAction.scale(to: 1.0, duration: 0.3)
    let scaleSequence = SKAction.sequence([scaleDown, scaleUp])
    
    let fadeIn = SKAction.fadeIn(withDuration: 0.3)
    let fadeOut = SKAction.fadeOut(withDuration: 0.3)
    let fadeSequence = SKAction.sequence([fadeOut, fadeIn])
    
    return SKAction.group([scaleSequence, fadeSequence])
  }
  
  // Gameplay Properties
  private var gameModel = GameModel()
  var gameType: GameType = GameType.soloMatch
  
  // TODO: Add Game Center-related properties
  
  // MARK: - INIT METHODS
  
  override func sceneDidLoad() {
    self.lastUpdateTime = 0
  }
  
  override func didMove(to view: SKView) {
    // Set up the game based on its type
    switch gameType {
    case .soloMatch:
      setupSoloGame()
    case .localMatch:
      setupLocalGame()
    case .remoteMatch:
      setupRemoteGame()
      
    // TODO: Add Game Center Observers
    }
  }
  
  // TODO: Add Game Center Notification Handlers
  
  // MARK: - GAME SET UP METHODS
  
  func setupSoloGame() {
    let player1 = Player(isHuman: true)
    player1.scorecard = yourScore
    
    let player2 = Player(isHuman: false)
    player2.scorecard = theirScore
    
    gameModel.addPlayers(p1: player1, p2: player2)
  }
  
  func setupLocalGame() {
    let player1 = Player(isHuman: true)
    player1.scorecard = yourScore
    
    let player2 = Player(isHuman: true)
    player2.scorecard = theirScore
    
    gameModel.addPlayers(p1: player1, p2: player2)
  }
  
  // MARK: - Remote Game Helpers
  
  func setupRemoteGame() {
    let player1 = Player(isHuman: true)
    player1.scorecard = yourScore
    
    let player2 = Player(isHuman: true)
    player2.scorecard = theirScore
    
    gameModel.addPlayers(p1: player1, p2: player2)
    
    // TODO: Add code to set up the game
  }
  
  func processEndTurnForRemoteGame() {
    // TODO: Add code to end the turn
  }
  
  // MARK: - PROCESS TAP METHODS
  
  func processLobbyButtonTap() {
    loadLobbyScene()
  }
  
  func processRollButtonTap() {
    // Verify its the current player's turn
    if gameModel.currentPlayer?.mainStateMachine.currentState is TurnInProgress {
      
      // Take action based on game type
      switch gameType {
      case .soloMatch, .remoteMatch:
        if gameModel.currentPlayerIndex == 0 {
          rollDice()
        }
      case .localMatch:
        rollDice()
      }
    }
  }
  
  func processPassButtonTap() {
    // Verify its the current player's turn
    if gameModel.currentPlayer?.mainStateMachine.currentState is TurnInProgress {
      
      // Take action based on game type
      switch gameType {
      case .soloMatch, .remoteMatch:
        if gameModel.currentPlayerIndex == 0 {
          passPlay()
        }
      case .localMatch:
        passPlay()
      }
    }
  }
  
  // MARK: - GAMEPLAY METHODS
  
  func rollDice(_ number: Int = 0) {
    
    // Show "player rolling" message
    message.text = "🎲🎲🎲🎲🎲🎲"
    message.run(SKAction.repeatForever(pulseAction), withKey: "pulse")
    
    // Visually disable pass and roll buttons
    rollButton.texture = rollButtonTextureDisabled
    passButton.texture = passButtonTextureDisabled
    
    // Use the game model to set up the roll
    let roll = gameModel.roll()
    
    // Check if the outcome of the roll is already known
    let numberRolled: Int = number > 0 ? number : roll.number
    
    // Roll the die
    dice.run(roll.animation, completion: {
      self.dice.texture = self.gameModel.diceTextures[numberRolled - 1]
      
      self.message.removeAction(forKey: "pulse")
      
      if roll.number == 1 {
        self.message.text = "Don't be a Hog!"
        
        // Reset the roll and pass play
        self.gameModel.resetRoll()
        self.gameModel.rollBackPointsThisRound()
        
        self.passPlay()
        
      } else {
        self.message.text = "Player Rolled a \(numberRolled)"
        
        // Visually enable pass and roll buttons
        self.rollButton.texture = self.rollButtonTextureEnabled
        self.passButton.texture = self.passButtonTextureEnabled
        
        // Update the points
        self.gameModel.updatePointsThisRound(numberRolled)
        self.gameModel.updateTotalPoints(numberRolled)
        
        self.gameModel.updateRollsThisRound()
        self.gameModel.updateTotalRolls()
        
        // Update the number of rolls
        let rolls = self.gameModel.currentPlayer?.rollsThisRound
        self.rollsThisRound.text = "— rolls this round: \(rolls ?? 0) —"
        
        // Check for a winner
        if self.gameModel.declareWinner() == true {
          self.endGame()
        } else {
          self.gameModel.resetRoll()
        }
        
        // If needed, pass play to the AI in a solo match
        if self.gameType == .soloMatch
            && self.gameModel.currentPlayer?.isHuman == false {
          self.startAIMove()
        }
      }
    })
  }
  
  func passPlay() {
    
    // Move play to the next player in the game model
    gameModel.nextPlayer()
    
    // Visually disable pass and roll buttons
    rollButton.texture = rollButtonTextureDisabled
    passButton.texture = passButtonTextureDisabled
    
    // Reset rolls this round text for all game types
    rollsThisRound.text = "— rolls this round: 0 —"
    
    // Take action based on game type
    switch gameType {
    case .soloMatch:
      if gameModel.currentPlayer?.isHuman == false {
        // Begin the AI's turn
        startAIMove()
      } else {
        // Visually enable pass and roll buttons
        rollButton.texture = rollButtonTextureEnabled
        passButton.texture = passButtonTextureEnabled
      }
    case .localMatch:
      // Visually enable pass and roll buttons
      rollButton.texture = rollButtonTextureEnabled
      passButton.texture = passButtonTextureEnabled
    case .remoteMatch:
      // Process the end of the player's turn
      self.processEndTurnForRemoteGame()
    }
  }
  
  func endGame() {
    
    // Determine which player won
    var isWinner: Bool
    if self.gameModel.currentPlayerIndex == 0 {
      isWinner = true
    } else {
      isWinner = false
    }
    
    // TODO: Add code to end Game Center game
    
    self.loadGameOverScene(isWinner: isWinner)
  }
  
  // MARK: - ARTIFICIAL INTELLIGENCE SUPPORT
  
  func startAIMove() {
    DispatchQueue.global().async { [unowned self] in
      let strategistTime = CFAbsoluteTimeGetCurrent()
      let delta = CFAbsoluteTimeGetCurrent() - strategistTime
      
      let aiTimeCeiling = 0.75
      let delay = max(delta, aiTimeCeiling)
      
      DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        self.processAIMove()
      }
    }
  }
  
  func processAIMove() {
    let playerPoints = gameModel.getPlayerPoints()
    let shouldRoll = gameModel.playerShouldRoll(score1: playerPoints.player2,
                                                score2: playerPoints.player1)
    if shouldRoll == true {
      rollDice()
    } else {
      passPlay()
    }
  }
  
  // MARK: - TOUCH HANDLERS
  
  /* ############################################################ */
  /*                 TOUCH HANDLERS STARTS HERE                   */
  /* ############################################################ */
  
  func touchDown(atPoint pos : CGPoint) {
    let nodeAtPoint = atPoint(pos)
    
    if rollButton.contains(nodeAtPoint) {
      processRollButtonTap()
    } else if passButton.contains(nodeAtPoint) {
      processPassButtonTap()
    } else if lobbyButton.contains(nodeAtPoint) {
      processLobbyButtonTap()
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchDown(atPoint: t.location(in: self)) }
  }
  
  // MARK: - SCENE UPDATE METHODS
  
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
