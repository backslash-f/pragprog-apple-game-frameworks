//
//  SKScene+SceneManager.swift
//  valsrevenge
//
//  Created by Tammy Coron on 10/16/20.
//  Copyright © 2020 Just Write Code LLC. All rights reserved.
//

import SpriteKit
import GameplayKit
import Device

extension SKScene {

    func startNewGame() {
        GameData.shared.level = 1
        GameData.shared.keys = 0
        GameData.shared.treasure = 0
        loadSceneForLevel(GameData.shared.level)
    }

    func resumeSavedGame() {
        loadSceneForLevel(GameData.shared.level)
    }

    func loadSceneForLevel(_ level: Int) {
        ValsRevenge.log("Attempting to load next scene: \(level)", category: .scene)

        // Play sound.
        run(SKAction.playSoundFileNamed("exit", waitForCompletion: true))

        // Create actions to load the next scene.
        let wait = SKAction.wait(forDuration: 0.50)
        let block = SKAction.run {

            // Load 'GameScene_xx.sks' as a GKScene.
            if let scene = GKScene(fileNamed: "GameScene_\(level)") {

                // Get the SKScene from the loaded GKScene.
                if let sceneNode = scene.rootNode as? MainScene {

                    // Copy gameplay related content over to the scene.
                    sceneNode.entities = scene.entities
                    sceneNode.graphs = scene.graphs

                    // Set the scale mode to scale to fit the window.
                    sceneNode.scaleMode = .aspectFill

                    // Present the scene.
                    self.view?.presentScene(sceneNode, transition: SKTransition.doorsOpenHorizontal(withDuration: 1.0))

                    #if os(iOS)
                    // Update the layout.
                    sceneNode.didChangeOrientation()
                    #endif
                }
            } else {
                print("Can't load next scene: GameScene_\(level).")
            }
        }

        // Run the actions in sequence
        run(SKAction.sequence([wait, block]))
    }

    func loadGameOverScene() {
        print("Attempting to load the game over scene.")

        // Create actions to load the game over scene
        let wait = SKAction.wait(forDuration: 0.50)
        let block = SKAction.run {
            if let scene = GameOverScene(fileNamed: "GameOverScene") {
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1.0))
            } else {
                ValsRevenge.log("Can't load game over scene.", category: .scene)
            }
        }

        // Run the actions in sequence.
        run(SKAction.sequence([wait, block]))
    }
}
