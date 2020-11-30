//
//  MainScene.swift
//  gloop-drop Shared
//
//  Created by Fernando Fernandes on 16.09.20.
//

import SwiftUI
import SpriteKit
import AVFoundation

class MainScene: GloopDropScene {

    // MARK: - Internal Properties

    internal let blobPlayer = BlobPlayer()
    internal var isGameInProgress = false
    internal let musicAudioNode = SKAudioNode(fileNamed: Constant.Sound.music)

    // MARK: Labels

    internal lazy var levelLabel = baseLabel()
    internal lazy var scoreLabel = baseLabel()

    // MARK: Level Data

    var level: Int = 1 {
        didSet {
            levelLabel.text = "\(Constant.Label.Level.text)\(level)"
        }
    }

    var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(Constant.Label.Score.text)\(score)"
        }
    }

    internal var numberOfDrops: Int = 10
    internal var dropSpeed: CGFloat = 1.0
    internal var minDropSpeed: CGFloat = 0.12 // Fastest drop.
    internal var maxDropSpeed: CGFloat = 1.0 // Slowest drop.

    // MARK: Level Progression

    internal var dropsExpected = 10
    internal var dropsCollected = 0

    // MARK: Controller Input

    internal var isLeftPressed: Bool = false
    internal var isRightPressed: Bool = false
    internal var isXButtonPressed: Bool = false

    // MARK: - Lifecycle

    init(size: CGSize) {
        let debugSettings = DebugSettings(disableAll: true)
        super.init(size: size, debugSettings: debugSettings)
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
        setupMusic()
        setupPhysicsWorld()
        setupBackgroundColor()
        setupBackgroundImage()
        setupForegroundImage()
        setupGloopFlow()
        setupPlayer()
        showMessage(Constant.Label.Message.tapToStart)
    }

    override func update(_ currentTime: TimeInterval) {
        // Calling "setupLabels()" from "MainScene.didMove(to:)" won't work because "view" is
        // still "nil" there. Perhaps it's because I'm using SwiftUI, which may have a different
        // lifecycle. Anyway, calling it here does the trick. If labels are already added, the
        // function will just return.
        setupLabels()
        pollControllerInput()
    }
}

// MARK: - Internal

internal extension MainScene {

    func startGame() {
        guard !isGameInProgress else {
            return
        }
        GloopDropApp.log("The game is about to start.", category: .gameLoop)
        score = 0
        level = 1
        isGameInProgress = true
        blobPlayer.startWalkAnimation()
        spawnMultipleGloops()
    }

    func stopGame() {
        GloopDropApp.log("The game is about to stop.", category: .gameLoop)
        blobPlayer.startDieAnimation()
        isGameInProgress = false
    }
}

// MARK: - Private

fileprivate extension MainScene {

    // MARK: Setup

    func setupScene() {
        view?.ignoresSiblingOrder = false
        scaleMode = .aspectFill
    }

    func setupMusic() {
        // Decrease the audio engine's volume.
        audioEngine.mainMixerNode.outputVolume = 0.0
        // Use an action to adjust the audio node's volume to 0.
        musicAudioNode.run(SKAction.changeVolume(to: 0.0, duration: 0.0))

        musicAudioNode.autoplayLooped = true
        musicAudioNode.isPositional = false
        addChild(musicAudioNode)

        // Run a delayed action on the scene that fades-in the music.
        run(SKAction.wait(forDuration: 1.0), completion: { [weak self] in
            self?.audioEngine.mainMixerNode.outputVolume = 1.0
            self?.musicAudioNode.run(SKAction.changeVolume(to: 0.75, duration: 2.0))
        })
    }

    func setupPhysicsWorld() {
        physicsWorld.contactDelegate = self
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

        // Add physics body.
        foreground.physicsBody = SKPhysicsBody(edgeLoopFrom: foreground.frame)
        foreground.physicsBody?.affectedByGravity = false

        // Set up physics categories.
        foreground.physicsBody?.categoryBitMask = PhysicsCategory.floor.rawValue
        foreground.physicsBody?.contactTestBitMask = PhysicsCategory.collectible.rawValue
        foreground.physicsBody?.collisionBitMask = PhysicsCategory.none.rawValue

        addChild(foreground)
    }

    func setupGloopFlow() {
        let gloopFlowNode = SKNode()
        gloopFlowNode.name = Constant.Node.GloopFlow.name
        gloopFlowNode.zPosition = Layer.foreground.rawValue
        gloopFlowNode.position = CGPoint(x: 0.0, y: -60)

        gloopFlowNode.setupScrollingView(
            imageNamed: Constant.Node.GloopFlow.imageName,
            layer: Layer.foreground,
            blocks: 3, speed: 30.0
        )

        addChild(gloopFlowNode)
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
