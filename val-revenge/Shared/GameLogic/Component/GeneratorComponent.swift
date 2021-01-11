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

    @GKInspectable var monsterType: String = GameObject.defaultGeneratorType
    @GKInspectable var maxMonsters: Int = 10

    @GKInspectable var waitTime: TimeInterval = 5
    @GKInspectable var monsterHealth: Int = 3

    var isRunning = false

    override class var supportsSecureCoding: Bool {
        true
    }

    // MARK: - GKComponent

    override func didAddToEntity() {
        addPhysicsComponentToGenerator()
    }

    override func update(deltaTime seconds: TimeInterval) {
        handleMonsterGenerator()
    }
}

// MARK: - Interface

extension GeneratorComponent {

    func addPhysicsComponentToGenerator() {
        let physicsComponent = PhysicsComponent()
        physicsComponent.bodyCategory = PhysicsCategory.monster.rawValue
        componentNode.entity?.addComponent(physicsComponent)
    }

    func handleMonsterGenerator() {
        if let scene = componentNode.scene as? MainScene {
            switch scene.mainGameStateMachine.currentState {
            case is PauseState:
                if isRunning == true {
                    stopGenerator()
                }
            case is PlayingState:
                if isRunning == false {
                    startGenerator()
                }
            default:
                break
            }
        }
    }

    func startGenerator() {
        isRunning = true
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

    func stopGenerator() {
        isRunning = false
        componentNode.removeAction(forKey: Constant.Action.Key.spawnMonster)
    }

    func spawnMonsterEntity() {
        let monsterEntity = MonsterEntity(monsterType: monsterType)
        let imageNameSuffix = Constant.Node.Monster.imageNameSuffix
        let renderComponent = RenderComponent(imageNamed: "\(monsterType)\(imageNameSuffix)", scale: 0.65)
        monsterEntity.addComponent(renderComponent)

        if let monsterNode = monsterEntity.component(ofType: RenderComponent.self)?.spriteNode {
            monsterNode.position = componentNode.position
            componentNode.parent?.addChild(monsterNode)

            // Initial spawn movement.
            let randomPositions: [CGFloat] = [-50, -50, 50]
            let randomX = randomPositions.randomElement() ?? 0
            monsterNode.run(SKAction.moveBy(x: randomX, y: 0, duration: 1.0))

            let healthComponent = HealthComponent()
            healthComponent.currentHealth = monsterHealth
            monsterEntity.addComponent(healthComponent)

            let agentComponent = AgentComponent()
            monsterEntity.addComponent(agentComponent)

            let physicsComponent = PhysicsComponent()
            physicsComponent.bodyCategory = PhysicsCategory.monster.rawValue
            monsterEntity.addComponent(physicsComponent)

            if let mainScene = componentNode.scene as? MainScene {
                mainScene.entities.append(monsterEntity)
            }
        }
    }
}
