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
    }
}

// MARK: - Private

private extension ​GameScene​ {

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
        let background = SKSpriteNode(imageNamed: "background_1")
        background.anchorPoint = .zero
        addChild(background)
    }

    func setupForeground() {
        let foreground = SKSpriteNode(imageNamed: "foreground_1")
        foreground.anchorPoint = .zero
        foreground.position = CGPoint(x: 0, y: 0)
        addChild(foreground)
    }
}
