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
                    self?.showVirtualButtons()
                }
            }
            .store(in: &cancellables)
    }

    func setupControllers() {
        guard let gameController = setupGameController() else {
            return
        }
        if !setupExtendedController(in: gameController) {
            if !setupMicroControllers(in: gameController) {
                return
            }
        }
        hideVirtualButtons()
    }
}

// MARK: - Private

private extension MainScene {

    func setupGameController() -> GCController? {
        guard let gameController = gcOverseer.controllers().first else {
            ValsRevenge.log("No connected controllers", category: .inputController)
            return nil
        }
        guard let firstPlayerIndex = GCControllerPlayerIndex(rawValue: 1) else {
            ValsRevenge.log("Can't create a GCControllerPlayerIndex for player 1", category: .inputController)
            return nil
        }
        gameController.playerIndex = firstPlayerIndex
        return gameController
    }

    func setupExtendedController(in gameController: GCController) -> Bool {
        guard let extendedGamepadController = gameController.extendedGamepad else {
            ValsRevenge.log("No extended gamepad controllers detected", category: .inputTouch)
            return false
        }
        extendedGamepadController.leftThumbstick.valueChangedHandler = directionalControlHandler()
        extendedGamepadController.dpad.valueChangedHandler = directionalControlHandler()
        extendedGamepadController.buttonA.valueChangedHandler = buttonHandlerA()
        return true
    }

    func setupMicroControllers(in gameController: GCController) -> Bool {
        guard let microGamepadController = gcOverseer.controllers().first?.microGamepad else {
            ValsRevenge.log("No micro gamepad controllers detected", category: .inputController)
            return false
        }
        // Couldn't get rotation to work:
        // https://developer.apple.com/forums/thread/21562?page=1#644496022
        microGamepadController.allowsRotation = true
        microGamepadController.dpad.valueChangedHandler = directionalControlHandler()
        microGamepadController.buttonA.valueChangedHandler = buttonHandlerA()
        return true
    }

    func directionalControlHandler() -> GCControllerDirectionPadValueChangedHandler {
        return { [weak self] thumbstickOrDpad, xValue, yValue in

            let deadZone: ClosedRange<Float> = -0.35...0.35
            let positiveDisplacement: PartialRangeFrom<Float> = 0.35...
            let negativeDisplacement: ClosedRange<Float> = -1.0...(-0.35)

            let stance: Stance
            switch (xValue, yValue) {
            case (deadZone, positiveDisplacement):
                stance = .up
            case (positiveDisplacement, positiveDisplacement):
                stance = .topRight
            case (positiveDisplacement, deadZone):
                stance = .right
            case (positiveDisplacement, negativeDisplacement):
                stance = .bottomRight
            case (deadZone, negativeDisplacement):
                stance = .down
            case (negativeDisplacement, negativeDisplacement):
                stance = .bottomLeft
            case (negativeDisplacement, deadZone):
                stance = .left
            case (negativeDisplacement, positiveDisplacement):
                stance = .topLeft
            default:
                stance = .stop
            }
            self?.player?.stance = stance
        }
    }

    /// Notice: `buttonA` is the 􀁡 button in a Sony's Dualshock.
    func buttonHandlerA() -> GCControllerButtonValueChangedHandler {
        return { [weak self] _, _, isPressed in
            self?.player?.isAttacking = isPressed
        }
    }
}
