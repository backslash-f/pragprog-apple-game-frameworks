//
//  MainScene+InputController.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 26.10.20.
//

import SwiftUI
import GameController

/// Handles controller inputs via controllers (*Dualshock*, *Xbox*, *Siri Remote*, etc).
extension MainScene {

    func setupControllers() {
        setupExtendedControllers()
        setupMicroControllers()
    }

    func setupExtendedControllers() {
        guard let extendedGamepadController = gcOverseer.controllers().first?.extendedGamepad else {
            GloopDropApp.log("No extended gamepad controllers detected", category: .inputController)
            return
        }
        extendedGamepadController.leftThumbstick.valueChangedHandler = directionalControlHandler()
        extendedGamepadController.dpad.valueChangedHandler = directionalControlHandler()
        extendedGamepadController.buttonX.valueChangedHandler = buttonXHandler()
    }

    func setupMicroControllers() {
        guard let microGamepadController = gcOverseer.controllers().first?.microGamepad else {
            GloopDropApp.log("No micro gamepad controllers detected", category: .inputController)
            return
        }
        // Couldn't get rotation to work:
        // https://developer.apple.com/forums/thread/21562?page=1#644496022
        microGamepadController.allowsRotation = true
        microGamepadController.dpad.valueChangedHandler = directionalControlHandler()
        microGamepadController.buttonX.valueChangedHandler = buttonXHandler()
    }

    func pollControllerInput() {
        guard isGameInProgress else {
            return
        }
        if isLeftPressed {
            movePlayerToLeft()
        } else if isRightPressed {
            movePlayerToRight()
        } else if isXButtonPressed {
            startGame()
        }
    }
}

// MARK: - Private

private extension MainScene {

    func directionalControlHandler() -> GCControllerDirectionPadValueChangedHandler {
        return { [weak self] thumbstickOrDpad, _, _ in
            self?.isLeftPressed = thumbstickOrDpad.left.isPressed
            self?.isRightPressed = thumbstickOrDpad.right.isPressed
        }
    }

    /// Notice: The `X` button is the `square` button in a Sony's Dualshock 􀨄
    func buttonXHandler() -> GCControllerButtonValueChangedHandler {
        return { [weak self] _, _, isPressed in
            self?.isXButtonPressed = isPressed
        }
    }

    func movePlayerToLeft() {
        let newPosition = CGPoint(
            x: player.position.x - player.travelUnitsController,
            y: player.position.y
        )
        player.move(to: newPosition)
    }

    func movePlayerToRight() {
        let newPosition = CGPoint(
            x: player.position.x + player.travelUnitsController,
            y: player.position.y
        )
        player.move(to: newPosition)
    }
}
