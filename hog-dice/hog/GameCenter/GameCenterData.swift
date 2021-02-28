//
//  GameCenterData.swift
//  hog
//
//  Created by Fernando Fernandes on 28.02.21.
//

class GameCenterData: Codable {
    var players: [GameCenterPlayer] = []

    func addPlayer(_ player: GameCenterPlayer) {
        if let p = getPlayer(withName: player.playerName) {
            p.isLocalPlayer = player.isLocalPlayer
            p.isWinner = player.isWinner
        } else {
            
            players.append(player)
        }
    }

    func getLocalPlayer() -> GameCenterPlayer? {
        return players.filter({ $0.isLocalPlayer == true}).first
    }

    func getRemotePlayer() -> GameCenterPlayer? {
        return players.filter({ $0.isLocalPlayer == false}).first
    }

    func getPlayer(withName playerName: String) -> GameCenterPlayer? {
        return players.first(where: {$0.playerName == playerName})
    }

    func getPlayerIndex(for player: GameCenterPlayer) -> Int? {
        return players.firstIndex(of: player)
    }
}
