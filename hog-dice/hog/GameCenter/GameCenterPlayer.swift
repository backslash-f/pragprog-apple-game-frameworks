//
//  GameCenterPlayer.swift
//  hog
//
//  Created by Fernando Fernandes on 28.02.21.
//

class GameCenterPlayer: Codable, Equatable {

    var playerId: String
    var playerName: String

    var isLocalPlayer: Bool = false
    var isWinner: Bool = false

    var totalPoints: Int = 0

    // protocol required for `Equatable`
    static func == (lhs: GameCenterPlayer, rhs: GameCenterPlayer) -> Bool {
        lhs.playerId == rhs.playerId && lhs.playerName == rhs.playerName
    }

    init(playerId: String, playerName: String) {
        self.playerId = playerId
        self.playerName = playerName
    }
}
