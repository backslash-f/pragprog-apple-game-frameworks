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

        struct Camera {
            struct PrimaryCamera {
                static let name = "PrimaryCamera"
            }
        }

        // swiftlint:disable identifier_name
        struct Controller {
            static let name         = "Controller"
            static let stop         = "\(name)Stop"
            static let left         = "\(name)Left"
            static let right        = "\(name)Right"
            static let up           = "\(name)Up"
            static let down         = "\(name)Down"
            static let topLeft      = "\(name)TopLeft"
            static let topRight     = "\(name)TopRight"
            static let bottomLeft   = "\(name)BottomLeft"
            static let bottomRight  = "\(name)BottomRight"
        }

        struct HealthMeter {
            static let name = "HealthMeter"
            static let nameRegex = ".//health_"
            static let full = "health_full"
            static let empty = "health_empty"
        }

        struct Knife {
            static let name = "Knife"
            static let imageName = "knife"
        }

        struct Player {
            static let name = "Player"
        }

        struct TileMap {
            static let dungeonTileMap = "DungeonTileMap"
            static let grassTileMap = "GrassTileMap"
        }
    }
}
