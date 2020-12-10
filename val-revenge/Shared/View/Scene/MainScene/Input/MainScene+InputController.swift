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
                    self?.hideVirtualButtons()
                    self?.setupControllers()
                } else {
                    self?.showVirtualButtons()
                }
            }
            .store(in: &cancellables)
    }

    func setupControllers() {
        setupExtendedControllers()
        setupMicroControllers()
    }
}

// MARK: - Private

private extension MainScene {

    func setupExtendedControllers() {
        guard let extendedGamepadController = gcOverseer.controllers().first?.extendedGamepad else {
            ValsRevenge.log("No extended gamepad controllers detected", category: .inputTouch)
            return
        }
        extendedGamepadController.leftThumbstick.valueChangedHandler = directionalControlHandler()
        extendedGamepadController.dpad.valueChangedHandler = directionalControlHandler()
        extendedGamepadController.buttonX.valueChangedHandler = buttonXHandler()
    }

    func setupMicroControllers() {
        guard let microGamepadController = gcOverseer.controllers().first?.microGamepad else {
            ValsRevenge.log("No micro gamepad controllers detected", category: .inputController)
            return
        }
        // Couldn't get rotation to work:
        // https://developer.apple.com/forums/thread/21562?page=1#644496022
        microGamepadController.allowsRotation = true
        microGamepadController.dpad.valueChangedHandler = directionalControlHandler()
        microGamepadController.buttonX.valueChangedHandler = buttonXHandler()
    }

    func directionalControlHandler() -> GCControllerDirectionPadValueChangedHandler {
        return { [weak self] thumbstickOrDpad, xValue, yValue in
            #warning("TODO: handle stances")
            //player?.stance
        }
    }

    /// Notice: The `X` button is the `square` button in a Sony's Dualshock 􀨄
    func buttonXHandler() -> GCControllerButtonValueChangedHandler {
        return { [weak self] _, _, isPressed in
            #warning("TODO: handle X button")
            //player?.isAttacking
        }
    }
}
