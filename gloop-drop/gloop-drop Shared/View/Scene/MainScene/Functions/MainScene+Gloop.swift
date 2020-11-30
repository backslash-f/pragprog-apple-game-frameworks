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
        hideMessage()
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

    func checkForRemainingDrops() {
        GloopDropApp.log("Drops collected: \(dropsCollected)", category: .gameLoop)
        GloopDropApp.log("Drops expected: \(dropsExpected)", category: .gameLoop)
        if dropsCollected == dropsExpected {
            nextLevel()
        }
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
        dropsCollected = 0
        dropsExpected = numberOfDrops
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
        var randomX = CGFloat.random(in: dropRange.lowerLimit...dropRange.upperLimit)

        enhanceDropMovement(margin: margin, randomX: &randomX)

        collectible.position = CGPoint(x: randomX, y: blobPlayer.position.y * 2.5)
        addChild(collectible)

        collectible.drop(dropSpeed: TimeInterval(1.0), floorLevel: blobPlayer.frame.minY)
    }

    /// Creates a "snake-like" pattern.
    func enhanceDropMovement(margin: CGFloat, randomX: inout CGFloat) {
         // Set a range.
         let randomModifier = SKRange(lowerLimit: 50 + CGFloat(level), upperLimit: 60 * CGFloat(level))
         var modifier = CGFloat.random(in: randomModifier.lowerLimit...randomModifier.upperLimit)
         if modifier > 400 {
            modifier = 400
         }

         // Set the previous drop location.
         if previousDropLocation == 0.0 {
            previousDropLocation = randomX
         }

         // Clamp its x-position.
         if previousDropLocation < randomX {
           randomX = previousDropLocation + modifier
         } else {
           randomX = previousDropLocation - modifier
         }

         // Make sure the collectible stays within the frame.
         if randomX <= (frame.minX + margin) {
           randomX = frame.minX + margin
         } else if randomX >= (frame.maxX - margin) {
           randomX = frame.maxX - margin
         }

         // Store the location.
        previousDropLocation = randomX
    }

    func nextLevel() {
        showMessage(Constant.Label.Message.getReady)
        let nextLevel = level + 1
        GloopDropApp.log("Level completed! Next level: \(nextLevel)", category: .gameLoop)
        let waitAction = SKAction.wait(forDuration: 2.25)
        run(waitAction) { [weak self] in
            self?.level = nextLevel
            self?.spawnMultipleGloops()
        }
    }
}
