//
//  HealthComponent.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 19.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import SpriteKit
import GameplayKit

class HealthComponent: GKComponent {

    // MARK: - Properties

    @GKInspectable var currentHealth: Int = 3
    @GKInspectable var maxHealth: Int = 3

    override class var supportsSecureCoding: Bool {
        true
    }

    // MARK: - Private Properties

    private let healthFull = SKTexture(imageNamed: Constant.Node.HealthMeter.full)
    private let healthEmpty = SKTexture(imageNamed: Constant.Node.HealthMeter.empty)

    // MARK: - GKComponent

    override func didAddToEntity() {
        setupHealthMeter()
    }
}

// MARK: - Private

private extension HealthComponent {

    func setupHealthMeter() {
        guard let healthMeter = SKReferenceNode(fileNamed: Constant.Node.HealthMeter.name) else {
            return
        }
        healthMeter.position = CGPoint(x: 0, y: 100)
        componentNode.addChild(healthMeter)
        updateHealth(0, forNode: componentNode)
    }

    func updateHealth(_ value: Int, forNode node: SKNode?) {
        currentHealth += value
        if currentHealth > maxHealth {
            currentHealth = maxHealth
        }
        for barNum in 1...maxHealth {
            (node as? Player) != nil ?
                setupBar(at: barNum, tint: .cyan) :
                setupBar(at: barNum)
        }
    }

    func setupBar(at num: Int, tint: SKColor? = nil) {
        let healtRegex = Constant.Node.HealthMeter.nameRegex
        guard let health = componentNode.childNode(withName: "\(healtRegex)\(num)") as? SKSpriteNode else {
            return
        }
        if currentHealth >= num {
            health.texture = healthFull
            if let tint = tint {
                health.color = tint
                health.colorBlendFactor = 1.0
            }
        } else {
            health.texture = healthEmpty
            health.colorBlendFactor = 0.0
        }
    }
}
