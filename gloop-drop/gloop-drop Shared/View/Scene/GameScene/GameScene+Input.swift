//
//  GameScene+Input.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 28.09.20.
//

import SpriteKit

// MARK: - Touch Handling

#warning("TODO: add (and test) joystick support")

extension ​GameScene​ {

    #if os(iOS) || os(tvOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { touch in
            handleTouch(atPoint: touch.location(in: self))
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { touch in
            handleTouch(atPoint: touch.location(in: self))
        }
    }
    #endif
    #if os(OSX)
    override func mouseDown(with event: NSEvent) {
        handleTouch(atPoint: event.location(in: self))
    }

    override func mouseDragged(with event: NSEvent) {
        handleTouch(atPoint: event.location(in: self))
    }
    #endif
}

// MARK: - Private

private extension ​GameScene​ {

    func handleTouch(atPoint position: CGPoint) {
        GloopDropApp.log("🏃🏻‍♂️ Touch received! Will move to position: \(position)", category: .spriteKit)
        GloopDropApp.log("Current position: \(blobPlayer.position)", category: .spriteKit)
        
        let duration = 1.0
        if position.x < blobPlayer.position.x {
            blobPlayer.move(to: position, direction: .left, duration: duration)
        } else {
            blobPlayer.move(to: position, direction: .right, duration: duration)
        }
    }
}
