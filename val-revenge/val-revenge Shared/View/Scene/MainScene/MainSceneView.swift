//
//  MainSceneView.swift
//  valsrevenge
//
//  Created by Fernando Fernandes on 07.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import SwiftUI
import SpriteKit

struct MainSceneView: View {

    // MARK: - Properties

    var body: some View {
        SpriteView(scene: makeScene())
    }
}

// MARK: - Private

fileprivate extension MainSceneView {

    func makeScene() -> SKScene {
        MainScene(fileNamed: Constant.Scene.MainScene)!
    }
}

// MARK: - Preview

struct MainSceneView_Previews: PreviewProvider {
    static var previews: some View {
        MainSceneView()
    }
}
