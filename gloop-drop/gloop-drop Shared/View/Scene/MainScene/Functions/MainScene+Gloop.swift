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
        setupDropNumber()
        setupDropSpeed()

        // Set up repeating action.
        let wait = SKAction.wait(forDuration: TimeInterval(dropSpeed))
        let spawn = SKAction.run { [weak self] in
            self?.spawnGloop()
        }
        let dropGloopsSequence = SKAction.sequence([wait, spawn])
        let dropGloopsRepeatingSequence = SKAction.repeat(dropGloopsSequence, count: numberOfDrops)

        run(dropGloopsRepeatingSequence, withKey: Constant.ActionKey.dropGloops)
    }
}

// MARK: - Private

private extension MainScene {

    /// Sets the number of drops based on the level.
    func setupDropNumber() {
        switch level {
        case 1...5:
            numberOfDrops = level * 10
        case 6:
            numberOfDrops = 75
        case 7:
            numberOfDrops = 100
        case 8:
            numberOfDrops = 150
        default:
            numberOfDrops = 150
        }
    }

    // Sets the drop speed based on the level.
    func setupDropSpeed() {
        dropSpeed = 1 / (CGFloat(level) + (CGFloat(level) / CGFloat(numberOfDrops)))
        if dropSpeed < minDropSpeed {
            dropSpeed = minDropSpeed
        } else if dropSpeed > maxDropSpeed {
            dropSpeed = maxDropSpeed
        }
    }

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
