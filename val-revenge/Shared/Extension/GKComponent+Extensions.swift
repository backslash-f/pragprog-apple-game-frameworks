//
//  GKComponent+Extensions.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 22.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GKComponent {

    var componentNode: SKNode {
        if let node = entity?.component(ofType: GKSKNodeComponent.self)?.node {
            return node
        } else if let node = entity?.component(ofType: RenderComponent.self)?.spriteNode {
            return node
        }
        return SKNode()
    }
}
