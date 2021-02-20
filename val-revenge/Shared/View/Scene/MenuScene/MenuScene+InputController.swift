//
//  MenuScene+InputController.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 20.02.21.
//  Copyright © 2021 backslash-f. All rights reserved.
//

import GCOverseer
import GameController

/// Handles controller inputs via controllers (*Dualshock*, *Xbox*, *Siri Remote*, etc).
extension MenuScene {

    // MARK: - Interface

    func setupGameControllerListener() {
        gcOverseer.$isGameControllerConnected
            .sink { [weak self] isConnected in
                if isConnected {
                    self?.setupControllers()
                    self?.view?.isPaused = false
                } else {
                    self?.view?.isPaused = true
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private

private extension MenuScene {

    func setupControllers() {
        guard let extendedGamepadController = gcOverseer.controllers().compactMap({ $0.extendedGamepad }).first else {
            ValsRevenge.log("No extended gamepad controllers detected", category: .inputController)
            return // Micro controllers are not supported for this game.
        }
        extendedGamepadController.controller?.playerIndex = .index1
        setup(extendedGamepadController)
    }

    func setup(_ extendedGamepadController: GCExtendedGamepad) {
        extendedGamepadController.buttonA.valueChangedHandler = startButtonHandler()
        extendedGamepadController.buttonX.valueChangedHandler = resumeButtonHandler()
    }

    /// 􀁡 in a DualShock controller.
    func startButtonHandler() -> GCControllerButtonValueChangedHandler {
        return { [weak self] _, _, _ in
            self?.startNewGame()
        }
    }

    /// 􀨄 in a DualShock controller.
    func resumeButtonHandler() -> GCControllerButtonValueChangedHandler {
        return { [weak self] _, _, _ in
            self?.resumeSavedGame()
        }
    }
}
