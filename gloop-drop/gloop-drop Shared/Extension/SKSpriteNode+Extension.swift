//
//  SKSpriteNode+Extension.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 23.09.20.
//

import Foundation
import SpriteKit

extension SKSpriteNode {

    /// Loads texture arrays for animations via `SKTextureAtlas.preloadTextureAtlasesNamed(_:withCompletionHandler:)`.
    func loadTextures(atlasName: String, prefix: String, completion: @escaping ([SKTexture]) -> Void) {
        
        SKTextureAtlas.preloadTextureAtlasesNamed([atlasName]) { error, characterAtlas in
            guard let characterAtlasArray = characterAtlas.first else {
                let error = String(describing: error)
                let errorMessage = "One or more texture atlases could not be found. Error: \(error)"
                GloopDropApp.logError(errorMessage)
                fatalError(errorMessage)
            }
            let textures = characterAtlasArray.textureNames.filter {
                $0.hasPrefix(prefix)
            }.sorted {
                $0 < $1
            }.map {
                characterAtlasArray.textureNamed($0)
            }
            completion(textures)
        }
    }
}
