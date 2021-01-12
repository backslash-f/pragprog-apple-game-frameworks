//
//  Player.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 08.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import GameplayKit
import SpriteKit

// swiftlint:disable identifier_name
enum Stance: String {
    case stop, left, right, up, down, topLeft, topRight, bottomLeft, bottomRight
}

class Player: SKSpriteNode {

    // MARK: - Properties

    var isAttacking: Bool = false

    var stance: Stance = .stop

    var agent = GKAgent2D()

    // MARK: GKState

    var stateMachine = GKStateMachine(states: [PlayerHasKeyState(), PlayerHasNoKeyState()])

    var hud = SKNode()

    // MARK: Private Properties

    private let treasureLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")

    private let keysLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")

    private var lastStance: Stance?

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

        // Setup up physics.
        let physicsBody = SKPhysicsBody(rectangleOf: knife.size)
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = true
        physicsBody.isDynamic = true
        physicsBody.categoryBitMask = PhysicsBody.projectile.categoryBitMask
        physicsBody.contactTestBitMask = PhysicsBody.projectile.contactTestBitMask
        physicsBody.collisionBitMask = PhysicsBody.projectile.collisionBitMask
        knife.physicsBody = physicsBody

        // Setup position.
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
