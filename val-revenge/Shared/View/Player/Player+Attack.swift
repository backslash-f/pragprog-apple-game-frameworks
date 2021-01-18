//
//  Player+Attack.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 18.01.21.
//  Copyright © 2021 backslash-f. All rights reserved.
//

import SwiftUI
import SpriteKit

extension Player {

    func attack(direction: CGVector) {

        // Verify the direction isn't zero and that the player hasn't
        // shot more projectiles than the max allowed at one time.
        guard direction != .zero && numProjectiles < maxProjectiles else {
            return
        }

        // Increase the number of "current" projectiles.
        numProjectiles += 1

        // Set the throw direction.
        let throwDirection = CGVector(dx: direction.dx * projectileSpeed,
                                      dy: direction.dy * projectileSpeed)

        // Create and run the actions to attack.
        let wait = SKAction.wait(forDuration: projectileRange)
        let removeFromScene = SKAction.removeFromParent()

        let spin = SKAction.applyTorque(0.25, duration: projectileRange)
        let toss = SKAction.move(by: throwDirection, duration: projectileRange)

        let actionTTL = SKAction.sequence([wait, removeFromScene])
        let actionThrow = SKAction.group([spin, toss])

        let actionAttack = SKAction.group([actionTTL, actionThrow])
        createProjectile().run(actionAttack)

        // Set up attack governor (attack speed limiter).
        let reduceCount = SKAction.run({self.numProjectiles -= 1})
        let reduceSequence = SKAction.sequence([attackDelay, reduceCount])
        run(reduceSequence)
    }
}

// MARK: - Private

private extension Player {

    func createProjectile() -> SKSpriteNode {
        let projectile = SKSpriteNode(imageNamed: Constant.Node.Knife.imageName)
        projectile.position = CGPoint(x: 0.0, y: 0.0)
        projectile.zPosition += 1
        addChild(projectile)

        // Set up the physics for the projectile.
        let physicsBody = SKPhysicsBody(rectangleOf: projectile.size)

        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = true
        physicsBody.isDynamic = true

        physicsBody.categoryBitMask = PhysicsBody.projectile.categoryBitMask
        physicsBody.contactTestBitMask = PhysicsBody.projectile.contactTestBitMask
        physicsBody.collisionBitMask = PhysicsBody.projectile.collisionBitMask

        projectile.physicsBody = physicsBody

        return projectile
    }
}
