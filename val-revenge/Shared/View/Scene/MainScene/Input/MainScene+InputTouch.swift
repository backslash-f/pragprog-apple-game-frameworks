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

        guard let nodeName = (atPoint(position) as? SKSpriteNode)?.name else {
            player?.stance = .stop
            player?.isAttacking = false
            return
        }

        if nodeName == Constant.Node.ButtonAttack.name {
            player?.isAttacking = true

        } else {
            // Format stances, for example: "Up" -> "up"; "BottomLeft" -> "bottomLeft"
            let stanceSuffix = nodeName.deletingPrefix(Constant.Node.Controller.namePrefix)
            let stanceSuffixFirstLowercased = String(stanceSuffix.prefix(1).lowercased())
            let stance = stanceSuffixFirstLowercased + stanceSuffix.dropFirst()
            player?.stance = Stance(rawValue: stance) ?? .stop
        }
    }

    func touchUp() {
        ValsRevenge.log("👆🏻 Touch up!", category: .inputTouch)
        player?.isAttacking = false
        player?.stance = .stop
    }
}
