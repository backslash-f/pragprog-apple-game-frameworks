//
//  MainScene+PhysicsContact.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 28.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import SpriteKit

extension MainScene: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        let playerBitMask = PhysicsBody.player.categoryBitMask
        let projectileBitMask = PhysicsBody.projectile.categoryBitMask
        let monsterBitMask = PhysicsBody.monster.categoryBitMask
        let collectibleBitMask = PhysicsBody.collectible.categoryBitMask
        let doorBitMask = PhysicsBody.door.categoryBitMask

        switch collision {
        case playerBitMask | collectibleBitMask:
            handleCollisionPlayerCollectible(contact: contact)

        case playerBitMask | doorBitMask:
            handleCollisionPlayerDoor(contact: contact)

        case playerBitMask | monsterBitMask:
            handleCollisionPlayerMonster(contact: contact)

        case projectileBitMask | monsterBitMask:
            handleCollisionProjectileMonster(contact: contact)

        case playerBitMask | collectibleBitMask:
            handleCollisionProjectileCollectible(contact: contact)

        // MARK: - Player | Platform

        case PhysicsBody.player.categoryBitMask | PhysicsBody.exit.categoryBitMask:
            let playerNode = contact.bodyA.categoryBitMask == PhysicsBody.player.categoryBitMask ?
                contact.bodyA.node :
                contact.bodyB.node

            // Update the saved stats.
            if let player = playerNode as? Player {
                GameData.shared.keys = player.getStats().keys
                GameData.shared.treasure = player.getStats().treasure
            }

            // Load the next level.
            GameData.shared.level += 1
            loadSceneForLevel(GameData.shared.level)

        default:
            break
        }
    }
}

// MARK: - Private

private extension MainScene {

    func handleCollisionPlayerCollectible(contact: SKPhysicsContact) {
        let playerNode = (contact.bodyA.categoryBitMask == PhysicsBody.player.categoryBitMask) ?
            contact.bodyA.node :
            contact.bodyB.node

        let collectibleNode = (contact.bodyA.categoryBitMask == PhysicsBody.collectible.categoryBitMask) ?
            contact.bodyA.node :
            contact.bodyB.node

        if let player = playerNode as? Player, let collectible = collectibleNode {
            player.collectItem(collectible)
        }
    }

    func handleCollisionPlayerDoor(contact: SKPhysicsContact) {
        let playerNode = (contact.bodyA.categoryBitMask == PhysicsBody.player.categoryBitMask) ?
            contact.bodyA.node :
            contact.bodyB.node

        let doorNode = (contact.bodyA.categoryBitMask == PhysicsBody.door.categoryBitMask) ?
            contact.bodyA.node :
            contact.bodyB.node

        if let player = playerNode as? Player, let door = doorNode {
            player.useKeyToOpenDoor(door)
        }
    }

    func handleCollisionPlayerMonster(contact: SKPhysicsContact) {
        let playerNode = contact.bodyA.categoryBitMask == PhysicsBody.player.categoryBitMask ?
            contact.bodyA.node :
            contact.bodyB.node

        if let healthComponent = playerNode?.entity?.component(ofType: HealthComponent.self) {
            healthComponent.updateHealth(-1, forNode: playerNode)
        }
    }

    func handleCollisionProjectileMonster(contact: SKPhysicsContact) {
        let monsterNode = contact.bodyA.categoryBitMask == PhysicsBody.monster.categoryBitMask ?
            contact.bodyA.node :
            contact.bodyB.node

        if let healthComponent = monsterNode?.entity?.component(ofType: HealthComponent.self) {
            healthComponent.updateHealth(-1, forNode: monsterNode)
        }
    }

    func handleCollisionProjectileCollectible(contact: SKPhysicsContact) {
        let projectileNode = (contact.bodyA.categoryBitMask == PhysicsBody.projectile.categoryBitMask) ?
            contact.bodyA.node :
            contact.bodyB.node

        let collectibleNode = (contact.bodyA.categoryBitMask == PhysicsBody.collectible.categoryBitMask) ?
            contact.bodyA.node :
            contact.bodyB.node

        if let collectibleComponent = collectibleNode?.entity?.component(ofType: CollectibleComponent.self) {
            collectibleComponent.destroyedItem()
        }
        projectileNode?.removeFromParent()
    }
}
