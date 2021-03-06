//
//  GameOverScene.swift
//  valsrevenge
//
//  Created by Tammy Coron on 7/4/20.
//  Copyright © 2020 Just Write Code LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverScene: MenuScene {

    private var newGameButton: SKSpriteNode!
    private var loadGameButton: SKSpriteNode!

    // MARK: - Lifecycle

    override func didMove(to view: SKView) {
        newGameButton = childNode(withName: "newGameButton") as? SKSpriteNode
        loadGameButton = childNode(withName: "loadGameButton") as? SKSpriteNode
    }
}

// MARK: - Touch Responder

extension GameOverScene {
    #if os(iOS) || os(tvOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { touch in
            self.touchDown(atPoint: touch.location(in: self))
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

private extension GameOverScene {

    // MARK: - Setup

    // MARK: - Responder

    func touchDown(atPoint cgPoint: CGPoint) {
        #if os(iOS) || os(tvOS)
        let nodeAtPoint = atPoint(cgPoint)
        if newGameButton.contains(nodeAtPoint) {
            startNewGame()
        } else if loadGameButton.contains(nodeAtPoint) {
            resumeSavedGame()
        }
        #endif
        #if os(OSX)
        if newGameButton.contains(cgPoint) {
            startNewGame()
        } else if loadGameButton.contains(cgPoint) {
            resumeSavedGame()
        }
        #endif
    }
}
