//
//  PhysicsComponent.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 28.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import SpriteKit
import GameplayKit

enum PhysicsCategory: String {
    case player
    case wall
    case door
    case monster
    case projectile
    case collectible
    case exit
}

enum PhysicsShape: String {
    case circle
    case rect
}

struct PhysicsBody: OptionSet, Hashable {

    let rawValue: UInt32

    static let player       = PhysicsBody(rawValue: 1 << 0) // 1
    static let wall         = PhysicsBody(rawValue: 1 << 1) // 2
    static let door         = PhysicsBody(rawValue: 1 << 2) // 4
    static let monster      = PhysicsBody(rawValue: 1 << 3) // 8
    static let projectile   = PhysicsBody(rawValue: 1 << 4) // 16
    static let collectible  = PhysicsBody(rawValue: 1 << 5) // 32
    static let exit         = PhysicsBody(rawValue: 1 << 6) // 64

    static var collisions: [PhysicsBody: [PhysicsBody]] = [
        .player: [.wall, .door],
        .monster: [.wall, .door]
    ]

    static var contactTests: [PhysicsBody: [PhysicsBody]] = [
        .player: [.monster, .collectible, .door, .exit],
        .wall: [.player],
        .door: [.player],
        .monster: [.player, .projectile],
        .projectile: [.monster, .collectible, .wall],
        .collectible: [.player, .projectile],
        .exit: [.player]
    ]

    var categoryBitMask: UInt32 {
        return rawValue
    }

    var collisionBitMask: UInt32 {
        let bitMask = PhysicsBody
            .collisions[self]?
            .reduce(PhysicsBody(), { result, physicsBody in
                result.union(physicsBody)
            })
        return bitMask?.rawValue ?? 0
    }

    var contactTestBitMask: UInt32 {
        let bitMask = PhysicsBody
            .contactTests[self]?
            .reduce(PhysicsBody(), { result, physicsBody in
                result.union(physicsBody)
            })
        return bitMask?.rawValue ?? 0
    }

    static func forType(_ type: PhysicsCategory?) -> PhysicsBody? {
        switch type {
        case .player:
            return self.player
        case .wall:
            return self.wall
        case .door:
            return self.door
        case .monster:
            return self.monster
        case .projectile:
            return self.projectile
        case .collectible:
            return self.collectible
        case .exit:
            return self.exit
        case .none:
            break
        }
        return nil
    }
}

class PhysicsComponent: GKComponent {

    @GKInspectable var bodyCategory: String = PhysicsCategory.wall.rawValue
    @GKInspectable var bodyShape: String = PhysicsShape.circle.rawValue

    override class var supportsSecureCoding: Bool {
        true
    }

    override func didAddToEntity() {
        guard let bodyCategory = PhysicsBody.forType(PhysicsCategory(rawValue: bodyCategory)),
              let sprite = componentNode as? SKSpriteNode else {
            return
        }

        let size: CGSize = sprite.size

        if bodyShape == PhysicsShape.rect.rawValue {
            componentNode.physicsBody = SKPhysicsBody(rectangleOf: size)
        } else if bodyShape == PhysicsShape.circle.rawValue {
            componentNode.physicsBody = SKPhysicsBody(circleOfRadius: size.height / 2)
        }

        componentNode.physicsBody?.categoryBitMask = bodyCategory.categoryBitMask
        componentNode.physicsBody?.collisionBitMask = bodyCategory.collisionBitMask
        componentNode.physicsBody?.contactTestBitMask = bodyCategory.contactTestBitMask
        componentNode.physicsBody?.affectedByGravity = false
        componentNode.physicsBody?.allowsRotation = false
    }
}
