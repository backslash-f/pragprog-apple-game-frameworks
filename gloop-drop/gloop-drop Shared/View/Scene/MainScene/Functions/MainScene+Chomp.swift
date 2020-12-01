//
//  MainScene+Chomp.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 01.12.20.
//

import SpriteKit
import SwiftUI

extension MainScene {

    // Adds the "chomp" text at the player's position.
    func addChompLabel() {
        let chompLabel = SKLabelNode(fontNamed: Constant.Font.Nosifer.name)
        chompLabel.name = Constant.Label.Chomp.name
        chompLabel.alpha = 0.0
        chompLabel.fontSize = 22.0
        chompLabel.text = Constant.Label.Chomp.text
        chompLabel.horizontalAlignmentMode = .center
        chompLabel.verticalAlignmentMode = .bottom
        chompLabel.position = CGPoint(x: blobPlayer.position.x, y: blobPlayer.frame.maxY + 25)
        chompLabel.zRotation = CGFloat.random(in: -0.15...0.15)
        addChild(chompLabel)

        // Add actions to fade in, rise up, and fade out.
        let fadeInAction = SKAction.fadeAlpha(to: 1.0, duration: 0.05)
        let fadeOutAction = SKAction.fadeAlpha(to: 0.0, duration: 0.45)
        let moveUpAction = SKAction.moveBy(x: 0.0, y: 45, duration: 0.45)
        let actionGroup = SKAction.group([fadeOutAction, moveUpAction])
        let removeFromParentAction = SKAction.removeFromParent()
        let chompActionSequence = SKAction.sequence([fadeInAction, actionGroup, removeFromParentAction])
        chompLabel.run(chompActionSequence)
    }
}
