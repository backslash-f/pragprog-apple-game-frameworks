//
//  GameObjects.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 22.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GameObjectType: String {
    case goblin, skeleton
}

struct GameObject {
    static let defaultGeneratorType = GameObjectType.skeleton.rawValue
    static let defaultAnimationType = GameObjectType.skeleton.rawValue

    static let skeleton = Skeleton()
    static let goblin = Goblin()

    struct Goblin {
        let animationSettings = Animation(
            textures: SKTexture.loadTextures(
                atlas: "monster_goblin",
                prefix: "goblin_",
                startsAt: 0,
                stopsAt: 1
            )
        )
    }

    struct Skeleton {
        let animationSettings = Animation(
            textures: SKTexture.loadTextures(
                atlas: "monster_skeleton",
                prefix: "skeleton_",
                startsAt: 0,
                stopsAt: 1
            ),
            timePerFrame: TimeInterval(1.0 / 25.0)
        )
    }

    static func forAnimationType(_ type: GameObjectType?) -> Animation? {
        switch type {
        case .skeleton:
            return GameObject.skeleton.animationSettings
        case .goblin:
            return GameObject.goblin.animationSettings
        default:
            return nil
        }
    }
}
