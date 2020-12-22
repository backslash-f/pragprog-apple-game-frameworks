//
//  SoundLibrary.swift
//  valsrevenge
//
//  Sound effects obtained from https://www.zapsplat.com
//  Music by Chris Language (https://twitter.com/ChrisLanguage)
//
//  Created by Tammy Coron on 7/4/20.
//  Copyright (C) 2020 Just Write Code LLC. All rights reserved.
//

import SpriteKit
import AVFoundation
import CSKScene

struct SoundLibrary {

    static func playSound(node: SKNode, audioNode: SKAudioNode,
                          autoplayLooped: Bool = false,
                          isPositional: Bool = true) {

        audioNode.autoplayLooped = autoplayLooped
        audioNode.isPositional = isPositional

        node.addChild(audioNode)
        audioNode.run(SKAction.play())
    }

    static func playMusic(scene: CSKScene, audioNode: SKAudioNode) {

        scene.audioEngine.mainMixerNode.outputVolume = 0.0

        audioNode.autoplayLooped = true
        audioNode.isPositional = false

        scene.addChild(audioNode)
        audioNode.run(SKAction.changeVolume(to: 0.0, duration: 0.0))

        scene.run(SKAction.wait(forDuration: 1.0), completion: { [weak scene] in
            scene?.audioEngine.mainMixerNode.outputVolume = 1.0
            audioNode.run(SKAction.changeVolume(to: 0.75, duration: 2.0))
        })
    }
}
