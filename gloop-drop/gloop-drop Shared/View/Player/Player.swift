//
//  Player.swift
//  gloop-drop iOS
//
//  Created by Fernando Fernandes on 23.09.20.
//

import Foundation
import SpriteKit

/// Easily switch between animations.
enum PlayerAnimationType: String {
    case walk
}

class Player: SKSpriteNode {

    // MARK: - Private Properties

    private var walkTextures: [SKTexture]?

    private let defaultTexture = SKTexture(imageNamed: "\(Constant.Character.Blob.walkTexturePrefix)0")

    // MARK: - Lifecycle

    init() {
        super.init(texture: defaultTexture, color: .clear, size: defaultTexture.size())
        setupPlayer()
        loadWalkTextures()
    }

    required init?(coder aDecoder: NSCoder) {
        let errorMessage = "init(coder:) has not been implemented"
        GloopDropApp.logError(errorMessage)
        fatalError(errorMessage)
    }
}

// MARK: - Private

private extension Player {

    // MARK: Setup

    func setupPlayer() {
        name = Constant.Character.Blob.name
        setScale(1.0)
        anchorPoint = CGPoint(x: 0.5, y: 0.0) // center-bottom
        zPosition = Layer.player.rawValue
    }

    func loadWalkTextures() {
        loadTextures(
            atlasName: Constant.Character.Blob.atlasName,
            prefix: Constant.Character.Blob.walkTexturePrefix
        ) { [weak self] textures in
            self?.walkTextures = textures
        }
    }
}
