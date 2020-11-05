//
//  SKSpriteNode+Extension.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 23.09.20.
//

import SpriteKit

/// Shared z-positions.
enum Layer: CGFloat {
    case background
    case foreground
    case blobPlayer
    case collectible
}

extension SKSpriteNode {

    /// Loads texture arrays for animations via `SKTextureAtlas.preloadTextureAtlasesNamed(_:withCompletionHandler:)`.
    func loadTextures(atlasName: String, prefix: String, completion: @escaping ([SKTexture]) -> Void) {
        
        SKTextureAtlas.preloadTextureAtlasesNamed([atlasName]) { error, characterAtlas in
            guard let characterAtlasArray = characterAtlas.first else {
                let error = String(describing: error)
                let errorMessage = "One or more texture atlases could not be found. Error: \(error)"
                GloopDropApp.logError(errorMessage)
                fatalError(errorMessage)
            }
            let textures = characterAtlasArray.textureNames.filter {
                $0.hasPrefix(prefix)
            }.sorted {
                $0 < $1
            }.map {
                characterAtlasArray.textureNamed($0)
            }
            completion(textures)
        }
    }

    /// Start the animation. Default `count` is zero (repeat forever).
    /// Default `resize` is `false`.
    /// Default `restore` is `true`.
    func startAnimation(textures: [SKTexture],
                        speed: Double,
                        name: String,
                        count: Int = 0,
                        resize: Bool = false,
                        restore: Bool = true) {

        // Run animation only if "animation key" doesn't already exist.
        guard action(forKey: name) == nil else {
            return
        }

        let animation = SKAction.animate(
            with: textures,
            timePerFrame: speed,
            resize: resize,
            restore: restore
        )

        switch count {
        case 0:
            let repeatAction = SKAction.repeatForever(animation)
            run(repeatAction, withKey: name)
        case 1:
            run(animation, withKey: name)
        default:
            let repeatAction = SKAction.repeat(animation, count: count)
            run(repeatAction, withKey: name)
        }
    }
}
