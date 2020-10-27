//
//  GameScene+InputController.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 26.10.20.
//

import Foundation

#warning("TODO: test all platforms")

/// Handles controller inputs (users interacting with the game via controllers: *Dualshock*, *Xbox*, *Siri Remote*, etc).
extension ​GameScene​ {

    func setupControllers() {
        setupExtendedControllers()
        setupMicroControllers()
    }

    func setupExtendedControllers() {
        // Ideally the `-[GCController playerIndex]` property should be used, but as this is just single player game,
        // just get the first one and move on.
        guard let extendedGamepadController = gcOverseer.extendedGamepadControllers().first?.extendedGamepad else {
            GloopDropApp.log("No extended gamepad controllers detected", category: .inputController)
            return
        }

        #warning("TODO: could be encapsulated for both extended and micro controllers?")
        extendedGamepadController.valueChangedHandler = { [weak self] gamepad, element in
            guard let self = self else { return }
            switch element {
            case gamepad.leftThumbstick where gamepad.leftThumbstick.left.isPressed:
                let value = CGFloat(gamepad.leftThumbstick.left.value)
                let player = self.blobPlayer
                GloopDropApp.log(
                    "Left thumbstick pressed. Value: \(value)",
                    category: .inputController
                )
                let duration = TimeInterval(1 / player.baseSpeed) / 255
                let delta: CGFloat = player.position.x + player.baseSpeed
                let newPosition = CGPoint(x: delta, y: player.position.y)
                player.move(to: newPosition, direction: .left, duration: duration)
            case gamepad.rightThumbstick:
                GloopDropApp.log(
                    "Right thumbstick pressed. Value: \(gamepad.rightThumbstick.left.value)",
                    category: .inputController
                )
                // Do I need .right.value?
                // Do I need .right.isPressed == false?
                #warning("TODO: go to right ")
            case gamepad.dpad where gamepad.dpad.left.isPressed:
                GloopDropApp.log(
                    "Dpad left thumbstick pressed",
                    category: .inputController
                )
                // Do I need .left.isPressed == false?
                #warning("TODO: go to left")
            // Do I need .right.isPressed == false?
            case gamepad.dpad where gamepad.dpad.right.isPressed:
                GloopDropApp.log(
                    "Dpad right thumbstick pressed",
                    category: .inputController
                )
                #warning("TODO: go to right")
            default:
                break
            }
        }
    }

    func setupMicroControllers() {
        #warning("TODO: setup micro controllers")
    }
}
