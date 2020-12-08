//
//  MainScene.swift
//  valsrevenge
//
//  Created by Fernando Fernandes on 07.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import CSKScene
import SpriteKit
import GameplayKit

class MainScene: CSKScene {

    // MARK: - Properties

    // MARK: GameplayKit

    var entities = [GKEntity]()
    var graphs = [String: GKGraph]()

    // MARK: Internal Properties

    internal var player: Player?

    // MARK: Private Properties

    private var lastUpdateTime: TimeInterval = .zero

    // MARK: - Lifecycle

    override init(size: CGSize, debugSettings: DebugSettings = DebugSettings()) {
        super.init(size: size, debugSettings: debugSettings)
        setupScene()
    }

    override init() {
        super.init()
        setupScene()
    }

    override init(size: CGSize) {
        super.init(size: size)
        setupScene()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupScene()
    }
}

// MARK: - SpriteKit

extension MainScene {

    override func update(_ currentTime: TimeInterval) {
        updateEntitiesDeltaTime(with: currentTime)
        player?.updatePosition()
        player?.updateAction()
    }

    override func didMove(to view: SKView) {
        setupPlayer()
        super.didMove(to: view)
    }
}

// MARK: - Private

private extension MainScene {

    func setupScene() {
        view?.ignoresSiblingOrder = true
        scaleMode = .aspectFill
    }

    func setupPlayer() {
        player = childNode(withName: Constant.Node.Player.name) as? Player
    }

    func updateEntitiesDeltaTime(with currentTime: TimeInterval) {
        // Calculate time since last update.
        let deltaTime: TimeInterval
        if lastUpdateTime > .zero {
            deltaTime = currentTime - lastUpdateTime
        } else {
            deltaTime = .zero
        }
        entities.forEach { $0.update(deltaTime: deltaTime) }
        lastUpdateTime = currentTime
    }
}
