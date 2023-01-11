//
//  AustronautSprite.swift
//  Austronaut vs Devil
//
//  Created by Denys Zahorskyi on 10.01.2023.
//

import SpriteKit
import GameplayKit

class AustronautSprite: SKSpriteNode {
    
    let movingSpeed : CGFloat = 80
    
    let walkTextures : [SKTexture] = [SKTexture(imageNamed: "astro_walk_one"),
                                      SKTexture(imageNamed: "astro_walk_two")]
    
    init() {
        let texture = SKTexture(imageNamed: "astro_stand")
        super.init(texture: texture, color: .clear, size: .init(width: 100, height: 100))
        
        
        self.physicsBody = SKPhysicsBody(texture: texture,
                                                      size: CGSize(width: self.size.width,
                                                                   height: self.size.height))
        self.physicsBody?.mass = 1
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func astroWalk(direction: String){
        
        if self.action(forKey: "walk action") != nil{
            self.removeAction(forKey: "walk action")
        }
        
        if direction == "right"{
            let walkAction = SKAction.group([
                .repeat(.animate(with: walkTextures, timePerFrame: 0.4, resize: false, restore: true), count: 3),
                .moveBy(x: movingSpeed, y: 0, duration: 2)
            ])
            run(walkAction, withKey: "walk action")
            xScale = 1
        } else {
            let walkAction = SKAction.group([
                .repeat(.animate(with: walkTextures, timePerFrame: 0.4, resize: false, restore: true), count: 3),
                .moveBy(x: -movingSpeed, y: 0, duration: 2)
            ])
            run(walkAction, withKey: "walk action")
            xScale = -1
        }
        
    }
    
    func jump() {
        self.physicsBody?.applyImpulse(.init(dx: 80, dy: 300))

    }
    
    public func update() {
        
        if zRotation != 0 && action(forKey: "action_rotate") == nil {
            run(SKAction.rotate(toAngle: 0, duration: 0.25), withKey: "action_rotate")
        }
    }
    
//    enum State {
//            case left, right, stay
//
//            var texturesBaseName: String {
//                switch self {
//                case .left:
//                    return "left"
//                case .right:
//                    return "right"
//                case .stay:
//                    return "dawn"
//                }
//            }
//
//            var textures: [SKTexture] {
//                let name = self.texturesBaseName
//                var arr = [SKTexture]()
//                for i in 0...5 {
//                    let text = SKTexture(imageNamed: "\(name)\(i)")
//                    arr.append(text)
//                }
//                return arr
//            }
//        }
//
//        private let movementKey = "movement"
//        private let movementSpeed: CGFloat = 70
//
//        init() {
//            let texture = SKTexture(imageNamed: "dawn0")
//            super.init(texture: texture, color: .clear, size: texture.size())
//
//            self.physicsBody = .init(circleOfRadius: self.size.width / 2)
//            self.physicsBody?.mass = 1
//
//            self.stay()
//        }
//
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//
//        func moveLeft() {
//            self.animateTextures(forState: .left)
//
//            self.removeAction(forKey: movementKey)
//            self.run(.repeatForever(.moveBy(x: -movementSpeed, y: 0, duration: 1)), withKey: movementKey)
//        }
//
//        func moveRight() {
//            self.animateTextures(forState: .right)
//
//            self.removeAction(forKey: movementKey)
//            self.run(.repeatForever(.moveBy(x: movementSpeed, y: 0, duration: 1)), withKey: movementKey)
//        }
//
//        func stay() {
//            self.animateTextures(forState: .stay)
//
//            self.removeAction(forKey: movementKey)
//        }
//
//        private func animateTextures(forState state: State) {
//            let animateAction = SKAction.animate(
//                with: state.textures,
//                timePerFrame: 0.1,
//                resize: true,
//                restore: false)
//
//            self.run(.repeatForever(animateAction))
//        }
//
//        func jump() {
//            self.physicsBody?.applyImpulse(.init(dx: 0, dy: 600))
//        }
    
    
    
}
