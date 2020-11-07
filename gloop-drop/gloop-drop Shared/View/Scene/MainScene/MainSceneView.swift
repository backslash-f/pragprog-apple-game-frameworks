//
//  MainSceneView.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 18.09.20.
//

import SwiftUI
import SpriteKit

struct MainSceneView: View {

    // MARK: - Properties

    var body: some View {
        let size = CGSize(width: 1336, height: 1024)
        SpriteView(scene: makeScene(size: size))
    }
}

// MARK: - Private

fileprivate extension MainSceneView {

    func makeScene(size: CGSize) -> SKScene {
        MainScene(size: size)
    }
}

// MARK: - Preview

struct MainSceneView_Previews: PreviewProvider {
    static var previews: some View {
        MainSceneView()
    }
}
