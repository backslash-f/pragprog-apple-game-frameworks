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
                    self?.showVirtualController()
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
        hideVirtualController()
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
        extendedGamepadController.buttonB.valueChangedHandler = buttonHandlerStart()
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
        microGamepadController.buttonX.valueChangedHandler = buttonHandlerStart()
        return true
    }

    func directionalControlHandler() -> GCControllerDirectionPadValueChangedHandler {
        return { [weak self] _, xValue, yValue in
            #warning("TODO: directionalControlHandler")
        }
    }

    /// Notice: `buttonA` is the 􀁡 button in a Sony's Dualshock.
    func buttonHandlerA() -> GCControllerButtonValueChangedHandler {
        return { [weak self] _, _, isPressed in
            self?.player?.isAttacking = isPressed
        }
    }

    /// Notice: `buttonB` is the 􀨂 button in a Sony's Dualshock.
    /// `buttonX` is the 􀊈 button in the MicroGamepad controller.
    func buttonHandlerStart() -> GCControllerButtonValueChangedHandler {
        return { [weak self] _, _, _ in
            self?.mainGameStateMachine.enter(PlayingState.self)
        }
    }
}
