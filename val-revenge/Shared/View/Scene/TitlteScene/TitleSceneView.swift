//
//  TitleSceneView.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 15.02.21.
//  Copyright © 2021 backslash-f. All rights reserved.
//

import SwiftUI
import SpriteKit
import GameplayKit

struct TitleSceneView: View {

    // MARK: - Properties

    var body: some View {
        SpriteView(scene: makeScene())
    }
}

// MARK: - Private

private extension TitleSceneView {

    func makeScene() -> SKScene {

        // Load 'TitleScene.sks' as a GKScene.
        guard let gkScene = GKScene(fileNamed: Constant.Scene.TitleScene.name) else {
            let errorMessage = "Could not load \"TitleScene.sks\" as \"GKScene\""
            ValsRevenge.logError(errorMessage)
            fatalError(errorMessage)
        }

        // Load 'gkScene' as a TitleScene.
        guard let titleScene = gkScene.rootNode as? TitleScene else {
            let errorMessage = "Could not load \"TitleScene\" as GKScene's root node"
            ValsRevenge.logError(errorMessage)
            fatalError(errorMessage)
        }

        return titleScene
    }
}

// MARK: - Preview

struct TitleSceneView_Previews: PreviewProvider {
    static var previews: some View {
        TitleSceneView()
    }
}
