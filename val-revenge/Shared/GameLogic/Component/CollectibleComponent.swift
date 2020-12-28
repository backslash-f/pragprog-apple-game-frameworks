//
//  CollectibleComponent.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 28.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import SpriteKit
import GameplayKit

struct CollectibleSettings {

    let type: GameObjectType
    let collectSoundFile: String
    let destroySoundFile: String
    let canDestroy: Bool

    init(type: GameObjectType, collectSound: String, destroySound: String, canDestroy: Bool = false) {
        self.type = type
        self.collectSoundFile = collectSound
        self.destroySoundFile = destroySound
        self.canDestroy = canDestroy
    }
}

class CollectibleComponent: GKComponent {

    @GKInspectable var collectibleType: String = GameObject.defaultCollectibleType
    @GKInspectable var value: Int = 1

    private var collectSoundAction = SKAction()
    private var destroySoundAction = SKAction()
    private var canDestroy = false

    override class var supportsSecureCoding: Bool {
        true
    }

    override func didAddToEntity() {
        guard let collectible = GameObject.forCollectibleType(GameObjectType(rawValue: collectibleType)) else {
            return
        }
        collectSoundAction = SKAction.playSoundFileNamed(collectible.collectSoundFile, waitForCompletion: false)
        destroySoundAction = SKAction.playSoundFileNamed(collectible.destroySoundFile, waitForCompletion: false)
        canDestroy = collectible.canDestroy
    }

    func collectedItem() {
        componentNode.run(collectSoundAction) { [weak self] in
            self?.componentNode.removeFromParent()
        }
    }

    func destroyedItem() {
        if canDestroy == true {
            componentNode.run(destroySoundAction) { [weak self] in
                self?.componentNode.removeFromParent()
            }
        }
    }
}
