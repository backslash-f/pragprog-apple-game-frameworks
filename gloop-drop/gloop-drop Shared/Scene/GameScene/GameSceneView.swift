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
            SpriteView(scene: makeScene(size: geometry.size))
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

struct Level001View_Previews: PreviewProvider {
    static var previews: some View {
        GameSceneView()
    }
}
