//
//  MainScene+Orientation.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 15.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

extension MainScene {

    func didChangeLayout() {
        let width = view?.bounds.size.width ?? 1024
        let height = view?.bounds.size.height ?? 1336

        if height >= width {
            // Portrait.
            camera?.setScale(1.0)

        } else {
            // Landscape.
            // Helps to keep relative size. Larger numbers results in "smaller" scenes.
            camera?.setScale(1.25)
        }
    }
}
