//
//  GameScene.swift
//  Austronaut vs Devil
//
//  Created by Denys Zahorskyi on 10.01.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var austronautSprite = AustronautSprite()
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = .init(x: 0.5, y: 0.5)
        
        austronautSprite.astroWalk()
        
        self.addChild(austronautSprite)
        
        
        
        
    }
    
    
    
}
