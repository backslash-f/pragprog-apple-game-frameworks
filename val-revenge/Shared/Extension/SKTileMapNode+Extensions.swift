//
//  SKTileMapNode+Extensions.swift
//  val-revenge
//
//  Created by Fernando Fernandes on 18.12.20.
//  Copyright © 2020 backslash-f. All rights reserved.
//

import SpriteKit

extension SKTileMapNode {

    func setupEdgeLoop() {
        let mapPoint = CGPoint(x: -frame.size.width / 2, y: -frame.size.height / 2)
        let mapSize = CGSize(width: frame.size.width, height: frame.size.height)
        let edgeLoopRect = CGRect(origin: mapPoint, size: mapSize)

        // Set up physics body.
        physicsBody = SKPhysicsBody(edgeLoopFrom: edgeLoopRect)

        // Adjust default values.
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsCategory.playerAndWall.rawValue
    }

    func setupMapPhysics() {
        let halfWidth = CGFloat(numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(numberOfRows) / 2.0 * tileSize.height

        for col in 0..<numberOfColumns {
            for row in 0..<numberOfRows {
                guard let tileDefinition = tileDefinition(atColumn: col, row: row) else {
                    continue
                }
                let bodySizeKey = Constant.UserData.bodySizeKey
                guard let bodySizeValue = tileDefinition.userData?.value(forKey: bodySizeKey) as? String else {
                    continue
                }

                let xValue = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width / 2)
                let yValue = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height / 2)

                let bodySize = NSCoder.cgPoint(for: bodySizeValue) // {x,y}
                let pSize = CGSize(width: bodySize.x, height: bodySize.y)

                let tileNode = SKNode()
                tileNode.position = CGPoint(x: xValue, y: yValue)

                let bodyOffsetKey = Constant.UserData.bodyOffsetKey
                if let bodyOffsetValue = tileDefinition.userData?.value(forKey: bodyOffsetKey) as? String {
                    let bodyOffset = NSCoder.cgPoint(for: bodyOffsetValue)
                    let centerPoint = CGPoint(x: bodyOffset.x, y: bodyOffset.y)
                    tileNode.physicsBody = SKPhysicsBody(
                        rectangleOf: pSize,
                        center: centerPoint
                    )
                } else {
                    tileNode.physicsBody = SKPhysicsBody(rectangleOf: pSize)
                }

                // Adjust default values.
                tileNode.physicsBody?.affectedByGravity = false
                tileNode.physicsBody?.allowsRotation = false
                tileNode.physicsBody?.isDynamic = false
                tileNode.physicsBody?.categoryBitMask = PhysicsCategory.playerAndWall.rawValue

                addChild(tileNode)
            }
        }
    }
}
