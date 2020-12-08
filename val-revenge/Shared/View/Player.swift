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
    case stop, left, right, up, down
}

class Player: SKSpriteNode {

    // MARK: - Properties

    var isAttacking: Bool = false

    var stance: Stance = .stop

    // MARK: Private Properties

    private var lastStance: Stance?

    private var defaultMovementUnits: CGFloat = 100
}

// MARK: - Interface

extension Player {

    func updatePosition() {
        guard stance != lastStance else {
            return
        }
        ValsRevenge.log("Player's stance: \(stance.rawValue)", category: .player)
        switch stance {
        case .stop:
            stop()
        case .up:
            goUp()
        case .down:
            goDown()
        case .left:
            goLeft()
        case .right:
            goRight()
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
        physicsBody?.velocity = CGVector(dx: 0, dy: defaultMovementUnits)
    }

    func goDown() {
        physicsBody?.velocity = CGVector(dx: 0, dy: -defaultMovementUnits)
    }

    func goLeft() {
        physicsBody?.velocity = CGVector(dx: -defaultMovementUnits, dy: 0)
    }

    func goRight() {
        physicsBody?.velocity = CGVector(dx: defaultMovementUnits, dy: 0)
    }

    func attack() {
        ValsRevenge.log("🗡 Player is attacking!", category: .player)
        #warning("TODO: attack")
        isAttacking = false
    }
}
