//
//  PlayerStates.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 28.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import GameplayKit

class PlayerHasKeyState: GKState {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass == PlayerHasKeyState.self || stateClass == PlayerHasNoKeyState.self
    }

    override func didEnter(from previousState: GKState?) {
        ValsRevenge.log("Entering PlayerHasKeyState", category: .state)
    }

    override func willExit(to nextState: GKState) {
        ValsRevenge.log("Exiting PlayerHasKeyState", category: .state)
    }

    override func update(deltaTime seconds: TimeInterval) {
        ValsRevenge.log("Updating PlayerHasKeyState", category: .state)
    }
}

class PlayerHasNoKeyState: GKState {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass == PlayerHasKeyState.self || stateClass == PlayerHasNoKeyState.self
    }

    override func didEnter(from previousState: GKState?) {
        ValsRevenge.log("Entering PlayerHasNoKeyState", category: .state)
    }

    override func willExit(to nextState: GKState) {
        ValsRevenge.log("Exiting PlayerHasNoKeyState", category: .state)
    }

    override func update(deltaTime seconds: TimeInterval) {
        ValsRevenge.log("Updating PlayerHasNoKeyState", category: .state)
    }
}
