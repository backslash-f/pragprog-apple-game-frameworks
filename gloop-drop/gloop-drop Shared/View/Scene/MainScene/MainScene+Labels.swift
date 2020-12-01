//
//  MainScene+Labels.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 19.11.20.
//

import SpriteKit

extension MainScene {

    // MARK: - Labels

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
        let label = SKLabelNode(fontNamed: Constant.Font.Nosifer.name)
        label.fontColor = .yellow
        label.fontSize = Constant.Font.Nosifer.size
        label.verticalAlignmentMode = .center
        label.zPosition = Layer.interface.rawValue
        return label
    }

    // MARK: - Messages

    func showMessage(_ message: String) {
        let messageLabel = baseLabel()
        messageLabel.name = Constant.Label.Message.name
        messageLabel.position = CGPoint(x: frame.midX, y: blobPlayer.frame.maxY + 100)
        messageLabel.numberOfLines = 2
        messageLabel.attributedText = NSAttributedString(
            string: message,
            attributes: createMessageAttributes()
        )

        let fadeInAction = SKAction.fadeIn(withDuration: 0.25)
        messageLabel.run(fadeInAction)
        addChild(messageLabel)
    }

    func hideMessage() {
        if let messageLabel = childNode(withName: Constant.Label.Message.name) as? SKLabelNode {
            let fadeOutAction = SKAction.fadeOut(withDuration: 0.25)
            let removeFromParentAction = SKAction.removeFromParent()
            let removeSequenceAction = SKAction.sequence([
                fadeOutAction,
                removeFromParentAction
            ])
            messageLabel.run(removeSequenceAction)
        }
    }
}

// MARK: - Private

fileprivate extension MainScene {

    func createMessageAttributes() -> [NSAttributedString.Key: Any] {
        let color = SKColor(
            red: 251.0/255.0,
            green: 155.0/255.0,
            blue: 24.0/255.0,
            alpha: 1.0
        )

        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center

        var attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .paragraphStyle: paragraph,
            .backgroundColor: SKColor.clear
        ]

        // Handle the font attribute.
        let fontName = Constant.Font.Nosifer.name
        let fontSize: CGFloat = 45
        #if os(iOS) || os(tvOS)
        if let font = UIFont(name: fontName, size: fontSize) {
            attributes.updateValue(font, forKey: .font)
        }
        #elseif os(OSX)
        if let font = NSFont(name: fontName, size: fontSize) {
            attributes.updateValue(font, forKey: .font)
        }
        #endif

        return attributes
    }
}
