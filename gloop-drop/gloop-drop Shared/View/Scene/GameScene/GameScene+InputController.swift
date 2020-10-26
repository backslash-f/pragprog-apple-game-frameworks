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
        extendedGamepadController.valueChangedHandler = { gamepad, element in
            switch element {
            case gamepad.leftThumbstick:
                // Do I need gamepad.leftThumbstick.left.value?
                // Do I need .left.isPressed == false?
                #warning("TODO: got to left")
            case gamepad.rightThumbstick:
                // Do I need .right.value?
                // Do I need .right.isPressed == false?
                #warning("TODO: go to right ")
            case gamepad.dpad where gamepad.dpad.left.isPressed:
                // Do I need .left.isPressed == false?
                #warning("TODO: go to left")
            // Do I need .right.isPressed == false?
            case gamepad.dpad where gamepad.dpad.right.isPressed:
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
