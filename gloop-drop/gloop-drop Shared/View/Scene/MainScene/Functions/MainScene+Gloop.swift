//
//  MainScene+Gloop.swift
//  gloop-drop iOS
//
//  Created by Fernando Fernandes on 05.11.20.
//

import SwiftUI
import SpriteKit

extension MainScene {

    func spawnMultipleGloops() {
        // Set up repeating action.
        let wait = SKAction.wait(forDuration: TimeInterval(1.0))
        let spawn = SKAction.run { [weak self] in
            self?.spawnGloop()
        }
        let dropGloopsSequence = SKAction.sequence([wait, spawn])
        let dropGloopsRepeatingSequence = SKAction.repeat(dropGloopsSequence, count: 10)

        run(dropGloopsRepeatingSequence, withKey: Constant.ActionKey.dropGloops)
    }
}

// MARK: - Private

private extension MainScene {

    func spawnGloop() {
        let collectible = Collectible(collectibleType: CollectibleType.gloop)

        // Set random position.
        let margin = collectible.size.width * 2
        let dropRange = SKRange(lowerLimit: frame.minX + margin, upperLimit: frame.maxX - margin)
        let randomX = CGFloat.random(in: dropRange.lowerLimit...dropRange.upperLimit)

        collectible.position = CGPoint(x: randomX, y: blobPlayer.position.y * 2.5)
        addChild(collectible)

        collectible.drop(dropSpeed: TimeInterval(1.0), floorLevel: blobPlayer.frame.minY)
    }
}
