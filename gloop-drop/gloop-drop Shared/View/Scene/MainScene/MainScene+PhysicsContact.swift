//
//  MainScene+PhysicsContact.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 17.11.20.
//

import SpriteKit

extension MainScene: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        switch collision {
        case PhysicsCategory.player.rawValue | PhysicsCategory.collectible.rawValue:
            GloopDropApp.log("Player hit collectible", category: .collision)
            handle(contact: contact, isCollectibleCollected: true)

        case PhysicsCategory.floor.rawValue | PhysicsCategory.collectible.rawValue:
            GloopDropApp.log("Collectible hit the floor", category: .collision)
            handle(contact: contact, isCollectibleCollected: false)

        default:
            break
        }
    }
}

// MARK: - Private

private extension MainScene {

    func handle(contact: SKPhysicsContact, isCollectibleCollected: Bool) {
        // Find out which body is attached to the collectible node.
        let body = (contact.bodyA.categoryBitMask == PhysicsCategory.collectible.rawValue) ?
            contact.bodyA.node :
            contact.bodyB.node

        // Verify the object is a collectible.
        if let collectible = body as? Collectible {
            if isCollectibleCollected {
                collectible.collected()
                dropsCollected += 1
                score += level
                checkForRemainingDrops()
                addChompLabel()
            } else {
                collectible.missed()
                gameOver()
            }
        }
    }
}
