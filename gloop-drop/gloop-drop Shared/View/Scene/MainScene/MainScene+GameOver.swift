//
//  MainScene+GameOver.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 20.11.20.
//

import SpriteKit

extension MainScene {

    func gameOver() {
        showMessage(Constant.Label.Message.gameOver)
        stopGame()
        stopDroppingGloops()
        removeRemainingGloops()
        centerPlayer()
    }
}

// MARK: - Private

private extension MainScene {

    func stopDroppingGloops() {
        // Remove repeatable action on main scene.
        removeAction(forKey: Constant.ActionKey.dropGloops)

        // Loop through child nodes and stop actions on collectibles.
        enumerateChildNodes(withName: Constant.Node.Collectible.namePrefixRegex) { node, _ in
            // Stop gloop from dropping.
            node.removeAction(forKey: Constant.ActionKey.dropGloop)
            // Remove body so no collisions occur.
            node.physicsBody = nil
        }
    }

    func removeRemainingGloops() {
        var waitingTime: CGFloat = .zero
        enumerateChildNodes(withName: Constant.Node.Collectible.namePrefixRegex) { node, _ in
            // Pop remaining drops in sequence.
            let initialWaitAction = SKAction.wait(forDuration: 1.0)
            let waitAction = SKAction.wait(forDuration: TimeInterval(0.15 * waitingTime))
            let removeFromParentAction = SKAction.removeFromParent()
            let actionSequence = SKAction.sequence([initialWaitAction, waitAction, removeFromParentAction])

            node.run(actionSequence)
            waitingTime += 1
        }
    }

    func centerPlayer() {
        let moveToCenterAction = SKAction.moveTo(x: size.width/2, duration: 0.5)
        player.run(moveToCenterAction)
    }
}
