//
//  Player.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 08.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import GameplayKit
import SpriteKit

class Player: SKSpriteNode {

    // MARK: - Properties

    var isAttacking: Bool = false

    var agent = GKAgent2D()

    var movementSpeed: CGFloat = 5

    var maxProjectiles: Int = 1
    var numProjectiles: Int = 0

    var projectileSpeed: CGFloat = 25
    var projectileRange: TimeInterval = 1

    let attackDelay = SKAction.wait(forDuration: 0.25)

    // MARK: GKState

    var stateMachine = GKStateMachine(states: [PlayerHasKeyState(), PlayerHasNoKeyState()])

    var hud = SKNode()

    // MARK: Private Properties

    private let treasureLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")

    private let keysLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")

    private var playerMovementUnits: CGFloat = 100

    private var knifeMovementUnits: CGFloat = 300

    private var keys: Int = 0 {
        didSet {
            ValsRevenge.log("Keys: \(keys)", category: .player)
            keysLabel.text = "Keys: \(keys)"
            if keys < 1 {
                stateMachine.enter(PlayerHasNoKeyState.self)
            } else {
                stateMachine.enter(PlayerHasKeyState.self)
            }
        }
    }

    private var treasure: Int = 0 {
        didSet {
            ValsRevenge.log("Treasure: \(treasure)", category: .player)
            treasureLabel.text = "Treasure: \(treasure)"
        }
    }

    // MARK: - Lifecycle

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAgent()
        setupStates()
    }
}

// MARK: - Interface

extension Player {

    func collectItem(_ collectibleNode: SKNode) {
        guard let collectible = collectibleNode.entity?.component(ofType: CollectibleComponent.self) else {
            return
        }

        collectible.collectedItem()

        switch GameObjectType(rawValue: collectible.collectibleType) {
        case .key:
            ValsRevenge.log("Collected key!", category: .player)
            keys += collectible.value

        case .food:
            ValsRevenge.log("Collected food!", category: .player)
            if let healthComponent = entity?.component(ofType: HealthComponent.self) {
                healthComponent.updateHealth(collectible.value, forNode: self)
            }

        case .treasure:
            ValsRevenge.log("Collected treasure!", category: .player)
            treasure += collectible.value

        default:
            break
        }
    }

    func useKeyToOpenDoor(_ doorNode: SKNode) {
        ValsRevenge.log("Used key to open door", category: .player)
        switch stateMachine.currentState {
        case is PlayerHasKeyState:
            keys -= 1
            doorNode.removeFromParent()
            run(SKAction.playSoundFileNamed("door_open", waitForCompletion: true))
        default:
            break
        }
    }

    func setupHUD(scene: MainScene) {
        // Set up the treasure label.
        treasureLabel.text = "Treasure: \(treasure)"
        treasureLabel.horizontalAlignmentMode = .right
        treasureLabel.verticalAlignmentMode = .center
        treasureLabel.position = CGPoint(x: 0, y: -treasureLabel.frame.height)
        treasureLabel.zPosition += 1

        // Set up the keys label.
        keysLabel.text = "Keys: \(keys)"
        keysLabel.horizontalAlignmentMode = .right
        keysLabel.verticalAlignmentMode = .center
        keysLabel.position = CGPoint(x: 0, y: treasureLabel.frame.minY - keysLabel.frame.height)
        keysLabel.zPosition += 1

        // Add the labels to the HUD.
        hud.addChild(treasureLabel)
        hud.addChild(keysLabel)

        // Add the HUD to the scene.
        scene.addChild(hud)
    }
}

// MARK: - Private

private extension Player {

    // MARK: - Setup

    func setupAgent() {
        agent.delegate = self
    }

    func setupStates() {
        stateMachine.enter(PlayerHasNoKeyState.self)
    }
}
