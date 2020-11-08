//
//  Collectibles.swift
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
        self.scale(to: CGSize(width: 0.25, height: 1.0))
        self.run(fallSequenceAction, withKey: Constant.ActionKey.dropGloop)
    }
}

// MARK: - Private

private extension Collectible {

    func setup() {
        name = "\(Constant.Node.Collectible.namePrefix)\(collectibleType)"
        anchorPoint = CGPoint(x: 0.5, y: 1.0)
        zPosition = Layer.collectible.rawValue
    }
}
