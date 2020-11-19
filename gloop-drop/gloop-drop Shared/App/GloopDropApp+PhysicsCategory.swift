//
//  GloopDropApp+PhysicsCategory.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 16.11.20.
//

import SwiftUI

struct PhysicsCategory: OptionSet {
    let rawValue: UInt32
    static let none         = PhysicsCategory(rawValue: 1 << 0)
    static let player       = PhysicsCategory(rawValue: 1 << 1)
    static let collectible  = PhysicsCategory(rawValue: 1 << 2)
    static let floor        = PhysicsCategory(rawValue: 1 << 3)
}
