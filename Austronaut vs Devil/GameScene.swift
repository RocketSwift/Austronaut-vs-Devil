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
    
    let cam = SKCameraNode()
    
    override func didMove(to view: SKView) {
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -3.721)
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = view.frame.size //self.frame.size //self.view.frame.size
        background.position = .init(x: frame.minX, y: frame.minY)
        background.zPosition = -1
        addChild(background)
        
        let gestureRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        gestureRight.direction = .right
        view.addGestureRecognizer(gestureRight)
        
        let gestureUp = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        gestureUp.direction = .up
        view.addGestureRecognizer(gestureUp)
        
        let gestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        gestureLeft.direction = .left
        view.addGestureRecognizer(gestureLeft)
        
        self.anchorPoint = .init(x: 0.5, y: 0.5)
        
        
        self.addChild(austronautSprite)
        createFloor()
        
    }

    
@objc func swiped(_ sender: UISwipeGestureRecognizer) {
       switch sender.direction {
       case .left:
           austronautSprite.astroWalk(direction: "left")
       case .right:
           austronautSprite.astroWalk(direction: "right")
       case .up:
           austronautSprite.jump()
       default:
           austronautSprite.jump()
       }
   }
    
    func createFloor(){
        let floorNode = SKShapeNode(rectOf: .init(width: 10000, height: 3))
        floorNode.physicsBody = .init(rectangleOf: .init(width: 10000, height: 1))
        floorNode.physicsBody?.isDynamic = false
        floorNode.position.x = frame.minX
        floorNode.position.y = frame.minY + 20
        self.addChild(floorNode)
    }
    
    override func update(_ currentTime: TimeInterval) {
        cam.position = austronautSprite.position
    }
    
    
}
