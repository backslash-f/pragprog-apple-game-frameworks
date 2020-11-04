//
//  GameScene+InputController.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 26.10.20.
//

import SwiftUI
import GameController

/// Handles controller inputs (users interacting with the game via controllers: *Dualshock*, *Xbox*, *Siri Remote*, etc).
extension ​GameScene​ {

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
    }

    func pollControllerInput() {
        if isLeftPressed {
            movePlayerToLeft()
        } else if isRightPressed {
            movePlayerToRight()
        }
    }
}

// MARK: - Private

private extension ​GameScene​ {

    func directionalControlHandler() -> GCControllerDirectionPadValueChangedHandler {
        { [weak self] thumbstickOrDpad, x, y in
            self?.isLeftPressed = thumbstickOrDpad.left.isPressed
            self?.isRightPressed = thumbstickOrDpad.right.isPressed
        }
    }

    func movePlayerToLeft() {
        let newPosition = CGPoint(
            x: blobPlayer.position.x - blobPlayer.travelUnitsController,
            y: blobPlayer.position.y
        )
        blobPlayer.move(to: newPosition)
    }

    func movePlayerToRight() {
        let newPosition = CGPoint(
            x: blobPlayer.position.x + blobPlayer.travelUnitsController,
            y: blobPlayer.position.y
        )
        blobPlayer.move(to: newPosition)
    }
}
