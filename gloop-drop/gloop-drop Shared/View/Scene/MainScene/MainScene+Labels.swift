//
//  MainScene+Labels.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 19.11.20.
//

import SpriteKit

extension MainScene {

    func setupLabels() {
        setupLevelLabel()
        setupScoreLabel()
    }

    func setupLevelLabel() {
        let levelLabelName = Constant.Label.Level.name
        guard scene?.childNode(withName: levelLabelName) == nil else {
            // Avoid re-adding the same label over and over again.
            return
        }
        levelLabel.name = levelLabelName
        levelLabel.horizontalAlignmentMode = .left
        levelLabel.position = CGPoint(x: frame.minX + 50, y: viewTop() - 100)
        levelLabel.text = "\(Constant.Label.Level.text)\(level)"
        addChild(levelLabel)
    }

    func setupScoreLabel() {
        let scoreLabelName = Constant.Label.Score.name
        guard scene?.childNode(withName: scoreLabelName) == nil else {
            // Avoid re-adding the same label over and over again.
            return
        }
        let initialScore = 0
        scoreLabel.name = scoreLabelName
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: frame.maxX - 50, y: viewTop() - 100)
        scoreLabel.text = "\(Constant.Label.Score.text)\(initialScore)"
        addChild(scoreLabel)
    }

    /// Creates a base `SKLabelNode` with common attributes.
    func baseLabel() -> SKLabelNode {
        let label = SKLabelNode(fontNamed: Constant.Font.nosifer)
        label.fontColor = .yellow
        label.fontSize = Constant.Font.size
        label.verticalAlignmentMode = .center
        label.zPosition = Layer.interface.rawValue
        return label
    }
}
