//
//  Controller.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 14.01.21.
//  Copyright © 2021 backslash-f. All rights reserved.
//

import SpriteKit

class Controller: SKReferenceNode {

    // MARK: - Properties

    private var isMovement: Bool!

    private var attachedNode: SKNode!
    private var nodeSpeed: CGFloat!

    private var base: SKNode!
    private var joystick: SKSpriteNode!
    private var range: CGFloat!

    private var isTracking: Bool = false

    // MARK: - Lifecycle

    convenience init(stickImage: SKSpriteNode?,
                     attachedNode: SKNode,
                     nodeSpeed: CGFloat = 0.0,
                     isMovement: Bool = true,
                     range: CGFloat = 55.0,
                     color: SKColor = .darkGray) {

        self.init(fileNamed: "Controller")

        joystick = childNode(withName: "//controller_stick") as? SKSpriteNode
        joystick.zPosition += 1
        if let stickImage = stickImage {
            joystick.addChild(stickImage)
        }

        // Set up inner base shape.
        base = joystick.childNode(withName: "//controller_main")

        let innerBase = SKShapeNode(circleOfRadius: range * 2)
        innerBase.strokeColor = .black
        innerBase.fillColor = color
        base.addChild(innerBase)

        // Lock Joystick to base.
        let rangeX = SKRange(lowerLimit: -range, upperLimit: range)
        let rangeY = SKRange(lowerLimit: -range, upperLimit: range)
        let lockToBase = SKConstraint.positionX(rangeX, y: rangeY)
        joystick.constraints = [lockToBase]

        // Set the other properties.
        self.range = range
        self.attachedNode = attachedNode
        self.nodeSpeed = nodeSpeed
        self.isMovement = isMovement
    }

    override init(fileNamed fileName: String?) {
        super.init(fileNamed: fileName)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func anchorRight() {
        scene?.anchorPoint = CGPoint(x: 1, y: 0)
        base.position = CGPoint(x: -175.0, y: 175.0)
    }

    func anchorLeft() {
        scene?.anchorPoint = CGPoint(x: 0, y: 0)
        base.position = CGPoint(x: 175.0, y: 175.0)
    }

    func hideLargeArrows() {
        if let node = childNode(withName: "//controller_left") as? SKSpriteNode {
            node.isHidden = true
        }

        if let node = childNode(withName: "//controller_right") as? SKSpriteNode {
            node.isHidden = true
        }

        if let node = childNode(withName: "//controller_up") as? SKSpriteNode {
            node.isHidden = true
        }

        if let node = childNode(withName: "//controller_down") as? SKSpriteNode {
            node.isHidden = true
        }
    }

    func hideSmallArrows() {
        if let node = childNode(withName: "//controller_topLeft") as? SKSpriteNode {
            node.isHidden = true
        }

        if let node = childNode(withName: "//controller_topRight") as? SKSpriteNode {
            node.isHidden = true
        }

        if let node = childNode(withName: "//controller_bottomLeft") as? SKSpriteNode {
            node.isHidden = true
        }

        if let node = childNode(withName: "//controller_bottomRight") as? SKSpriteNode {
            node.isHidden = true
        }
    }
}
