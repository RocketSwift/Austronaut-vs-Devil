//
//  MeteoriteSprite.swift
//  Austronaut vs Devil
//
//  Created by Denys Zahorskyi on 11.01.2023.
//

import SpriteKit

public class AsteroidSprite : SKSpriteNode {
    
    public static func newInstance() -> AsteroidSprite {

        let texture = SKTexture(imageNamed: "asteroid")
        let asteroid = AsteroidSprite(texture: texture, size: .init(width: 15, height: 15))
        asteroid.physicsBody = SKPhysicsBody(rectangleOf: asteroid.size)
        asteroid.physicsBody?.categoryBitMask = AsteroidCategory
        asteroid.physicsBody?.contactTestBitMask = WorldFrameCategory | FloorCategory | AstronautCategory
        asteroid.zPosition = 1


//        asteroid.physicsBody?.density = 0.5
        return asteroid
    }
}







