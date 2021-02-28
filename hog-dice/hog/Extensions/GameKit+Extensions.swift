//
//  GameKit+Extensions.swift
//  hog
//
//  Created by Fernando Fernandes on 28.02.21.
//

import GameKit

extension GKTurnBasedMatch {

    var localPlayer: GKTurnBasedParticipant? {
        participants.filter({ $0.player == GKLocalPlayer.local }).first
    }

    var opponents: [GKTurnBasedParticipant] {
        participants.filter {
            $0.player != GKLocalPlayer.local
        }
    }
}
