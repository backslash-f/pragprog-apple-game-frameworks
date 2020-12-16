//
//  MainSceneView.swift
//  valsrevenge
//
//  Created by Fernando Fernandes on 07.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import SwiftUI
import SpriteKit
import GameplayKit

struct MainSceneView: View {

    // MARK: - Properties

    var body: some View {
        SpriteView(scene: makeScene())
    }
}

// MARK: - Private

private extension MainSceneView {

    func makeScene() -> SKScene {

        // Load 'MainScene.sks' as a GKScene. This provides gameplay related content including entities and graphs.
        guard let gkScene = GKScene(fileNamed: Constant.Scene.MainScene.name) else {
            let errorMessage = "Could not load \"MainScene.sks\" as \"GKScene\""
            ValsRevenge.logError(errorMessage)
            fatalError(errorMessage)
        }

        // Load 'MainScene.sks' as a GKScene. This provides gameplay related content including entities and graphs.
        guard let mainScene = gkScene.rootNode as? MainScene else {
            let errorMessage = "Could not load \"MainScene\" as GKScene's root node"
            ValsRevenge.logError(errorMessage)
            fatalError(errorMessage)
        }

        // Copy gameplay related content over to the scene.
        mainScene.entities = gkScene.entities
        mainScene.graphs = gkScene.graphs

        return mainScene
    }
}

// MARK: - Preview

struct MainSceneView_Previews: PreviewProvider {
    static var previews: some View {
        MainSceneView()
    }
}
