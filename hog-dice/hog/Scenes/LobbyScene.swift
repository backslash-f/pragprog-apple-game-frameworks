//
//  LobbyScene.swift
//  hog
//
//  Created by Tammy Coron on 10/30/20.
//

import SpriteKit
import GameplayKit

class LobbyScene: SKScene {
  
  private var newGameButton: SKSpriteNode!
  private var loadGameButton: SKSpriteNode!
  
  override func didMove(to view: SKView) {
    newGameButton = childNode(withName: "newGameButton") as? SKSpriteNode
    loadGameButton = childNode(withName: "loadGameButton") as? SKSpriteNode
  }
  
  // MARK: - TOUCH HANDLERS

  /* ############################################################ */
  /*                 TOUCH HANDLERS STARTS HERE                   */
  /* ############################################################ */

  func touchDown(atPoint pos : CGPoint) {
    let nodeAtPoint = atPoint(pos)
    if newGameButton.contains(nodeAtPoint) {
      startNewGame()
    } else if loadGameButton.contains(nodeAtPoint) {
      
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches {self.touchDown(atPoint: t.location(in: self))}
  }
}
