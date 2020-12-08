//
//  MainScene.swift
//  valsrevenge
//
//  Created by Fernando Fernandes on 07.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import CSKScene
import SpriteKit

class MainScene: CSKScene {

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

// MARK: - Private

private extension MainScene {

    func setupScene() {
        scaleMode = .aspectFill
    }
}
