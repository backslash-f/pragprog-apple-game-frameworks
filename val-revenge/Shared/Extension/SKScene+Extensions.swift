//
//  SKScene+Extensions.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 17.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import SpriteKit

extension SKScene {

    var viewTop: CGFloat {
        convertPoint(fromView: .zero).y
    }

    var viewLeft: CGFloat {
        convertPoint(fromView: .zero).x
    }

    var viewRight: CGFloat {
        guard let view = view else {
            return .zero
        }
        let point = CGPoint(x: view.bounds.size.width, y: .zero)
        return convertPoint(fromView: point).x
    }

    var viewBottom: CGFloat {
        guard let view = view else {
            return .zero
        }
        let point = CGPoint(x: .zero, y: view.bounds.size.height)
        return convertPoint(fromView: point).y
    }

    #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
    var insets: UIEdgeInsets {
        UIApplication.shared.delegate?.window??.safeAreaInsets ?? .zero
    }
    #endif
}
