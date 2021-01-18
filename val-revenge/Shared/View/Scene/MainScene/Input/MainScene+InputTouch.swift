//
//  MainScene+InputTouch.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 08.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import SpriteKit

/// Handles touch inputs (users interacting with the game via screen touching) and also mouse input (`macOS`).
extension MainScene {

    /// Shows the virtual pad and the attack button.
    func showVirtualController() {
        let unhideAction = SKAction.unhide()
        enumerateChildNodes(withName: Constant.Node.Controller.name) { virtualController, _ in
            virtualController.run(unhideAction)
        }
        enumerateChildNodes(withName: Constant.Node.ButtonAttack.name) { buttonAttack, _ in
            buttonAttack.run(unhideAction)
        }
    }

    /// Hides the virtual pad and the attack button.
    func hideVirtualController() {
        let hideAction = SKAction.hide()
        enumerateChildNodes(withName: Constant.Node.Controller.name) { virtualController, _ in
            virtualController.run(hideAction)
        }
        enumerateChildNodes(withName: Constant.Node.ButtonAttack.name) { buttonAttack, _ in
            buttonAttack.run(hideAction)
        }
    }

    func updateVirtualControllerLocation() {
        let controllerMovementPosition: CGPoint
        #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
        controllerMovementPosition = CGPoint(
            x: (viewLeft + Constant.virtualControllerMargin + insets.left),
            y: (viewBottom + Constant.virtualControllerMargin + insets.bottom)
        )
        #endif
        #if os(OSX)
        controllerMovementPosition = CGPoint(
            x: (viewLeft + Constant.virtualControllerMargin),
            y: (viewBottom + Constant.virtualControllerMargin)
        )
        #endif
        controllerMovement?.position = controllerMovementPosition

        let controllerAttackPosition: CGPoint
        #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
        controllerAttackPosition = CGPoint(
            x: (viewRight - Constant.virtualControllerMargin - insets.right),
            y: (viewBottom + Constant.virtualControllerMargin + insets.bottom)
        )
        #endif
        #if os(OSX)
        controllerAttackPosition = CGPoint(
            x: (viewRight - Constant.virtualControllerMargin),
            y: (viewBottom + Constant.virtualControllerMargin)
        )
        #endif
        controllerAttack?.position = controllerAttackPosition
    }

    func updateHUDLocation() {
        #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
        player?.hud.position = CGPoint(
            x: (viewRight - Constant.virtualControllerMargin - insets.right),
            y: (viewTop - Constant.virtualControllerMargin - insets.top)
        )
        #endif
        #if os(OSX)
        player?.hud.position = CGPoint(
            x: (viewRight - Constant.virtualControllerMargin),
            y: (viewTop - Constant.virtualControllerMargin)
        )
        #endif
    }
}

// MARK: - UIResponder

extension MainScene {

    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ValsRevenge.log("👇🏻 Touches began!", category: .inputTouch)
        self.startGame()
        touches.forEach { touch in
            handleTouchDown(atPosition: touch.location(in: self), touch: touch)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        ValsRevenge.log("👉🏻 Touches moved!", category: .inputTouch)
        touches.forEach { touch in
            handleTouchMoved(atPosition: touch.location(in: self), touch: touch)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        ValsRevenge.log("✋🏻 Touches ended!", category: .inputTouch)
        touches.forEach { touch in
            handleTouchUp(atPosition: touch.location(in: self), touch: touch)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        ValsRevenge.log("✋🏻 Touches cancelled!", category: .inputTouch)
        touches.forEach { touch in
            handleTouchUp(atPosition: touch.location(in: self), touch: touch)
        }
    }
    #endif
}

// MARK: - Private

private extension MainScene {

    func startGame() {
        mainGameStateMachine.enter(PlayingState.self)
    }

    #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
    func handleTouchDown(atPosition position: CGPoint, touch: UITouch) {
        let nodeAtPoint = atPoint(position)
        if let controllerMovement = controllerMovement {
            if controllerMovement.contains(nodeAtPoint) {
                leftTouch = touch
                controllerMovement.beginTracking()
            }
        }
        if let controllerAttack = controllerAttack {
            if controllerAttack.contains(nodeAtPoint) {
                rightTouch = touch
                controllerAttack.beginTracking()
            }
        }
    }

    func handleTouchMoved(atPosition position: CGPoint, touch: UITouch) {
        switch touch {
        case leftTouch:
            if let controllerMovement = controllerMovement {
                controllerMovement.moveJoystick(pos: position)
            }
        case rightTouch:
            if let controllerAttack = controllerAttack {
                controllerAttack.moveJoystick(pos: position)
            }
        default:
            break
        }
    }

    func handleTouchUp(atPosition position: CGPoint, touch: UITouch) {
        switch touch {
        case leftTouch:
            if let controllerMovement = controllerMovement {
                controllerMovement.endTracking()
                leftTouch = touch
            }
        case rightTouch:
            if let controllerAttack = controllerAttack {
                controllerAttack.endTracking()
                rightTouch = touch
            }
        default:
            break
        }
    }
    #endif

    func controllerPosition() -> CGPoint {
        let position: CGPoint
        #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
        position = CGPoint(
            x: viewLeft + Constant.virtualControllerMargin + insets.left,
            y: viewBottom + Constant.virtualControllerMargin + insets.bottom
        )
        #endif
        #if os(OSX)
        position = CGPoint(
            x: viewLeft + Constant.virtualControllerMargin,
            y: viewBottom + Constant.virtualControllerMargin
        )
        #endif
        return position
    }

    func buttonAttackPosition() -> CGPoint {
        let position: CGPoint
        #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
        position = CGPoint(
            x: viewRight - Constant.virtualControllerMargin - insets.right,
            y: viewBottom + Constant.virtualControllerMargin + insets.bottom
        )
        #endif
        #if os(OSX)
        position = CGPoint(
            x: viewRight - Constant.virtualControllerMargin,
            y: viewBottom + Constant.virtualControllerMargin
        )
        #endif
        return position
    }
}
