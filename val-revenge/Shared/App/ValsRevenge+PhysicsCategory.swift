//
//  ValsRevenge+PhysicsCategory.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 18.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import SwiftUI

struct PhysicsCategory: OptionSet {
    let rawValue: UInt32
    static let none             = PhysicsCategory(rawValue: 1 << 0)
    static let playerAndWall    = PhysicsCategory(rawValue: 1 << 1)
}
