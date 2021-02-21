//
//  PlayerStates.swift
//  hog
//
//  Created by Tammy Coron on 10/31/2020.
//  Copyright © 2020 Just Write Code LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class WaitingForTurn: GKState {
  unowned let player: Player
  
  init(player: Player) {
    self.player = player
    super.init()
  }
  
  override func didEnter(from previousState: GKState?) {
    player.endTurn()
  }
  
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass == TurnInProgress.self
  }
}

class TurnInProgress: GKState {
  unowned let player: Player
  
  init(player: Player) {
    self.player = player
    super.init()
  }
  
  override func didEnter(from previousState: GKState?) {
    player.beginTurn()
  }
  
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass == RollInProgress.self ||
      stateClass == WaitingForTurn.self
  }
}

class RollInProgress: GKState {
  unowned let player: Player
  
  init(player: Player) {
    self.player = player
    super.init()
  }
  
  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass == TurnInProgress.self
  }
}
