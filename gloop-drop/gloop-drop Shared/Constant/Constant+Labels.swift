//
//  Constant+Labels.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 19.11.20.
//

import SwiftUI

extension Constant {

    struct Label {

        struct Score {
            static let name = "score"
            static let text = "Score: "
        }

        struct Level {
            static let name = "level"
            static let text = "Level: "
        }

        struct Message {
            static let name = "message"
            static let tapToStart = "Tap to start game"
            static let getReady = "Get Ready!"
            static let gameOver = "Game Over\nTap to try again"
        }
    }
}
