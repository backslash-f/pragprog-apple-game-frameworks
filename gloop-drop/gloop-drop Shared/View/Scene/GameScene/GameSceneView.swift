//
//  GameSceneView.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 18.09.20.
//

import SwiftUI
import SpriteKit

struct GameSceneView: View {

    // MARK: - Properties

    var body: some View {
        GeometryReader { geometry in
            let size = CGSize(width: 1336, height: 1024)
            SpriteView(scene: makeScene(size: size))
        }
    }
}

// MARK: - Private

private extension GameSceneView {

    func makeScene(size: CGSize) -> SKScene {
        ​GameScene​(size: size)
    }
}

// MARK: - Preview

struct GameSceneView_Previews: PreviewProvider {
    static var previews: some View {
        GameSceneView()
    }
}
