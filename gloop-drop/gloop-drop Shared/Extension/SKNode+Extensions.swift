//
//  SKNode+Extensions.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 30.11.20.
//

import SpriteKit

extension SKNode {

    // Sets up an endless scroller.
    func setupScrollingView(imageNamed name: String,
                            layer: Layer,
                            blocks: Int,
                            speed: TimeInterval) {

        // Create sprite nodes; set positions based on the node's # and width.
        (0..<blocks).enumerated().forEach { index, _ in
            let spriteNode = SKSpriteNode(imageNamed: name)
            spriteNode.anchorPoint = .zero
            let xPosition = CGFloat(index) * spriteNode.size.width
            spriteNode.position = CGPoint(x: xPosition, y: 0)
            spriteNode.zPosition = layer.rawValue
            spriteNode.name = name
            spriteNode.endlessScroll(speed: speed)
            addChild(spriteNode)
        }
    }
}
