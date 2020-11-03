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
        guard let extendedGamepadController = GCController.controllers().first?.extendedGamepad else {
            GloopDropApp.log("No extended gamepad controllers detected", category: .inputController)
            return
        }

        #warning("TODO: could be encapsulated for both extended and micro controllers?")
        // Move toward the direction of the axis.
        //let displacement = SIMD2<Float>(x: x, y: y)
        //GloopDropApp.log("\(displacement)", category: .inputController)
        let leftThumbstickHandler: GCControllerDirectionPadValueChangedHandler = {
            [weak self] leftThumbstick, x, y in
            switch leftThumbstick {
            case leftThumbstick.left where leftThumbstick.left.value >= 0:
                while leftThumbstick.left.isPressed {
                    #warning("TODO: move to the left")
                }
            case leftThumbstick.left where leftThumbstick.right.value >= 0:
                while leftThumbstick.right.isPressed {
                    #warning("TODO: move to the right")
                }
            default:
                break
            }
        }

        extendedGamepadController.leftThumbstick.valueChangedHandler = leftThumbstickHandler
    }

    func setupMicroControllers() {
        #warning("TODO: setup micro controllers")
    }
}
