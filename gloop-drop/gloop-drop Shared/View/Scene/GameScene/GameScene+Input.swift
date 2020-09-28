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
            touchDown(atPoint: touch.location(in: self))
        }
    }
    #endif
    #if os(OSX)
    override func mouseDown(with event: NSEvent) {
        touchDown(atPoint: event.location(in: self))
    }
    #endif
}

// MARK: - Private

private extension ​GameScene​ {

    func touchDown(atPoint position: CGPoint) {
        GloopDropApp.log("TouchDown! To position: \(position)", category: .spriteKit)
        blobPlayer.move(toPosition: position, duration: 1.0)
    }
}
