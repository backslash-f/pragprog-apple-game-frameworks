//
//  GameScene.swift
//  gloop-drop Shared
//
//  Created by Fernando Fernandes on 16.09.20.
//

import SpriteKit

class ​GameScene​: GloopDropScene {

    // MARK: - Lifecycle

    init(size: CGSize) {
        super.init(size: size)
        initialSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
}

// MARK: - SpriteKit

extension ​GameScene​ {

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupBackground()
        setupForeground()
        setupPlayer()
    }
}

// MARK: - Private

private extension ​GameScene​ {

    // MARK: Setup

    func initialSetup() {
        view?.ignoresSiblingOrder = false
        scaleMode = .aspectFill
        backgroundColor = UIColor(
            red: 105/255,
            green: 157/255,
            blue: 181/255,
            alpha: 1.0
        )
    }

    func setupBackground() {
        let backgroundName = Constant.Scenario.firstBackground
        let background = SKSpriteNode(imageNamed: backgroundName)
        background.name = backgroundName
        background.anchorPoint = .zero
        background.zPosition = Layer.background.rawValue
        addChild(background)
    }

    func setupForeground() {
        let foregroundName = Constant.Scenario.firstForeground
        let foreground = SKSpriteNode(imageNamed: foregroundName)
        foreground.name = foregroundName
        foreground.anchorPoint = .zero
        foreground.position = .zero
        foreground.zPosition = Layer.foreground.rawValue
        addChild(foreground)
    }

    func setupPlayer() {
        let blobPlayer = BlobPlayer()
        let foreground = childNode(withName: Constant.Scenario.firstForeground)
        blobPlayer.position = CGPoint(x: size.width/2, y: foreground?.frame.maxY ?? size.height/2)
        addChild(blobPlayer)
    }
}
