//
//  CGFloat+Extensions.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 18.01.21.
//  Copyright © 2021 backslash-f. All rights reserved.
//

import CoreGraphics

// swiftlint:disable identifier_name
extension CGFloat {

    func clamped(v1: CGFloat, v2: CGFloat) -> CGFloat {
        let min = v1 < v2 ? v1 : v2
        let max = v1 > v2 ? v1 : v2

        return self < min ? min : (self > max ? max : self)
    }

    func clamped(to r: ClosedRange<CGFloat>) -> CGFloat {
        let min = r.lowerBound, max = r.upperBound
        return self < min ? min : (self > max ? max : self)
    }
}
