//
//  DiamondSprite.swift
//  Austronaut vs Devil
//
//  Created by Denys Zahorskyi on 17.01.2023.
//

import SpriteKit

public class DiamondSprite : SKSpriteNode {
    
    public static func newInstance() -> DiamondSprite {
 
        let texture = SKTexture(imageNamed: "diamond")
        let diamond = DiamondSprite(texture: texture, size: .init(width: 30, height: 30))
        diamond.physicsBody = SKPhysicsBody(rectangleOf: diamond.size)
        diamond.physicsBody?.categoryBitMask = DiamondCategory

        diamond.physicsBody?.contactTestBitMask = WorldFrameCategory | FloorCategory | AstronautCategory
        diamond.zPosition = 1
  
        return diamond
    }
}
