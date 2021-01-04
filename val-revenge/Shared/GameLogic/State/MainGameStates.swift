//
//  MainGameStates.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 04.01.21.
//  Copyright © 2021 backslash-f. All rights reserved.
//

import GameplayKit

class PauseState: GKState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass == PlayingState.self
    }
}

class PlayingState: GKState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass == PauseState.self
    }
}
