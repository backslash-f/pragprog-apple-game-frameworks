//
//  GloopDropScene.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 18.09.20.
//

import SpriteKit
import Combine
import GCOverseer

/// A `SKScene` subclass that has default debug settings that can be customized.
class GloopDropScene: SKScene {

    // MARK: - Properties

    struct DebugSettings {
        let disableAll: Bool
        let showsFPS: Bool
        let showsFields: Bool
        let showsPhysics: Bool
        let showsDrawCount: Bool
        let showsNodeCount: Bool
        let showsQuadCount: Bool

        /// By default, all debugging options are shown (`true`) in `DEBUG` mode.
        /// To disable all of them at once, set `disableAll` to `true`
        init(disableAll: Bool = false, showsFPS: Bool = true, showsFields: Bool = true,
             showsPhysics: Bool = true, showsDrawCount: Bool = true, showsNodeCount: Bool = true,
             showsQuadCount: Bool = true) {
            self.disableAll     = disableAll
            self.showsFPS       = disableAll ? false : showsFPS
            self.showsFields    = disableAll ? false : showsFields
            self.showsPhysics   = disableAll ? false : showsPhysics
            self.showsDrawCount = disableAll ? false : showsDrawCount
            self.showsNodeCount = disableAll ? false : showsNodeCount
            self.showsQuadCount = disableAll ? false : showsQuadCount
        }
    }

    let debugSettings: DebugSettings

    let gcOverseer = GCOverseer()

    var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle

    init(size: CGSize, debugSettings: DebugSettings = DebugSettings()) {
        self.debugSettings = debugSettings
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        let errorMessage = "init(coder:) has not been implemented"
        GloopDropApp.logError(errorMessage)
        fatalError(errorMessage)
    }
}

// MARK: - SpriteKit

extension GloopDropScene {

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupDebugSettings()
        logInformation()
    }
}

// MARK: - Private

private extension GloopDropScene {

    func setupDebugSettings() {
        #if DEBUG
        view?.showsFPS          = debugSettings.showsFPS
        view?.showsFields       = debugSettings.showsFields
        view?.showsPhysics      = debugSettings.showsPhysics
        view?.showsDrawCount    = debugSettings.showsDrawCount
        view?.showsNodeCount    = debugSettings.showsNodeCount
        view?.showsQuadCount    = debugSettings.showsQuadCount
        #endif
    }

    func logInformation() {
        GloopDropApp.log("Scene size: \(size)", category: .scene)
    }
}
