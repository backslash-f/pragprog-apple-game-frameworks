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

    private var hitAction = SKAction()
    private var dieAction = SKAction()

    // MARK: - GKComponent

    override func didAddToEntity() {
        setupHealthMeter()
    }
}

// MARK: - Interface

extension HealthComponent {

    func updateHealth(_ value: Int, forNode node: SKNode?) {
        currentHealth += value
        if currentHealth > maxHealth {
            currentHealth = maxHealth
        }
        for barNum in 1...maxHealth {
            if value < 0 { // Run hit or die actions.
                currentHealth == 0 ? componentNode.run(dieAction) : componentNode.run(hitAction)
            }
            (node as? Player) != nil ?
                setupBar(at: barNum, tint: .cyan) :
                setupBar(at: barNum)
        }
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
        setupActions()
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

    func setupActions() {
        if (componentNode as? Player) != nil {
            hitAction = SKAction.playSoundFileNamed("player_hit", waitForCompletion: false)
            let playSound = SKAction.playSoundFileNamed("player_die", waitForCompletion: false)
            dieAction = SKAction.run {
                self.componentNode.run(playSound, completion: {
                    #warning("TODO: Add code to restart the game")
                    self.currentHealth = self.maxHealth
                })
            }
        } else {
            hitAction = SKAction.playSoundFileNamed("monster_hit", waitForCompletion: false)

            let playSound = SKAction.playSoundFileNamed("monster_die", waitForCompletion: false)
            dieAction = SKAction.run {
                self.componentNode.run(playSound) {
                    self.componentNode.removeFromParent()
                }
            }
        }
    }
}
