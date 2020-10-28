//
//  GameScene+InputController.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 26.10.20.
//

import SwiftUI

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

        #warning("FIXME: Choppy movement. Investigate")

        #warning("TODO: could be encapsulated for both extended and micro controllers?")
        extendedGamepadController.valueChangedHandler = { [weak self] gamepad, element in
            switch element {

            // ⬅️
            case gamepad.leftThumbstick
                    where gamepad.leftThumbstick.left.value > 0
                    && gamepad.leftThumbstick.left.isPressed:
                self?.move(toRight: false)

            case gamepad.dpad
                    where gamepad.dpad.left.value > 0
                    && gamepad.dpad.left.isPressed:
                self?.move(toRight: false)

            // ➡️
            case gamepad.leftThumbstick
                    where gamepad.leftThumbstick.right.value > 0
                    && gamepad.leftThumbstick.right.isPressed:
                self?.move(toRight: true)

            case gamepad.dpad
                    where gamepad.dpad.right.value > 0
                    && gamepad.dpad.right.isPressed:
                self?.move(toRight: true)

            default:
                break
            }
        }
    }

    func setupMicroControllers() {
        #warning("TODO: setup micro controllers")
    }
}

// MARK: - Private

fileprivate extension ​GameScene​ {

    /// Moves the player to the right or to the left.
    ///
    /// - Parameter toRight: If `true`, the player will move to the right. If `false`, the player will move to the left.
    func move(toRight: Bool) {
        let distance = toRight ? blobPlayer.controllerTravelUnits : -blobPlayer.controllerTravelUnits
        let newPosition = CGPoint(
            x: blobPlayer.position.x + distance,
            y: blobPlayer.position.y
        )
        blobPlayer.move(to: newPosition)
    }
}
