//
//  GameModel.swift
//  hog
//
//  Created by Tammy Coron on 10/31/20.
//

import SpriteKit
import GameplayKit

class Move: NSObject, GKGameModelUpdate {
  var value: Int = 0
  var shouldRoll: Bool
  
  init(shouldRoll: Bool) {
    self.shouldRoll = shouldRoll
  }
}

class GameModel: NSObject, NSCopying, GKGameModel {
  
  // MARK: - Properties
  
  var winningScore: Int = 50
  
  // Imminent loss, be aggressive
  private lazy var poolSize1: Int = {
    Int(getPercentageValue(for: Double(winningScore), percent: 30))
  }()
  
  // Comfortable lead
  private lazy var poolSize2: Int = {
    Int(getPercentageValue(for: Double(winningScore), percent: 15))
  }()
  
  // General case
  private lazy var poolSize3: Int = {
    Int(getPercentageValue(for: Double(winningScore), percent: 20))
  }()
  
  
  var currentPlayerId: Int = 1
  var localPlayers: [Player] = []
  
  var player1: Player {
    return localPlayers[0]
  }
  var player2: Player {
    return localPlayers[1]
  }
  
  let diceTextures = SKTexture.loadTextures(atlas: "dice",
                                            prefix: "dice_",
                                            startsAt: 1,
                                            stopsAt: 6)
  
  // MARK: - Methods
  
  func addPlayers(p1: Player, p2: Player) {
    localPlayers.removeAll()
    
    localPlayers.append(p1)
    localPlayers.append(p2)
    
    nextPlayer()
  }
  
  func playerCanRoll() -> Bool {
    switch localPlayers[currentPlayerId].mainStateMachine.currentState {
    case is RollInProgress:
      return false
    default:
      return true
    }
  }
  
  func playerShouldRoll(poolSize: Int, pScore: Int, oScore: Int) -> Bool {
    if pScore + poolSize >= winningScore {
      return false
    }
    
    let eightyPercent = Int(getPercentageValue(for: Double(winningScore), percent: 80))
    let tenPercent = Int(getPercentageValue(for: Double(winningScore), percent: 10))
    
    let p1Lead = pScore - oScore
    var wantPool = poolSize3
    
    if (pScore < eightyPercent && oScore >= eightyPercent) {
      wantPool = poolSize1
    } else if (pScore >= eightyPercent && (0 < p1Lead && p1Lead <= tenPercent)) {
      wantPool = poolSize2
    }
    
    return poolSize < wantPool
  }
  
  func getPercentageValue(for value: Double, percent: Double) -> Double {
    return value * (percent * 100)
  }
  
  func rollDice() -> (number: Int, animation: SKAction) {
    
    // Set current player to rolling state
    localPlayers[currentPlayerId].mainStateMachine.enter(RollInProgress.self)
    
    // Get dice textures & shuffle them
    let shuffledTextures = diceTextures.shuffled()
    
    // Create an animation using the shuffled textures
    let animation = SKAction.animate(with: shuffledTextures,
                                     timePerFrame: 0.05)
    
    // Simulate a longer roll
    let rollDie = SKAction.repeat(animation, count: 6)
    
    // Use GameplayKit to simulate a dice roll
    let randomDistribution = GKRandomDistribution.d6()
    
    // Return number rolled and supporting animation
    return (randomDistribution.nextInt(), rollDie)
  }
  
  func resetRoll() {
    localPlayers[currentPlayerId].mainStateMachine.enter(TurnInProgress.self)
  }
  
  func updatePointsThisRound(_ points: Int) {
    localPlayers[currentPlayerId].pointsThisRound += points
  }
  
  func updateTotalPoints(_ points: Int) {
    localPlayers[currentPlayerId].totalPoints += points
  }
  
  func rollBackPointsThisRound() {
    localPlayers[currentPlayerId].totalPoints -= localPlayers[currentPlayerId].pointsThisRound
  }
  
  func declareWinner() -> Bool {
    if localPlayers[currentPlayerId].totalPoints >= winningScore {
      return true
    }
    return false
  }
  
  func nextPlayer() {
    
    // Set current player to waiting state
    localPlayers[currentPlayerId].mainStateMachine.enter(WaitingForTurn.self)
    
    // Set next player as the new current player
    currentPlayerId = currentPlayerId == 0 ? 1 : 0
    
    // Set new current player to player state
    localPlayers[currentPlayerId].mainStateMachine.enter(TurnInProgress.self)
  }
  
  func resetScores() {
    for player in localPlayers {
      player.resetScore()
    }
  }
  
  // ===========================================================================
  // NSCopying Protocol
  // ===========================================================================
  
  func copy(with zone: NSZone? = nil) -> Any {
    let copy = GameModel() // or use this code: type(of: self).init()
    copy.setGameModel(self) // this copies the game model state
    return copy
  }
  
  // ===========================================================================
  // GKGameModel Protocol
  // ===========================================================================
  
  private var _players : [GKGameModelPlayer]?
  var players: [GKGameModelPlayer]? {
    get {
      // Return the list of players (both human and AI)
      return _players
    }
  }
  
  private var _activePlayer : GKGameModelPlayer?
  var activePlayer: GKGameModelPlayer? {
    get {
      // Return the active player
      return _activePlayer
    }
  }
  
  func setGameModel(_ gameModel: GKGameModel) {
    // Copy the game model's state (for example, self.xyz = gameModel.xyz)
    if let model = gameModel as? GameModel {
      localPlayers = model.localPlayers
      currentPlayerId = model.currentPlayerId
      winningScore = model.winningScore
    }
  }
  
  func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
    // Create instances of GKGameModelUpdate for every possible move, then return them in an array
    return nil
  }
  
  func apply(_ gameModelUpdate: GKGameModelUpdate) {
    // Have the activePlayer change the game model according to the move described by
    // gameModelUpdate, then switch self.activePlayer to the next (other) player
  }
  
  func score(for player: GKGameModelPlayer) -> Int {
    // From the perspective of player, calculate how desirable the current game model state is.
    // Higher values indicate higher desirability.
    // Use negative values to indicate disadvantage. Zero is neutral.
    // Return Int.min (NSIntegerMin) if the move is not valid.
    
    let poolSize = winningScore - localPlayers[currentPlayerId].totalPoints
    let playerScore = currentPlayerId == 0 ? player1.totalPoints : player2.totalPoints
    let opponentScore = currentPlayerId == 1 ? player2.totalPoints : player1.totalPoints
    
    if playerShouldRoll(poolSize: poolSize, pScore: playerScore, oScore: opponentScore) {
      return 1000
    } else {
      return -1000
    }
  }
}
