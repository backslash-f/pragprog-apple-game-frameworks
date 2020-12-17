//
//  MainScene+Orientation.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 15.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

extension MainScene {

    func setupOrientationListener() {
        device.$orientation.sink { [weak self] orientation in
            switch orientation {
            case .portrait, .portraitUpsideDown:
                ValsRevenge.log("Device orientation changed to portrait", category: .orientation)
                self?.camera?.setScale(1.0)
            case .landscapeRight, .landscapeLeft:
                ValsRevenge.log("Device orientation changed to landscape", category: .orientation)
                self?.camera?.setScale(1.25)
            default:
                break
            }
        }
        .store(in: &cancellables)
    }
}
