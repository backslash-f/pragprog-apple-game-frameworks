//
//  MainScene+Orientation.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 15.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

#if os(iOS)
import UIKit

extension MainScene {

    func setupOrientationListener() {
        device.$orientation.sink { [weak self] orientation in
            ValsRevenge.log("Device orientation changed to: \(orientation.rawValue)", category: .orientation)
            self?.didChangeOrientation(to: orientation)
        }
        .store(in: &cancellables)
    }

    func didChangeOrientation(to orientation: UIDeviceOrientation? = nil) {
        let currentOrientation: UIDeviceOrientation
        if let orientation = orientation {
            currentOrientation = orientation
        } else {
            currentOrientation = UIDevice.current.orientation
        }
        let scale: CGFloat = currentOrientation.isPortrait ? 1.0 : 1.25
        camera?.setScale(scale)
    }
}
#endif
