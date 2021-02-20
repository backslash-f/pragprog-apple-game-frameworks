//
//  MenuScene.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 20.02.21.
//  Copyright © 2021 backslash-f. All rights reserved.
//

import CSKScene
import SpriteKit

/// A type of scene that presents menus instead of actual gameplay.
///
/// E.g.: `TitleScene`, `GameOverScene`.
class MenuScene: CSKScene {

    // MARK: - Lifecycle

    override init(size: CGSize, debugSettings: DebugSettings = DebugSettings()) {
        super.init(size: size, debugSettings: debugSettings)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

// MARK: - Private

private extension MenuScene {

    // MARK: - Setup

    func setup() {
        scaleMode = .aspectFill
        setupGameControllerListener()
    }
}
