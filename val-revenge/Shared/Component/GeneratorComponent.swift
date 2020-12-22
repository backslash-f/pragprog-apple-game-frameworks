//
//  GeneratorComponent.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 22.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import SpriteKit
import GameplayKit

class GeneratorComponent: GKComponent {

    // MARK: - Properties

    @GKInspectable var monsterType: String = Constant.Node.Monster.skeleton
    @GKInspectable var maxMonsters: Int = 10

    @GKInspectable var waitTime: TimeInterval = 5
    @GKInspectable var monsterHealth: Int = 3

    override class var supportsSecureCoding: Bool {
        true
    }

    // MARK: - GKComponent

    override func didAddToEntity() {
        let waitAction = SKAction.wait(forDuration: waitTime)
        let spawnAction = SKAction.run { [weak self] in
            self?.spawnMonsterEntity()
        }
        let sequenceAction = SKAction.sequence([waitAction, spawnAction])
        let repeatAction = (maxMonsters == .zero) ?
            SKAction.repeatForever(sequenceAction) :
            SKAction.repeat(sequenceAction, count: maxMonsters)
        componentNode.run(repeatAction, withKey: Constant.Action.Key.spawnMonster)
    }
}

// MARK: - Interface

extension GeneratorComponent {

    func spawnMonsterEntity() {
        let monsterEntity = MonsterEntity(monsterType: monsterType)
        let imageNameSuffix = Constant.Node.Monster.imageNameSuffix
        let renderComponent = RenderComponent(imageNamed: "\(monsterType)\(imageNameSuffix)", scale: 0.65)
        monsterEntity.addComponent(renderComponent)

        if let monsterNode = monsterEntity.component(ofType: RenderComponent.self)?.spriteNode {
            monsterNode.position = componentNode.position
            componentNode.parent?.addChild(monsterNode)
            monsterNode.run(SKAction.moveBy(x: 100, y: 0, duration: 1.0))

            let healthComponent = HealthComponent()
            healthComponent.currentHealth = monsterHealth
            monsterEntity.addComponent(healthComponent)
        }
    }
}
