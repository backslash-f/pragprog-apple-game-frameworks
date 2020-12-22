//
//  AnimationComponent.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 22.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import SpriteKit
import GameplayKit

struct Animation {

    let textures: [SKTexture]
    var timePerFrame: TimeInterval

    let repeatTexturesForever: Bool
    let resizeTexture: Bool
    let restoreTexture: Bool

    init(textures: [SKTexture],
         timePerFrame: TimeInterval = TimeInterval(1.0 / 5.0),
         repeatTexturesForever: Bool = true, resizeTexture: Bool = true,
         restoreTexture: Bool = true) {

        self.textures = textures
        self.timePerFrame = timePerFrame
        self.repeatTexturesForever = repeatTexturesForever
        self.resizeTexture = resizeTexture
        self.restoreTexture = restoreTexture
    }
}

class AnimationComponent: GKComponent {

    // MARK: - Properties

    @GKInspectable var animationType: String = GameObject.defaultAnimationType

    override class var supportsSecureCoding: Bool {
        true
    }

    // MARK: - GKComponent

    override func didAddToEntity() {
        guard let animation = GameObject.forAnimationType(GameObjectType(rawValue: animationType)) else {
            return
        }
        let textures = animation.textures
        let timePerFrame = animation.timePerFrame
        let animationAction = SKAction.animate(with: textures, timePerFrame: timePerFrame)

        if animation.repeatTexturesForever == true {
            let repeatAction = SKAction.repeatForever(animationAction)
            componentNode.run(repeatAction)
        } else {
            componentNode.run(animationAction)
        }
    }
}
