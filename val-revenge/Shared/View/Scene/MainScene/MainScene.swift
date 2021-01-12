//
//  MainScene.swift
//  valsrevenge
//
//  Created by Fernando Fernandes on 07.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import CSKScene
import Device
import GameplayKit
import SpriteKit

class MainScene: CSKScene {

    // MARK: - Properties

    // MARK: GameplayKit

    var entities = [GKEntity]()
    var graphs = [String: GKGraph]()
    let agentComponentSystem = GKComponentSystem(componentClass: GKAgent2D.self)

    // MARK: Internal Properties

    internal var player: Player?

    internal let device = Device()

    // MARK: States

    internal let mainGameStateMachine = GKStateMachine(states: [PauseState(), PlayingState()])

    // MARK: Private Properties

    private var lastUpdateTime: TimeInterval = .zero

    // MARK: - Lifecycle

    override init(size: CGSize, debugSettings: DebugSettings = DebugSettings()) {
        super.init(size: size, debugSettings: debugSettings)
        setupScene()
        setupGameControllerListener()
        setupOrientationListener()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupScene()
        setupGameControllerListener()
        setupOrientationListener()
    }
}

// MARK: - SpriteKit

extension MainScene {

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupState()
        setupPlayer()
        setupCamera()
        setupTiles()
        startAdvancedNavigation()
    }

    override func update(_ currentTime: TimeInterval) {
        updateEntitiesDeltaTime(with: currentTime)
        player?.updatePosition()
        player?.updateAction()
    }

    override func didFinishUpdate() {
        updateVirtualControllerLocation()
        updateHUDLocation()
    }
}

// MARK: - Private

private extension MainScene {

    func setupScene() {
        scaleMode = .aspectFill
        physicsWorld.contactDelegate = self
    }

    func setupState() {
        mainGameStateMachine.enter(PauseState.self)
    }

    func setupPlayer() {
        player = childNode(withName: Constant.Node.Player.name) as? Player
        if let player = player {
            player.stance = .stop
            agentComponentSystem.addComponent(player.agent)
            player.setupHUD(scene: self)
        }
    }

    func setupCamera() {
        guard let player = player else {
            return
        }
        let distance = SKRange(constantValue: 0)
        let playerConstraint = SKConstraint.distance(distance, to: player)

        camera?.constraints = [playerConstraint]
    }

    func setupTiles() {
        let grassMapNode = childNode(withName: Constant.Node.TileMap.grassTileMap) as? SKTileMapNode
        grassMapNode?.setupEdgeLoop()

        let dungeonMapNode = childNode(withName: Constant.Node.TileMap.dungeonTileMap) as? SKTileMapNode
        dungeonMapNode?.setupMapPhysics()
    }

    func updateEntitiesDeltaTime(with currentTime: TimeInterval) {
        // Calculate time since last update.
        let deltaTime: TimeInterval
        if lastUpdateTime > .zero {
            deltaTime = currentTime - lastUpdateTime
        } else {
            deltaTime = .zero
        }
        entities.forEach { $0.update(deltaTime: deltaTime) }
        agentComponentSystem.update(deltaTime: deltaTime)
        lastUpdateTime = currentTime
    }

    func startAdvancedNavigation() {

        // Check for a navigation graph and a key node.
        guard let sceneGraph = graphs.values.first,
              let keyNode = childNode(withName: "key") as? SKSpriteNode else {
            return
        }

        // Set up the agent.
        let agent = GKAgent2D()

        // Set up the delegate and the initial position.
        agent.delegate = keyNode
        agent.position = vector_float2(Float(keyNode.position.x), Float(keyNode.position.y))

        // Set up the agent's properties.
        agent.mass = 1
        agent.speed = 50
        agent.maxSpeed = 100
        agent.maxAcceleration = 100
        agent.radius = 60

        // Find obstacles.
        var obstacles = [GKCircleObstacle]()

        // Locate food nodes.
        enumerateChildNodes(withName: "food_*") { node, _ in

            // Create compatible obstacle.
            let circle = GKCircleObstacle(radius: Float(node.frame.size.width/2))
            circle.position = vector_float2(Float(node.position.x), Float(node.position.y))
            obstacles.append(circle)
        }

        // Find the path.
        if let nodesOnPath = sceneGraph.nodes as? [GKGraphNode2D] {

            // Show the path (optional code).
            for (index, node) in nodesOnPath.enumerated() {
                let shapeNode = SKShapeNode(circleOfRadius: 10)
                shapeNode.fillColor = .green
                shapeNode.position = CGPoint(x: CGFloat(node.position.x), y: CGFloat(node.position.y))

                // Add node number
                let number = SKLabelNode(text: "\(index)")
                number.position.y = 15
                shapeNode.addChild(number)

                addChild(shapeNode)
            }
            // (end optional code)

            // Create a path to follow
            let path = GKPath(graphNodes: nodesOnPath, radius: 0)
            path.isCyclical = true

            // Set up the goals.
            let followPath = GKGoal(toFollow: path, maxPredictionTime: 1.0, forward: true)
            let avoidObstacles = GKGoal(toAvoid: obstacles, maxPredictionTime: 1.0)

            // Add behavior based on goals.
            agent.behavior = GKBehavior(goals: [followPath, avoidObstacles])

            // Set goal weights.
            agent.behavior?.setWeight(0.5, for: followPath)
            agent.behavior?.setWeight(100, for: avoidObstacles)

            // Add agent to component system.
            agentComponentSystem.addComponent(agent)
        }
    }
}
