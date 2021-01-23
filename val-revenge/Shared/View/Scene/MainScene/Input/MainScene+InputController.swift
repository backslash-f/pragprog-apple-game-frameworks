//
//  MainScene+InputController.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 10.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import GameController

/// Handles controller inputs via controllers (*Dualshock*, *Xbox*, *Siri Remote*, etc).
extension MainScene {

    // MARK: - Interface

    func setupGameControllerListener() {
        gcOverseer.$isGameControllerConnected
            .sink { [weak self] isConnected in
                if isConnected {
                    self?.setupControllers()
                } else {
                    self?.mainGameStateMachine.enter(PauseState.self) // required by Apple
                }
            }
            .store(in: &cancellables)
    }

    func setupControllers() {
        guard let gamepadController = gcOverseer.controllers().last,
              let extendedGamepadController = gamepadController.extendedGamepad else {
            ValsRevenge.log("No extended gamepad controllers detected", category: .inputController)
            return // Micro controllers are not supported for this game.
        }
        gamepadController.playerIndex = .index1
        setup(extendedGamepadController)
    }
}

// MARK: - Private

private extension MainScene {

    func setup(_ extendedGamepadController: GCExtendedGamepad) {
        extendedGamepadController.dpad.valueChangedHandler = directionalControlHandler()
        extendedGamepadController.leftThumbstick.valueChangedHandler = directionalControlHandler()
        extendedGamepadController.rightThumbstick.valueChangedHandler = attackControlHandler()
    }

    /// Controls the player movement.
    ///
    /// Range: -1...1 | < 0 = Left | > 0 = Right | < 0 = Down | > 0 = Up
    func directionalControlHandler() -> GCControllerDirectionPadValueChangedHandler {
        return { [weak self] _, xValue, yValue in
            guard let self = self else { return }
            let position = self.location(xValue: xValue, yValue: yValue)
            self.controllerMovement?.moveJoystick(pos: position)
            self.startGame()
        }
    }

    /// Controls the player attack.
    ///
    /// Range: -1...1 | < 0 = Left | > 0 = Right | < 0 = Down | > 0 = Up
    func attackControlHandler() -> GCControllerDirectionPadValueChangedHandler {
        return { [weak self] _, xValue, yValue in
            guard let self = self else { return }
            let position = self.location(xValue: xValue, yValue: yValue)
            self.controllerAttack?.moveJoystick(pos: position)
            self.startGame()
        }
    }

    func location(xValue: Float, yValue: Float) -> CGPoint {
        let multiplier = Float(controllerAttack?.range ?? 0.0)
        let xAxis = CGFloat(xValue * multiplier)
        let yAxis = CGFloat(yValue * multiplier)
        return CGPoint(x: xAxis, y: yAxis)
    }
}
