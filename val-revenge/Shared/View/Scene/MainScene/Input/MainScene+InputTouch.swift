//
//  MainScene+InputTouch.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 08.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import SpriteKit

#warning("TODO: handle controller")

/// Handles touch inputs (users interacting with the game via screen touching) and also mouse input (`macOS`).
extension MainScene {

    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { [weak self] touch in
            guard let self = self else {
                return
            }
            self.touchDown(atPosition: touch.location(in: self))
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { [weak self] touch in
            guard let self = self else {
                return
            }
            self.touchDown(atPosition: touch.location(in: self))
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUp()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUp()
    }
    #endif

    #if os(OSX)
    override func mouseDown(with event: NSEvent) {
        touchDown(atPosition: event.location(in: self))
    }

    override func mouseDragged(with event: NSEvent) {
        touchDown(atPosition: event.location(in: self))
    }

    override func mouseUp(with event: NSEvent) {
        touchUp()
    }
    #endif
}

// MARK: - Private

private extension MainScene {

    func touchDown(atPosition position: CGPoint) {
        ValsRevenge.log("👇🏻 Touch down!", category: .inputTouch)
        switch (atPoint(position) as? SKSpriteNode)?.name {
        case Constant.Node.ButtonAttack.name:
            player?.isAttacking = true
        case Constant.Node.Controller.stop:
            player?.stance = .stop
        case Constant.Node.Controller.up:
            player?.stance = .up
        case Constant.Node.Controller.down:
            player?.stance = .down
        case Constant.Node.Controller.left:
            player?.stance = .left
        case Constant.Node.Controller.right:
            player?.stance = .right
        case Constant.Node.Controller.topLeft:
            player?.stance = .topLeft
        case Constant.Node.Controller.topRight:
            player?.stance = .topRight
        case Constant.Node.Controller.bottomLeft:
            player?.stance = .bottomLeft
        case Constant.Node.Controller.bottomRight:
            player?.stance = .bottomRight
        default:
            player?.stance = .stop
            player?.isAttacking = false
        }
    }

    func touchUp() {
        ValsRevenge.log("👆🏻 Touch up!", category: .inputTouch)
        player?.isAttacking = false
        player?.stance = .stop
    }
}
