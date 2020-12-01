//
//  Constant+Labels.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 19.11.20.
//

extension Constant {

    struct Label {

        struct Chomp {
            static let name = "chomp"
            static let text = "gloop"
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

        struct Score {
            static let name = "score"
            static let text = "Score: "
        }
    }
}
