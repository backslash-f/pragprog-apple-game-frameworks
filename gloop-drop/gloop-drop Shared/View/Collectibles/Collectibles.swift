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
            return SKTexture(imageNamed: "gloop")
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

// MARK: - Private

private extension Collectible {

    static func createTexture(for collectibleType: CollectibleType) -> SKTexture? {
        switch collectibleType {
        case .gloop:
            return SKTexture(imageNamed: "gloop")
        case .none:
            return nil
        }
    }
    
    func setup() {
        name = "co_\(collectibleType)"
        anchorPoint = CGPoint(x: 0.5, y: 1.0)
        zPosition = Layer.collectible.rawValue
    }
}
