//
//  SKTexture+LoadTextures.swift
//  hog
//
//  Created by Tammy Coron on 7/4/20.
//  Copyright © 2020 Just Write Code LLC. All rights reserved.
//

import SpriteKit

extension SKTexture {
  static func loadTextures(atlas: String, prefix: String,
                           startsAt: Int, stopsAt: Int) -> [SKTexture] {
    
    var textureArray = [SKTexture]()
    let textureAtlas = SKTextureAtlas(named: atlas)
    for i in startsAt...stopsAt {
      let textureName = "\(prefix)\(i)"
      let temp = textureAtlas.textureNamed(textureName)
      textureArray.append(temp)
    }
    
    return textureArray
  }
}
