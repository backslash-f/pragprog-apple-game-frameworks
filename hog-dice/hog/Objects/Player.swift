//
//  Player.swift
//  hog
//
//  Created by Tammy Coron on 10/31/2020.
//  Copyright © 2020 Just Write Code LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class Player {

    // MARK: - PROPERTIES

    var isHuman: Bool = false
    var mainStateMachine: GKStateMachine!

    var totalPoints: Int = 0 {
        didSet {
            tPointsLabel?.text = "\(totalPoints)"
        }
    }

    var pointsThisRound: Int = 0 {
        didSet {
            rPointsLabel?.text = "\(pointsThisRound)"
        }
    }

    var totalRolls: Int = 0
    var rollsThisRound: Int = 0

    weak var scorecard: SKSpriteNode?

    lazy var tPointsLabel: SKLabelNode? = {
        scorecard?.childNode(withName: "totalPoints") as? SKLabelNode
    }()

    lazy var rPointsLabel: SKLabelNode? = {
        scorecard?.childNode(withName: "roundPoints") as? SKLabelNode
    }()

    lazy var turnIndicator: SKSpriteNode? = {
        scorecard?.childNode(withName: "turnIndicator") as? SKSpriteNode
    }()

    // MARK: - METHODS

    init(isHuman: Bool = false) {
        self.isHuman = isHuman
        self.mainStateMachine =
            GKStateMachine(states: [WaitingForTurn(player: self),
                                    TurnInProgress(player: self),
                                    RollInProgress(player: self)])
    }

    func beginTurn() {
        turnIndicator?.alpha = 1
    }

    func rolled(_ number: Int) {
        mainStateMachine.enter(TurnInProgress.self)
    }

    func endTurn() {
        turnIndicator?.alpha = 0
    }
}
