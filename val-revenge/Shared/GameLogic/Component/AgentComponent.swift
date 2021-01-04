//
//  AgentComponent.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 04.01.21.
//  Copyright © 2021 backslash-f. All rights reserved.
//

import SpriteKit
import GameplayKit

class AgentComponent: GKComponent {

    // MARK: - Properties

    let agent = GKAgent2D()

    lazy var interceptGoal: GKGoal = {
        guard let scene = componentNode.scene as? MainScene,
              let player = scene.childNode(withName: Constant.Node.Player.name) as? Player else {
            return GKGoal(toWander: 1.0)
        }
        return GKGoal(toInterceptAgent: player.agent, maxPredictionTime: 1.0)
    }()

    override class var supportsSecureCoding: Bool {
        true
    }

    // MARK: - GKComponent

    override func didAddToEntity() {
        setupGoalsAndBehaviors()
    }

    override func update(deltaTime seconds: TimeInterval) {
        updateGoalsAndBehaviors()
    }
}

// MARK: - Private

private extension AgentComponent {

    func setupGoalsAndBehaviors() {
        guard let scene = componentNode.scene as? MainScene else {
            return
        }

        // Set up the goals and behaviors.
        let wanderGoal = GKGoal(toWander: 1.0)
        agent.behavior = GKBehavior(goals: [wanderGoal, interceptGoal], andWeights: [100, 0])

        // Set the delegate.
        agent.delegate = componentNode

        // Constrain the agent's movement.
        agent.mass = 1
        agent.maxAcceleration = 125
        agent.maxSpeed = 125
        agent.radius = 60
        agent.speed = 100

        // Add the agent component to the component system.
        scene.agentComponentSystem.addComponent(agent)
    }

    func updateGoalsAndBehaviors() {
        guard let scene = componentNode.scene as? MainScene,
              let player = scene.childNode(withName: Constant.Node.Player.name) as? Player else {
            return
        }

        switch player.stateMachine.currentState {
        case is PlayerHasKeyState:
            agent.behavior?.setWeight(100, for: interceptGoal)
        default:
            agent.behavior?.setWeight(0, for: interceptGoal)
        }
    }
}
