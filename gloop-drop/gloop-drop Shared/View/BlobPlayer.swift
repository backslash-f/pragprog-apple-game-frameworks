//
//  BlobPlayer.swift
//  gloop-drop iOS
//
//  Created by Fernando Fernandes on 23.09.20.
//

import SpriteKit

/// Easily switch between animations.
enum PlayerAnimationType: String {
    case walk, die
}

class BlobPlayer: SKSpriteNode {

    // MARK: - Properties

    let baseSpeed: CGFloat = 2

    /// The "distance" this character moves when players use a controller to go to the left / right.
    let travelUnitsController: CGFloat = 40

    // MARK: Player Movement

    var isPlayerMoving = false

    // MARK: - Private Properties

    private var walkTextures: [SKTexture]?
    private var dieTextures: [SKTexture]?
    private let defaultTexture = SKTexture(imageNamed: "\(Constant.Node.Blob.walkTexturePrefix)0")

    // MARK: - Lifecycle

    init() {
        super.init(texture: defaultTexture, color: .clear, size: defaultTexture.size())
        setupPlayer()
        setupPhysicsBody()
        setupPhysicsCategories()
        loadWalkTextures()
        loadDieTextures()
    }

    required init?(coder aDecoder: NSCoder) {
        let errorMessage = "init(coder:) has not been implemented"
        GloopDropApp.logError(errorMessage)
        fatalError(errorMessage)
    }
}

// MARK: - Interface

extension BlobPlayer {

    func mumble() {
        let random = Int.random(in: 1...3)
        let mumbleSoundFilename = "\(Constant.Sound.Mumble.filenamePrefix)\(random)"
        let playMumbleSoundAction = SKAction.playSoundFileNamed(mumbleSoundFilename, waitForCompletion: true)
        run(playMumbleSoundAction, withKey: Constant.Sound.Mumble.key)
    }

    func constrainPositionY(lowerAndUpperLimit: CGFloat) {
        let range = SKRange(lowerLimit: lowerAndUpperLimit, upperLimit: lowerAndUpperLimit)
        let lockToPlatform = SKConstraint.positionY(range)
        constraints = [lockToPlatform]
    }

    func startWalkAnimation() {
        guard let walkTextures = walkTextures else {
            let errorMessage = "Could not find walking textures"
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

    func startDieAnimation() {
        guard let dieTextures = dieTextures else {
            let errorMessage = "Could not find dying textures"
            GloopDropApp.logError(errorMessage)
            preconditionFailure(errorMessage)
        }
        // Stop the walk animation.
        removeAction(forKey: PlayerAnimationType.walk.rawValue)

        // Run dying animation (forever).
        startAnimation(
            textures: dieTextures,
            speed: 0.25,
            name: PlayerAnimationType.die.rawValue,
            resize: true
        )
    }

    func move(to newPosition: CGPoint) {
        GloopDropApp.log("Current position: \(position)", category: .player)
        GloopDropApp.log("New position: \(newPosition)", category: .player)
        flipLeftOrRight(to: newPosition)
        let adjustedNewPosition = adjust(newPosition)
        position = adjustedNewPosition
    }
}

// MARK: - Private

private extension BlobPlayer {

    // MARK: Setup

    func setupPlayer() {
        name = Constant.Node.Blob.name
        setScale(1.0)
        anchorPoint = CGPoint(x: 0.5, y: 0.0) // center-bottom
        zPosition = Layer.blobPlayer.rawValue
    }

    func setupPhysicsBody() {
        physicsBody = SKPhysicsBody(
            rectangleOf: size,
            center: CGPoint(
                x: 0.0,
                y: size.height/2
            )
        )
        physicsBody?.affectedByGravity = false
    }

    func setupPhysicsCategories() {
        physicsBody?.categoryBitMask = PhysicsCategory.player.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategory.collectible.rawValue
        physicsBody?.collisionBitMask = PhysicsCategory.none.rawValue
    }

    func loadWalkTextures() {
        loadTextures(
            atlasName: Constant.Node.Blob.atlasName,
            prefix: Constant.Node.Blob.walkTexturePrefix
        ) { [weak self] textures in
            self?.walkTextures = textures
        }
    }

    func loadDieTextures() {
        loadTextures(
            atlasName: Constant.Node.Blob.atlasName,
            prefix: Constant.Node.Blob.dieTexturePrefix
        ) { [weak self] textures in
            self?.dieTextures = textures
        }
    }

    // MARK: - Displacement

    /// Adjusts the given `position` to not allow the player to slide beyond the screen bounds.
    func adjust(_ position: CGPoint) -> CGPoint {
        guard let sceneWidth = scene?.size.width else {
            return position
        }

        let playerHalfWidth = size.width * anchorPoint.x
        let maximumLeft = playerHalfWidth
        let maximumRight = sceneWidth - playerHalfWidth

        let adjustedX: CGFloat
        if position.x < maximumLeft {
            adjustedX = maximumLeft
        } else if position.x > maximumRight {
            adjustedX = maximumRight
        } else {
            adjustedX = position.x
        }

        return CGPoint(x: adjustedX, y: position.y)
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
