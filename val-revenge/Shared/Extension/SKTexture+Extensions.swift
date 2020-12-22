//
//  SKTexture+Extensions.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 22.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import SpriteKit

extension SKTexture {

    static func loadTextures(atlas: String, prefix: String, startsAt: Int, stopsAt: Int) -> [SKTexture] {
        var textureArray = [SKTexture]()
        let textureAtlas = SKTextureAtlas(named: atlas)
        for index in startsAt...stopsAt {
            let textureName = "\(prefix)\(index)"
            let temp = textureAtlas.textureNamed(textureName)
            textureArray.append(temp)
        }
        return textureArray
    }
}
