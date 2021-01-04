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

    override class var supportsSecureCoding: Bool {
        true
    }

    // MARK: - GKComponent

    override func didAddToEntity() {
        guard let scene = componentNode.scene as? MainScene else {
            return
        }

        // Set up the goals and behaviors.
        let wanderGoal = GKGoal(toWander: 1.0)
        agent.behavior = GKBehavior(goal: wanderGoal, weight: 100)

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
}
