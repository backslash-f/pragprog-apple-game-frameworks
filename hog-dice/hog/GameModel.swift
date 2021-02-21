//
//  GameModel.swift
//  hog
//
//  Created by Tammy Coron on 10/31/20.
//

import SpriteKit
import GameplayKit

class GameModel: NSObject {
  
  // MARK: - Properties
  
  var winningScore: Int = 50
  
  // Imminent loss, be aggressive
  private lazy var agressive: Int = {
    Int(getPercentageValue(for: Double(winningScore), percent: 30))
    // 15 (30% of 50)
  }()
  
  // Comfortable lead
  private lazy var comfortable: Int = {
    Int(getPercentageValue(for: Double(winningScore), percent: 15))
    // 7 (15% of 50)
  }()
  
  // General case
  private lazy var general: Int = {
    Int(getPercentageValue(for: Double(winningScore), percent: 20))
    // 10 (20% of 50)
  }()
  
  
  var currentPlayerId: Int = 1
  var currentPlayer: Player?
  
  var localPlayers: [Player] = []
  
  let diceTextures = SKTexture.loadTextures(atlas: "dice",
                                            prefix: "dice_",
                                            startsAt: 1,
                                            stopsAt: 6)
  
  // MARK: - Player Methods
  
  func addPlayers(p1: Player, p2: Player) {
    localPlayers.removeAll()
    
    localPlayers.append(p1)
    localPlayers.append(p2)
    
    nextPlayer()
  }
  
  func nextPlayer() {
    // Set current player to waiting state
    localPlayers[currentPlayerId].mainStateMachine.enter(WaitingForTurn.self)
    
    // Reset round points and the number of rolls
    localPlayers[currentPlayerId].pointsThisRound = 0
    localPlayers[currentPlayerId].rollsThisRound = 0
    
    // Set next player as the new current player
    currentPlayerId = currentPlayerId == 0 ? 1 : 0
    currentPlayer = localPlayers[currentPlayerId]
    
    // Set new current player to turn in progress state
    localPlayers[currentPlayerId].mainStateMachine.enter(TurnInProgress.self)
  }
  
  // MARK: - Helper Methods
  
  func getPercentageValue(for value: Double, percent: Double) -> Double {
    return value * (percent / 100)
  }
  
  func getPlayerScores() -> (player1: Int, player2: Int){
    let p1 = localPlayers[0].totalPoints
    let p2 = localPlayers[1].totalPoints
    
    return (p1, p2)
  }
  
  func getPlayerRoles() -> (player1: Int, player2: Int){
    let p1 = localPlayers[0].totalRolls
    let p2 = localPlayers[1].totalRolls
    
    return (p1, p2)
  }
  
  // MARK: - Gameplay Methods
  
  func playerCanRoll() -> Bool {
    switch localPlayers[currentPlayerId].mainStateMachine.currentState {
    case is TurnInProgress:
      return true
    default:
      return false
    }
  }
  
  func playerShouldRoll(score1: Int, score2: Int) -> Bool {
    
    // Always roll at least once per round
    if localPlayers[currentPlayerId].rollsThisRound == 0 {
      return true
    }
    
    let eightyPercent = Int(getPercentageValue(for: Double(winningScore), percent: 80))
    let tenPercent = Int(getPercentageValue(for: Double(winningScore), percent: 10))
    
    let lead = score1 - score2
    var strategy = general
    
    if (score1 < eightyPercent && score2 >= eightyPercent) {
      strategy = agressive
    } else if (score1 >= eightyPercent && (0 < lead && lead <= tenPercent)) {
      strategy = comfortable
    }
    
    // print("80%: \(eightyPercent) | 10%: \(tenPercent)")
    // print("lead: \(lead)")
    // print("general: \(general) | comfortable: \(comfortable) | aggressive: \(agressive)")
    
    return lead <= strategy
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
  
  // Update Points
  func updatePointsThisRound(_ points: Int) {
    localPlayers[currentPlayerId].pointsThisRound += points
  }
  
  func updateTotalPoints(_ points: Int) {
    localPlayers[currentPlayerId].totalPoints += points
  }
  
  func rollBackPointsThisRound() {
    localPlayers[currentPlayerId].totalPoints -= localPlayers[currentPlayerId].pointsThisRound
  }
  
  // Update Rolls
  func updateRollsThisRound(_ number: Int = 1) {
    localPlayers[currentPlayerId].rollsThisRound += number
  }
  
  func updateTotalRolls(_ number: Int = 1) {
    localPlayers[currentPlayerId].totalRolls += number
  }
  
  func declareWinner() -> Bool {
    if localPlayers[currentPlayerId].totalPoints >= winningScore {
      return true
    }
    return false
  }
}
