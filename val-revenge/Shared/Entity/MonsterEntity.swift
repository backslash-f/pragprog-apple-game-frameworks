//
//  MonsterEntity.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 22.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import SpriteKit
import GameplayKit

class MonsterEntity: GKEntity {

    // MARK: - Lifecycle

    init(monsterType: String) {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
