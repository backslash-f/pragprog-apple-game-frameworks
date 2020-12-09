//
//  Player.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 08.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import SpriteKit

// swiftlint:disable identifier_name
enum Stance: String {
    case stop, left, right, up, down, topLeft, topRight, bottomLeft, bottomRight
}

class Player: SKSpriteNode {

    // MARK: - Properties

    var isAttacking: Bool = false

    var stance: Stance = .stop

    // MARK: Private Properties

    private var lastStance: Stance?

    private var playerMovementUnits: CGFloat = 100

    private var knifeMovementUnits: CGFloat = 300
}

// MARK: - Interface

extension Player {

    func updatePosition() {
        guard stance != .stop else {
            stop()
            return
        }
        ValsRevenge.log("Player's stance: \(stance.rawValue)", category: .player)
        switch stance {
        case .up:
            goUp()
        case .down:
            goDown()
        case .left:
            goLeft()
        case .right:
            goRight()
        case .topLeft:
            goTopLeft()
        case .topRight:
            goTopRight()
        case .bottomLeft:
            goBottomLeft()
        case .bottomRight:
            goBottomRight()
        case .stop:
            stop()
        }
        lastStance = stance
    }

    func updateAction() {
        if isAttacking {
            attack()
        }
    }
}

// MARK: - Private

private extension Player {

    func stop() {
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }

    func goUp() {
        physicsBody?.velocity = CGVector(dx: 0, dy: playerMovementUnits)
    }

    func goDown() {
        physicsBody?.velocity = CGVector(dx: 0, dy: -playerMovementUnits)
    }

    func goLeft() {
        physicsBody?.velocity = CGVector(dx: -playerMovementUnits, dy: 0)
    }

    func goRight() {
        physicsBody?.velocity = CGVector(dx: playerMovementUnits, dy: 0)
    }

    func goTopLeft() {
        physicsBody?.velocity = CGVector(dx: -playerMovementUnits, dy: playerMovementUnits)
    }

    func goTopRight() {
        physicsBody?.velocity = CGVector(dx: playerMovementUnits, dy: playerMovementUnits)
    }

    func goBottomLeft() {
        physicsBody?.velocity = CGVector(dx: -playerMovementUnits, dy: -playerMovementUnits)
    }

    func goBottomRight() {
        physicsBody?.velocity = CGVector(dx: playerMovementUnits, dy: -playerMovementUnits)
    }

    // MARK: - Attack

    func attack() {
        ValsRevenge.log("🗡 Player is attacking!", category: .player)

        let knife = SKSpriteNode(imageNamed: Constant.Node.Knife.imageName)
        knife.position = .zero
        knife.zRotation = knifeRotation()
        addChild(knife)

        let throwAction = SKAction.move(by: knifeDirection(), duration: 0.25)
        knife.run(throwAction) {
            knife.removeFromParent()
        }

        isAttacking = false
    }

    func knifeRotation() -> CGFloat {
        switch lastStance {
        case .up:
            return .zero
        case .down:
            return -CGFloat.pi
        case .left:
            return CGFloat.pi/2
        case .right, .stop: // Default pre-movement (throw right)
            return -CGFloat.pi/2
        case .topLeft:
            return CGFloat.pi/4
        case .topRight:
            return -CGFloat.pi/4
        case .bottomLeft:
            return 3 * CGFloat.pi/4
        case .bottomRight:
            return 3 * -CGFloat.pi/4
        case .none:
            return .zero
        }
    }

    func knifeDirection() -> CGVector {
        switch lastStance {
        case .up:
            return CGVector(dx: 0, dy: knifeMovementUnits)
        case .down:
            return CGVector(dx: 0, dy: -knifeMovementUnits)
        case .left:
            return CGVector(dx: -knifeMovementUnits, dy: 0)
        case .right, .stop: // Default pre-movement (throw right)
            return CGVector(dx: knifeMovementUnits, dy: 0)
        case .topLeft:
            return CGVector(dx: -knifeMovementUnits, dy: knifeMovementUnits)
        case .topRight:
            return CGVector(dx: knifeMovementUnits, dy: knifeMovementUnits)
        case .bottomLeft:
            return CGVector(dx: -knifeMovementUnits, dy: -knifeMovementUnits)
        case .bottomRight:
            return CGVector(dx: knifeMovementUnits, dy: -knifeMovementUnits)
        case .none:
            return .zero
        }
    }
}
