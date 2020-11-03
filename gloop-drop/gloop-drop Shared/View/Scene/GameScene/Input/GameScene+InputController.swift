//
//  GameScene+InputController.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 26.10.20.
//

import SwiftUI
import GameController

#warning("TODO: test all platforms")

/// Handles controller inputs (users interacting with the game via controllers: *Dualshock*, *Xbox*, *Siri Remote*, etc).
extension ​GameScene​ {

    func setupControllers() {
        setupExtendedControllers()
        setupMicroControllers()
    }

    func setupExtendedControllers() {
        // Ideally the `-[GCController playerIndex]` property should be used, but as this is just single
        // player game, just get the first one and move on.
        guard let extendedGamepadController = gcOverseer.controllers().first?.extendedGamepad else {
            GloopDropApp.log("No extended gamepad controllers detected", category: .inputController)
            return
        }

        let directionalControlHandler: GCControllerDirectionPadValueChangedHandler = {
            [weak self] thumbstick, _, _ in
            self?.isLeftPressed = thumbstick.left.isPressed
            self?.isRightPressed = thumbstick.right.isPressed
        }

        extendedGamepadController.leftThumbstick.valueChangedHandler = directionalControlHandler
        extendedGamepadController.dpad.valueChangedHandler = directionalControlHandler
    }

    func setupMicroControllers() {
        #warning("TODO: could the logic encapsulated for both extended and micro controllers?")
    }

    func pollControllerInput() {
        if isRightPressed {
            movePlayerToRight()
        } else if isLeftPressed {
            movePlayerToLeft()
        }
    }
}

// MARK: - Private

private extension ​GameScene​ {

    func movePlayerToRight() {
        let newPosition = CGPoint(
            x: blobPlayer.position.x + blobPlayer.travelUnitsController,
            y: blobPlayer.position.y
        )
        blobPlayer.move(to: newPosition)
    }

    func movePlayerToLeft() {
        let newPosition = CGPoint(
            x: blobPlayer.position.x - blobPlayer.travelUnitsController,
            y: blobPlayer.position.y
        )
        blobPlayer.move(to: newPosition)
    }
}
