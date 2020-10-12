//
//  GameScene+Input.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 28.09.20.
//

import SpriteKit

// MARK: - Touch Handling

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
        // Calculate the duration based on current position and location of the touch.
        let distance = hypot(position.x - blobPlayer.position.x, position.y - blobPlayer.position.y)
        let duration = TimeInterval(distance / blobPlayer.baseSpeed) / 255

        GloopDropApp.log("🏃🏻‍♂️ Touch received! Will move to position: \(position)", category: .spriteKit)
        GloopDropApp.log("Current position: \(blobPlayer.position)", category: .spriteKit)
        GloopDropApp.log("Distance: \(distance)", category: .spriteKit)
        GloopDropApp.log("Duration (speed): \(duration)", category: .spriteKit)

        let direction: SKTransitionDirection = (position.x < blobPlayer.position.x) ? .left : .right
        blobPlayer.move(to: position, direction: direction, duration: duration)
    }
}
