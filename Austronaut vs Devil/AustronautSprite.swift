//
//  AustronautSprite.swift
//  Austronaut vs Devil
//
//  Created by Denys Zahorskyi on 10.01.2023.
//

import SpriteKit
import GameplayKit

class AustronautSprite: SKSpriteNode {
    
    let movingSpeed : CGFloat = 100
    
    let walkTextures : [SKTexture] = [SKTexture(imageNamed: "astro_walk_one"),
                                      SKTexture(imageNamed: "astro_walk_two")]
    
    let runTextures : [SKTexture] = [SKTexture(imageNamed: "astro_run_one"),
                                      SKTexture(imageNamed: "astro_run_two")]
    
    init() {
        let texture = SKTexture(imageNamed: "astro_stand")
        super.init(texture: texture, color: .clear, size: .init(width: 80, height: 80))
        
        self.physicsBody = SKPhysicsBody(texture: texture,
                                         size: CGSize(width: self.size.width,
                                                      height: self.size.height))
        self.physicsBody?.mass = 1
        self.zPosition = 10
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = AstronautCategory
        self.physicsBody?.contactTestBitMask = FloorCategory | AsteroidCategory | DiamondCategory
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func astroWalk(direction: String){
        if self.physicsBody?.velocity.dy == 0.0 {
            
            if self.hasActions() {
                self.removeAllActions()
            }
            
            if direction == "right"{
                let walkAction = SKAction.group([
                    .repeat(.animate(with: walkTextures, timePerFrame: 0.4, resize: false, restore: true), count: 3),
                    .moveBy(x: movingSpeed, y: 0, duration: 1.5)
                ])
                run(walkAction, withKey: "walk action")
                xScale = 1
            } else {
                let walkAction = SKAction.group([
                    .repeat(.animate(with: walkTextures, timePerFrame: 0.4, resize: false, restore: true), count: 3),
                    .moveBy(x: -movingSpeed, y: 0, duration: 1.5)
                ])
                run(walkAction, withKey: "walk action")
                xScale = -1
            }
        }
        
    }
    
    func jump() {
        
        if self.physicsBody?.velocity.dy == 0.0 {
            if self.hasActions() {
                self.removeAllActions()
            }
            if self.xScale == 1 {
                self.physicsBody?.applyImpulse(.init(dx: 80, dy: 250))
            } else {
                self.physicsBody?.applyImpulse(.init(dx: -80, dy: 250))
            }
        }
    }
    
    func astroRun() {
        if self.physicsBody?.velocity.dy == 0.0 {
            if self.hasActions() {
                self.removeAllActions()
            }
            if self.xScale == 1 {
                let runAction = SKAction.group([
                    .repeat(.animate(with: runTextures, timePerFrame: 0.3, resize: false, restore: true), count: 3),
                    .moveBy(x: movingSpeed * 2, y: 0, duration: 1.5)
                ])
                run(runAction, withKey: "run action")
            } else {
                let runAction = SKAction.group([
                    .repeat(.animate(with: runTextures, timePerFrame: 0.3, resize: false, restore: true), count: 3),
                    .moveBy(x: -movingSpeed * 2, y: 0, duration: 1.5)
                ])
                run(runAction, withKey: "run action")
            }
        }
    }
    
    

    public func update() {
        
        
    }
    
}
