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
    case goblin, skeleton, key, food, treasure
}

struct GameObject {
    static let defaultGeneratorType = GameObjectType.skeleton.rawValue
    static let defaultAnimationType = GameObjectType.skeleton.rawValue
    static let defaultCollectibleType = GameObjectType.key.rawValue

    static let goblin = Goblin()
    static let skeleton = Skeleton()
    static let key = Key()
    static let food = Food()
    static let treasure = Treasure()

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

    struct Key {
        let collectibleSettings = CollectibleSettings(
            type: .key,
            collectSound: "key",
            destroySound: "destroyed"
        )
    }

    struct Food {
        let collectibleSettings = CollectibleSettings(
            type: .food,
            collectSound: "food",
            destroySound: "destroyed",
            canDestroy: true
        )
    }

    struct Treasure {
        let collectibleSettings = CollectibleSettings(
            type: .treasure,
            collectSound: "treasure",
            destroySound: "destroyed"
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

    static func forCollectibleType(_ type: GameObjectType?) -> CollectibleSettings? {
        switch type {
        case .key:
            return GameObject.key.collectibleSettings
        case .food:
            return GameObject.food.collectibleSettings
        case .treasure:
            return GameObject.treasure.collectibleSettings
        default:
            return nil
        }
    }
}
