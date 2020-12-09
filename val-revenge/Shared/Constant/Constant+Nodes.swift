//
//  Constant+Player.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 08.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

extension Constant {

    struct Node {

        struct Background {
            static let name = "Background"
        }

        struct ButtonAttack {
            static let name = "ButtonAttack"
        }

        // swiftlint:disable identifier_name
        struct Controller {
            static let namePrefix   = "Controller"
            static let stop         = "\(namePrefix)Stop"
            static let left         = "\(namePrefix)Left"
            static let right        = "\(namePrefix)Right"
            static let up           = "\(namePrefix)Up"
            static let down         = "\(namePrefix)Down"
            static let topLeft      = "\(namePrefix)TopLeft"
            static let topRight     = "\(namePrefix)TopRight"
            static let bottomLeft   = "\(namePrefix)BottomLeft"
            static let bottomRight  = "\(namePrefix)BottomRight"
        }

        struct Player {
            static let name = "Player"
        }
    }
}
