//
//  Collectible.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 05.11.20.
//

import SpriteKit

/// Stores different types of collectibles and can return heir textures.
enum CollectibleType: String {
    case none
    case gloop

    var texture: SKTexture? {
        switch self {
        case .gloop:
            return SKTexture(imageNamed: Constant.Node.Collectible.imageName)
        case .none:
            return nil
        }
    }
}

class Collectible: SKSpriteNode {

    // MARK: - Private Properties

    private var collectibleType: CollectibleType = .none

    // MARK: - Lifecycle

    init(collectibleType: CollectibleType) {
        self.collectibleType = collectibleType
        let texture = collectibleType.texture
        super.init(texture: texture, color: .clear, size: texture?.size() ?? .zero)
        setup()
        setupPhysicsBody()
        setupPhysicsCategories()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Interface

extension Collectible {

    func drop(dropSpeed: TimeInterval, floorLevel: CGFloat) {
        // Appear action.
        let appearAction = SKAction.fadeAlpha(to: 1.0, duration: 0.25)

        // Scale action.
        let scaleX = SKAction.scaleX(to: 1.0, duration: 1.0)
        let scaleY = SKAction.scaleY(to: 1.3, duration: 1.0)
        let scaleAction = SKAction.group([scaleX, scaleY])

        // Move action.
        let targetPosition = CGPoint(x: position.x, y: floorLevel)
        let moveAction = SKAction.move(to: targetPosition, duration: dropSpeed)

        // Fall sequence action.
        let fallSequenceAction = SKAction.sequence([appearAction, scaleAction, moveAction])

        // Shrink first, then run fall sequence action.
        scale(to: CGSize(width: 0.25, height: 1.0))
        run(fallSequenceAction, withKey: Constant.ActionKey.dropGloop)
    }

    // MARK: Handle Contact

    func collected() {
        let actionGroup = SKAction.group([collectSoundAction(), removeFromParentAction()])
        run(actionGroup)
    }

    func missed() {
        let moveAction = SKAction.moveBy(x: 0, y: -size.height/1.5, duration: 0.0)
        let splatXAction = SKAction.scaleX(to: 1.5, duration: 0.0) // Make wider.
        let splatYAction = SKAction.scaleY(to: 0.5, duration: 0.0) // Make shorter.

        let actionGroup = SKAction.group(
            [
                missSoundAction(),
                moveAction,
                splatXAction,
                splatYAction
            ]
        )

        self.run(actionGroup)
    }
}

// MARK: - Private

private extension Collectible {

    func setup() {
        name = "\(Constant.Node.Collectible.namePrefix)\(collectibleType)"
        anchorPoint = CGPoint(x: 0.5, y: 1.0)
        zPosition = Layer.collectible.rawValue
    }

    func setupPhysicsBody() {
        physicsBody = SKPhysicsBody(
            rectangleOf: size,
            center: CGPoint(
                x: 0.0,
                y: -size.height/2
            )
        )
        physicsBody?.affectedByGravity = false
    }

    func setupPhysicsCategories() {
        physicsBody?.categoryBitMask = PhysicsCategory.collectible.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue | PhysicsCategory.floor.rawValue
        physicsBody?.collisionBitMask = PhysicsCategory.none.rawValue
    }

    // MARK: Actions

    func removeFromParentAction() -> SKAction {
        SKAction.removeFromParent()
    }

    func collectSoundAction() -> SKAction {
        SKAction.playSoundFileNamed(Constant.Sound.collect, waitForCompletion: false)
    }

    func missSoundAction() -> SKAction {
        SKAction.playSoundFileNamed(Constant.Sound.miss, waitForCompletion: false)
    }
}
