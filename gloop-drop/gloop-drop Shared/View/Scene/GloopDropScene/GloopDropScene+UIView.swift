//
//  GloopDropScene+View.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 18.11.20.
//

import SwiftUI

extension GloopDropScene {

    // Converts a "top view coordinate" to a "top scene coordinator" and returns it.
    func viewTop() -> CGFloat {
        let topView = CGPoint.zero
        return convertPoint(fromView: topView).y
    }

    // Converts a "bottom view coordinate" to a "bottom scene coordinator" and returns it.
    func viewBottom() -> CGFloat {
        guard let view = view else {
            return .zero
        }
        let bottomView = CGPoint(x: .zero, y: view.bounds.size.height)
        return convertPoint(fromView: bottomView).y
    }
}
