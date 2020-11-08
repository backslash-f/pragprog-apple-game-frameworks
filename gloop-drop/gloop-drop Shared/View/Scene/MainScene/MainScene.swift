//
//  MainScene.swift
//  gloop-drop Shared
//
//  Created by Fernando Fernandes on 16.09.20.
//

import SwiftUI
import SpriteKit

class MainScene: GloopDropScene {

    // MARK: - Internal Properties

    internal let blobPlayer = BlobPlayer()

    // MARK: Level Data

    internal var level: Int = 8
    internal var numberOfDrops: Int = 10
    internal var dropSpeed: CGFloat = 1.0
    internal var minDropSpeed: CGFloat = 0.12 // Fastest drop.
    internal var maxDropSpeed: CGFloat = 1.0 // Slowest drop.

    // MARK: Controller Input

    internal var isLeftPressed: Bool = false
    internal var isRightPressed: Bool = false

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

extension MainScene {

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupBackgroundColor()
        setupBackgroundImage()
        setupForegroundImage()
        setupPlayer()
        spawnMultipleGloops()
    }

    override func update(_ currentTime: TimeInterval) {
        pollControllerInput()
    }
}

// MARK: - Private

fileprivate extension MainScene {

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
                if isConnected {
                    self?.setupControllers()
                }
            }
            .store(in: &cancellables)
    }
}
