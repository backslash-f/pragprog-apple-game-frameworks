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
            x: (viewLeft + insets.left),
            y: (viewBottom + insets.bottom)
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
            x: (viewRight + insets.right),
            y: (viewBottom + insets.bottom)
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
        touches.forEach { [weak self] touch in
            guard let self = self else {
                return
            }
            self.startGame()
            let position = touch.location(in: self)
            self.handleStance(atPosition: position)
            self.handleAction(atPosition: position)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        ValsRevenge.log("👉🏻 Touches moved!", category: .inputTouch)
        touches.forEach { [weak self] touch in
            guard let self = self else {
                return
            }
            self.handleStance(atPosition: touch.location(in: self))
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { [weak self] touch in
            guard let self = self else {
                return
            }
            self.touchUp(atPosition: touch.location(in: self))
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { [weak self] touch in
            guard let self = self else {
                return
            }
            self.touchUp(atPosition: touch.location(in: self))
        }
    }
    #endif
}

// MARK: - NSResponder

extension MainScene {

    #if os(OSX)
    override func mouseDown(with event: NSEvent) {
        let position = event.location(in: self)
        startGame()
        handleStance(atPosition: position)
        handleAction(atPosition: position)
    }

    override func mouseDragged(with event: NSEvent) {
        touchUp(atPosition: event.location(in: self))
    }

    override func mouseUp(with event: NSEvent) {
        touchUp(atPosition: event.location(in: self))
    }
    #endif
}

// MARK: - Private

private extension MainScene {

    func startGame() {
        mainGameStateMachine.enter(PlayingState.self)
    }

    func handleStance(atPosition position: CGPoint) {
        if let nodeName = (atPoint(position) as? SKSpriteNode)?.name,
           nodeName != Constant.Node.ButtonAttack.name {
            // Format stances, for example: "Up" -> "up"; "BottomLeft" -> "bottomLeft"
            let stanceSuffix = nodeName.deletingPrefix(Constant.Node.Controller.name)
            let stanceSuffixFirstLowercased = String(stanceSuffix.prefix(1).lowercased())
            let stance = stanceSuffixFirstLowercased + stanceSuffix.dropFirst()
            player?.stance = Stance(rawValue: stance) ?? .stop
        }
    }

    func handleAction(atPosition position: CGPoint) {
        let nodeName = (atPoint(position) as? SKSpriteNode)?.name
        player?.isAttacking = (nodeName == Constant.Node.ButtonAttack.name)
    }

    func touchUp(atPosition position: CGPoint) {
        ValsRevenge.log("👆🏻 Touch up!", category: .inputTouch)
        if let nodeName = (atPoint(position) as? SKSpriteNode)?.name,
           nodeName.starts(with: Constant.Node.Controller.name) {
            player?.stance = .stop
        }
    }

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
