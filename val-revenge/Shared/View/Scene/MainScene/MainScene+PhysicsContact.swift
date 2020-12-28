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
        switch collision {

        // MARK: - Player | Collectible

        case PhysicsBody.player.categoryBitMask | PhysicsBody.collectible.categoryBitMask:
            let playerNode = (contact.bodyA.categoryBitMask == PhysicsBody.player.categoryBitMask) ?
                contact.bodyA.node :
                contact.bodyB.node

            let collectibleNode = (contact.bodyA.categoryBitMask == PhysicsBody.collectible.categoryBitMask) ?
                contact.bodyA.node :
                contact.bodyB.node

            if let player = playerNode as? Player, let collectible = collectibleNode {
                player.collectItem(collectible)
            }

        // MARK: - Player | Door

        case PhysicsBody.player.categoryBitMask | PhysicsBody.door.categoryBitMask:
            let playerNode = (contact.bodyA.categoryBitMask == PhysicsBody.player.categoryBitMask) ?
                contact.bodyA.node :
                contact.bodyB.node

            let doorNode = (contact.bodyA.categoryBitMask == PhysicsBody.door.categoryBitMask) ?
                contact.bodyA.node :
                contact.bodyB.node

            if let player = playerNode as? Player, let door = doorNode {
                player.useKeyToOpenDoor(door)
            }

        // MARK: - Projectile | Collectible

        case PhysicsBody.projectile.categoryBitMask | PhysicsBody.collectible.categoryBitMask:
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

        default:
            break
        }
    }
}
