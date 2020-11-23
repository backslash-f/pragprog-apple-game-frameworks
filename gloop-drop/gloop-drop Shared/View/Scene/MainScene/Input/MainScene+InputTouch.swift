//
//  MainScene+InputTouch.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 28.09.20.
//

import SpriteKit

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
            self.touchMoved(atPosition: touch.location(in: self))
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
        touchMoved(atPosition: event.location(in: self))
    }

    override func mouseUp(with event: NSEvent) {
        touchUp()
    }
    #endif
}

// MARK: - Private

fileprivate extension MainScene {

    func touchDown(atPosition position: CGPoint) {
        GloopDropApp.log("👇🏻 Touch down!", category: .inputTouch)
        if isGameInProgress {
            blobPlayer.isPlayerMoving = (atPoint(position).name == Constant.Node.Blob.name)
        } else {
            startGame()
        }
    }

    func touchMoved(atPosition position: CGPoint) {
        GloopDropApp.log("👉🏻 Touch moved!", category: .inputTouch)
        guard blobPlayer.isPlayerMoving else {
            return
        }

        // Clamp position.
        let newPosition = CGPoint(x: position.x, y: blobPlayer.position.y)
        blobPlayer.move(to: newPosition)
    }

    func touchUp() {
        GloopDropApp.log("👆🏻 Touch up!", category: .inputTouch)
        blobPlayer.isPlayerMoving = false
    }
}
