//
//  MainScene+Gloop.swift
//  gloop-drop iOS
//
//  Created by Fernando Fernandes on 05.11.20.
//

import SwiftUI

extension MainScene {

    func spawnGloop() {
        let collectible = Collectible(collectibleType: .gloop)
        collectible.position = CGPoint(x: blobPlayer.position.x, y: blobPlayer.position.y * 2.5)
        addChild(collectible)

        collectible.drop(dropSpeed: TimeInterval(1.0), floorLevel: blobPlayer.frame.minY)
    }
}
