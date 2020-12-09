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
        ValsRevenge.log("👇🏻 Touches began!", category: .inputTouch)
        touches.forEach { [weak self] touch in
            guard let self = self else {
                return
            }
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

    #if os(OSX)
    override func mouseDown(with event: NSEvent) {
        let position = event.location(in: self)
        self.handleStance(atPosition: position)
        self.handleAction(atPosition: position)
    }

    override func mouseDragged(with event: NSEvent) {
        self.touchUp(atPosition: event.location(in: self))
    }

    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPosition: event.location(in: self))
    }
    #endif
}

// MARK: - Private

private extension MainScene {

    func handleStance(atPosition position: CGPoint) {
        if let nodeName = (atPoint(position) as? SKSpriteNode)?.name,
           nodeName != Constant.Node.ButtonAttack.name {
            // Format stances, for example: "Up" -> "up"; "BottomLeft" -> "bottomLeft"
            let stanceSuffix = nodeName.deletingPrefix(Constant.Node.Controller.namePrefix)
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
           nodeName.starts(with: Constant.Node.Controller.namePrefix) {
            player?.stance = .stop
        }
    }
}
