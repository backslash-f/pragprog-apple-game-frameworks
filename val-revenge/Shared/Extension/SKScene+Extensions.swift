//
//  SKScene+Extensions.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 17.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import SpriteKit

extension SKScene {

    /// Converts the "top view coordinate" to a "top scene coordinator" and returns it.
    var viewTop: CGFloat {
        guard let skView = view else {
            return .zero
        }
        return convertPoint(fromView: topView(in: skView)).y
    }

    /// Converts the "left view coordinate" to a "bottom scene coordinator" and returns it.
    var viewLeft: CGFloat {
        convertPoint(fromView: .zero).x
    }

    /// Converts the "right view coordinate" to a "bottom scene coordinator" and returns it.
    var viewRight: CGFloat {
        guard let view = view else {
            return .zero
        }
        let point = CGPoint(x: view.bounds.size.width, y: .zero)
        return convertPoint(fromView: point).x
    }

    /// Converts the "bottom view coordinate" to a "bottom scene coordinator" and returns it.
    var viewBottom: CGFloat {
        guard let skView = view else {
            return .zero
        }
        return convertPoint(fromView: bottomView(in: skView)).y
    }

    #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
    var insets: UIEdgeInsets {
        UIApplication.shared.delegate?.window??.safeAreaInsets ?? .zero
    }
    #endif
}

// MARK: - Private

private extension SKScene {

    // MARK: Coordinate System

    /*
     macOS uses a different coordinate systems. These functions handle that.
     */

    func topView(in skView: SKView) -> CGPoint {
        let topY: CGPoint
        #if os(iOS) || os(tvOS) || os(watchOS)
        topY = .zero
        #elseif os(OSX)
        topY = CGPoint(x: .zero, y: skView.bounds.size.height)
        #endif
        return topY
    }

    func bottomView(in skView: SKView) -> CGPoint {
        let bottomY: CGPoint
        #if os(iOS) || os(tvOS) || os(watchOS)
        bottomY = CGPoint(x: .zero, y: skView.bounds.size.height)
        #elseif os(OSX)
        bottomY = .zero
        #endif
        return bottomY
    }
}
