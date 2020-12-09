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
            static let stop         = "ControllerStop"
            static let left         = "ControllerLeft"
            static let right        = "ControllerRight"
            static let up           = "ControllerUp"
            static let down         = "ControllerDown"
            static let topLeft      = "ControllerTopLeft"
            static let topRight     = "ControllerTopRight"
            static let bottomLeft   = "ControllerBottomLeft"
            static let bottomRight  = "ControllerBottomRight"
        }

        struct Player {
            static let name = "Player"
        }
    }
}
