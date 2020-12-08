//
//  Player.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 08.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import SpriteKit

// swiftlint:disable identifier_name
enum Direction: String {
    case stop, left, right, up, down
}

class Player: SKSpriteNode {
}

// MARK: - Interface

extension Player {

    func move(_ direction: Direction) {
        ValsRevenge.log("Player moved: \(direction.rawValue)", category: .player)
    }

    func stop() {
        ValsRevenge.log("Player stoped", category: .player)
    }
}
