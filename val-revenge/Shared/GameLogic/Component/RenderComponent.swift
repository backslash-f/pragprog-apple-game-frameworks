//
//  RenderComponent.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 22.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import SpriteKit
import GameplayKit

class RenderComponent: GKComponent {

    // MARK: - Properties

    lazy var spriteNode: SKSpriteNode? = {
        entity?.component(ofType: GKSKNodeComponent.self)?.node as? SKSpriteNode
    }()

    override class var supportsSecureCoding: Bool {
        true
    }

    // MARK: - Lifecycle

    init(node: SKSpriteNode) {
        super.init()
        spriteNode = node
    }

    init(imageNamed: String, scale: CGFloat) {
        super.init()

        spriteNode = SKSpriteNode(imageNamed: imageNamed)
        spriteNode?.setScale(scale)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - GKComponent

    override func didAddToEntity() {
        spriteNode?.entity = entity
    }
}
