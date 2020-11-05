//
//  GameScene.swift
//  gloop-drop Shared
//
//  Created by Fernando Fernandes on 16.09.20.
//

import SwiftUI
import SpriteKit

class ​GameScene​: GloopDropScene {

    // MARK: - Properties

    let blobPlayer = BlobPlayer()

    // MARK: - Internal Properties

    // MARK: Controller Input

    var isLeftPressed: Bool = false
    var isRightPressed: Bool = false

    // MARK: - Lifecycle

    init(size: CGSize) {
        super.init(size: size)
        setupScene()
        setupGameControllerListener()
    }

    required init?(coder aDecoder: NSCoder) {
        let errorMessage = "init(coder:) has not been implemented"
        GloopDropApp.logError(errorMessage)
        fatalError(errorMessage)
    }
}

// MARK: - SpriteKit

extension ​GameScene​ {

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupBackgroundColor()
        setupBackgroundImage()
        setupForegroundImage()
        setupPlayer()
        spawnGloop()
    }

    override func update(_ currentTime: TimeInterval) {
        pollControllerInput()
    }
}

// MARK: - Private

fileprivate extension ​GameScene​ {

    // MARK: Setup

    func setupScene() {
        view?.ignoresSiblingOrder = false
        scaleMode = .aspectFill
    }

    func setupBackgroundColor() {
        // By using SwiftUI, Color and finally SKColor, the three
        // target platforms can be supported: iOS, macOS and tvOS.
        let color = Color(
            red: 105/255,
            green: 157/255,
            blue: 181/255,
            opacity: 1.0
        )
        backgroundColor = SKColor(color)
    }

    func setupBackgroundImage() {
        let backgroundName = Constant.Scenario.firstBackground
        let background = SKSpriteNode(imageNamed: backgroundName)
        background.name = backgroundName
        background.anchorPoint = .zero
        background.zPosition = Layer.background.rawValue
        addChild(background)
    }

    func setupForegroundImage() {
        let foregroundName = Constant.Scenario.firstForeground
        let foreground = SKSpriteNode(imageNamed: foregroundName)
        foreground.name = foregroundName
        foreground.anchorPoint = .zero
        foreground.position = .zero
        foreground.zPosition = Layer.foreground.rawValue
        addChild(foreground)
    }

    func setupPlayer() {
        guard let foreground = childNode(withName: Constant.Scenario.firstForeground) else {
            let errorMessage = "Couldn't find the foreground node"
            GloopDropApp.logError(errorMessage)
            preconditionFailure(errorMessage)
        }

        blobPlayer.position = CGPoint(x: size.width/2, y: foreground.frame.maxY)
        blobPlayer.constrainPositionY(lowerAndUpperLimit: foreground.frame.maxY)
        addChild(blobPlayer)
    }

    func setupGameControllerListener() {
        gcOverseer.$isGameControllerConnected
            .sink { [weak self] isConnected in
                self?.setupControllers()
            }
            .store(in: &cancellables)
    }
}
