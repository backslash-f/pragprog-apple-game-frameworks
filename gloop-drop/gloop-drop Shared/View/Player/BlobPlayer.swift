//
//  BlobPlayer.swift
//  gloop-drop iOS
//
//  Created by Fernando Fernandes on 23.09.20.
//

import Foundation
import SpriteKit

/// Easily switch between animations.
enum PlayerAnimationType: String {
    case walk
}

class BlobPlayer: SKSpriteNode {

    // MARK: - Properties

    let baseSpeed: CGFloat = 2

    /// The "distance" this character moves when players use a controller to go to the left / right.
    let travelUnitsController: CGFloat = 80

    // MARK: - Private Properties

    private var walkTextures: [SKTexture]?

    private let defaultTexture = SKTexture(imageNamed: "\(Constant.Character.Blob.walkTexturePrefix)0")

    // MARK: - Lifecycle

    init() {
        super.init(texture: defaultTexture, color: .clear, size: defaultTexture.size())
        setupPlayer()
        loadWalkTextures()
    }

    required init?(coder aDecoder: NSCoder) {
        let errorMessage = "init(coder:) has not been implemented"
        GloopDropApp.logError(errorMessage)
        fatalError(errorMessage)
    }
}

// MARK: - Interface

extension BlobPlayer {

    func constrainPositionY(lowerAndUpperLimit: CGFloat) {
        let range = SKRange(lowerLimit: lowerAndUpperLimit, upperLimit: lowerAndUpperLimit)
        let lockToPlatform = SKConstraint.positionY(range)
        constraints = [lockToPlatform]
    }

    func durationOfMoveAnimation(to newPosition: CGPoint) -> TimeInterval {
        let distance = hypot(newPosition.x - position.x, newPosition.y - position.y)
        GloopDropApp.log("Distance: \(distance)", category: .player)

        let duration = TimeInterval(distance / baseSpeed) / 255
        GloopDropApp.log("Duration (speed): \(duration)", category: .player)

        return TimeInterval(duration)
    }

    func startWalkAnimation() {
        guard let walkTextures = walkTextures else {
            let errorMessage = "Could not find textures"
            GloopDropApp.logError(errorMessage)
            preconditionFailure(errorMessage)
        }

        startAnimation(
            textures: walkTextures,
            speed: 0.25,
            name: PlayerAnimationType.walk.rawValue,
            resize: true
        )
    }

    func move(to newPosition: CGPoint) {
        GloopDropApp.log("Current position: \(position)", category: .player)
        GloopDropApp.log("New position: \(newPosition)", category: .player)
        if shouldMove(to: newPosition) {
            flipLeftOrRight(to: newPosition)
            let duration = durationOfMoveAnimation(to: newPosition)
            let moveAction = SKAction.move(to: newPosition, duration: duration)
            run(moveAction)
        }
    }
}

// MARK: - Private

private extension BlobPlayer {
    
    // MARK: Setup

    func setupPlayer() {
        name = Constant.Character.Blob.name
        setScale(1.0)
        anchorPoint = CGPoint(x: 0.5, y: 0.0) // center-bottom
        zPosition = Layer.blobPlayer.rawValue
    }

    func loadWalkTextures() {
        loadTextures(
            atlasName: Constant.Character.Blob.atlasName,
            prefix: Constant.Character.Blob.walkTexturePrefix
        ) { [weak self] textures in
            self?.walkTextures = textures
            self?.startWalkAnimation()
        }
    }

    // MARK: - Displacement

    func shouldMove(to newPosition: CGPoint) -> Bool {
        isPositionValid(newPosition) && (newPosition != position)
    }

    func isPositionValid(_ position: CGPoint) -> Bool {
        guard let sceneWidth = scene?.size.width else {
            return false
        }
        let playerHalfWidth = size.width * anchorPoint.x
        let maximumLeft = playerHalfWidth
        let maximumRight = sceneWidth - playerHalfWidth
        return (position.x >= maximumLeft) && (position.x <= maximumRight)
    }

    func flipLeftOrRight(to newPosition: CGPoint) {
        (newPosition.x < position.x) ? flipLeft() : flipRight()
    }

    func flipLeft() {
        xScale = -abs(xScale)
    }

    func flipRight() {
        xScale = abs(xScale)
    }
}
