//
//  GloopDropScene.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 18.09.20.
//

import SpriteKit

/// A `SKScene` subclass that has default debug settings that can be customized.
class GloopDropScene: SKScene {

    // MARK: - Properties

    struct DebugSettings {
        let showFPS: Bool = true
        let showsFields: Bool = true
        let showsPhysics: Bool = true
        let showsDrawCount: Bool = true
        let showsNodeCount: Bool = true
        let showsQuadCount: Bool = true
    }
    let debugSettings: DebugSettings

    // MARK: - Lifecycle

    init(size: CGSize, debugSettings: DebugSettings = DebugSettings()) {
        self.debugSettings = debugSettings
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        self.debugSettings = DebugSettings()
        super.init(coder: aDecoder)
    }
}

// MARK: - SpriteKit

extension GloopDropScene {

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupDebugSettings()
    }
}

// MARK: - Private

private extension GloopDropScene {

    func setupDebugSettings() {
        #if DEBUG
        view?.showsFPS = debugSettings.showFPS
        view?.showsFields = debugSettings.showsFields
        view?.showsPhysics = debugSettings.showsPhysics
        view?.showsDrawCount = debugSettings.showsDrawCount
        view?.showsNodeCount = debugSettings.showsNodeCount
        view?.showsQuadCount = debugSettings.showsQuadCount
        #endif
    }
}
