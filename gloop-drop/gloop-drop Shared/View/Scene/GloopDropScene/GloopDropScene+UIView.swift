//
//  GloopDropScene+View.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 18.11.20.
//

import SpriteKit

extension GloopDropScene {

    // Converts a "top view coordinate" to a "top scene coordinator" and returns it.
    func viewTop() -> CGFloat {
        guard let skView = view else {
            return .zero
        }
        return convertPoint(fromView: topView(in: skView)).y
    }

    // Converts a "bottom view coordinate" to a "bottom scene coordinator" and returns it.
    func viewBottom() -> CGFloat {
        guard let skView = view else {
            return .zero
        }

        return convertPoint(fromView: bottomView(in: skView)).y
    }
}

// MARK: - Private

private extension GloopDropScene {

    // MARK: Coordinate System

    /*
     macOS uses a different coordinate systems. These functions handle that.
     */

    func topView(in skView: SKView) -> CGPoint {
        let topY: CGPoint
        #if os(iOS) || os(tvOS)
        topY = .zero
        #elseif os(OSX)
        topY = CGPoint(x: .zero, y: skView.bounds.size.height)
        #endif
        return topY
    }

    func bottomView(in skView: SKView) -> CGPoint {
        let bottomY: CGPoint
        #if os(iOS) || os(tvOS)
        bottomY = CGPoint(x: .zero, y: skView.bounds.size.height)
        #elseif os(OSX)
        bottomY = .zero
        #endif
        return bottomY
    }
}
