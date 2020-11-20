//
//  MainScene+GameOver.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 20.11.20.
//

import Foundation

extension MainScene {

    func gameOver() {
        blobPlayer.startDieAnimation()

        // Remove repeatable action on main scene.
        removeAction(forKey: Constant.ActionKey.dropGloops)

        // Loop through child nodes and stop actions on collectibles.
        enumerateChildNodes(withName: "//\(Constant.Node.Collectible.namePrefix)*") { node, _ in
            // Stop and remove drops.
            node.removeAllActions()
            // Remove body so no collisions occur.
            node.physicsBody = nil
        }
    }
}
