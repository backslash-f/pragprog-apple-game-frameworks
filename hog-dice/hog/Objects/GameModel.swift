//
//  GameModel.swift
//  hog
//
//  Created by Tammy Coron on 10/31/2020.
//  Copyright © 2020 Just Write Code LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameModel {
  
  // MARK: - PROPERTIES
  
  var winningScore: Int = 25
  
  var currentPlayerIndex: Int = 0
  var currentPlayer: Player?
  
  var players: [Player] = []
  
  let diceTextures = SKTexture.loadTextures(atlas: "dice",
                                            prefix: "dice_",
                                            startsAt: 1,
                                            stopsAt: 6)
  
  // Imminent loss, be aggressive (AI player)
  private lazy var agressive: Int = {
    Int(getPercentageValue(for: Double(winningScore), percent: 30))
  }()
  
  // Comfortable lead (AI player)
  private lazy var comfortable: Int = {
    Int(getPercentageValue(for: Double(winningScore), percent: 15))
  }()
  
  // General case (AI player)
  private lazy var general: Int = {
    Int(getPercentageValue(for: Double(winningScore), percent: 20))
  }()
  
  // MARK: - PLAYER METHODS
  
  func addPlayers(p1: Player, p2: Player) {
    
    // Start with an empty array
    players.removeAll()
    
    // Add players to the array
    players.append(p1)
    players.append(p2)
    
    // Set up the initial player state
    players[0].mainStateMachine.enter(TurnInProgress.self)
    players[1].mainStateMachine.enter(WaitingForTurn.self)
    
    // Select the first player
    currentPlayer = players[0]
  }
  
  func nextPlayer() {
    // Set current player to waiting state
    players[currentPlayerIndex].mainStateMachine.enter(WaitingForTurn.self)
    
    // Reset round points and the number of rolls
    players[currentPlayerIndex].pointsThisRound = 0
    players[currentPlayerIndex].rollsThisRound = 0
    
    // Set next player as the new current player
    currentPlayerIndex = currentPlayerIndex == 0 ? 1 : 0
    currentPlayer = players[currentPlayerIndex]
    
    // Set new current player to turn in progress state
    players[currentPlayerIndex].mainStateMachine.enter(TurnInProgress.self)
  }
  
  // MARK: - HELPER METHODS
  
  func getPercentageValue(for value: Double, percent: Double) -> Double {
    return value * (percent / 100)
  }
  
  func getPlayerPoints() -> (player1: Int, player2: Int){
    let p1 = players[0].totalPoints
    let p2 = players[1].totalPoints
    
    return (p1, p2)
  }
  
  func getPlayerRoles() -> (player1: Int, player2: Int){
    let p1 = players[0].totalRolls
    let p2 = players[1].totalRolls
    
    return (p1, p2)
  }
  
  func playerShouldRoll(score1: Int, score2: Int) -> Bool {
    
    // Always roll at least once per round
    if players[currentPlayerIndex].rollsThisRound == 0 {
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
    
    return lead <= strategy
  }
  
  // MARK: - GAMEPLAY METHODS
  
  func roll() -> (number: Int, animation: SKAction) {
    
    // Set current player to rolling state
    players[currentPlayerIndex].mainStateMachine.enter(RollInProgress.self)
    
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
    players[currentPlayerIndex].mainStateMachine.enter(TurnInProgress.self)
  }
  
  // MARK: - UPDATE POINTS
  
  func updatePointsThisRound(_ points: Int) {
    players[currentPlayerIndex].pointsThisRound += points
  }
  
  func updateTotalPoints(_ points: Int) {
    players[currentPlayerIndex].totalPoints += points
  }
  
  func rollBackPointsThisRound() {
    players[currentPlayerIndex].totalPoints -= players[currentPlayerIndex].pointsThisRound
  }
  
  // MARK: - UPDATE ROLLS
  
  func updateRollsThisRound(_ number: Int = 1) {
    players[currentPlayerIndex].rollsThisRound += number
  }
  
  func updateTotalRolls(_ number: Int = 1) {
    players[currentPlayerIndex].totalRolls += number
  }
  
  func declareWinner() -> Bool {
    if players[currentPlayerIndex].totalPoints >= winningScore {
      return true
    }
    return false
  }
}
