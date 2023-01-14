//
//  GameScene.swift
//  Austronaut vs Devil
//
//  Created by Denys Zahorskyi on 10.01.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var lastUpdateTime : TimeInterval = 0
    private var currentAsteroidSpawnTime : TimeInterval = 0
    private var asteroidSpawnRate : TimeInterval = 5000
    
    var austronautSprite = AustronautSprite()
    var asteroid : AsteroidSprite!
    
    let cam = SKCameraNode()
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -2.721)
        
        var worldFrame = frame
        worldFrame.origin.x -= 100
        worldFrame.origin.y -= 100
        worldFrame.size.height += 200
        worldFrame.size.width += 200
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = view.frame.size
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
        
        let gestureRun = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        gestureRun.numberOfTapsRequired = 2
        view.addGestureRecognizer(gestureRun)
        
        self.anchorPoint = .init(x: 0.5, y: 0.5)
        
        
        self.addChild(austronautSprite)
        
        createFloor()
    
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {

            austronautSprite.jump()
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
        floorNode.physicsBody?.categoryBitMask = FloorCategory
        floorNode.physicsBody?.contactTestBitMask = WorldFrameCategory | AstronautCategory | AsteroidCategory
        self.addChild(floorNode)
    }
    
    func spawnAsteroid() {
        asteroid = AsteroidSprite.newInstance()

        asteroid.position.x = .random(in: frame.minX...frame.maxX)
        asteroid.position.y = frame.size.height + asteroid.size.height
        
        let emitter = SKEmitterNode(fileNamed: "FireParticle") //MyParticle is the name of the sks file.
        emitter?.position = CGPoint(x: 0, y: 0)
        emitter?.zPosition = 1
        asteroid.addChild(emitter!) //Now the emitter is the child of your Spaceship.
        asteroid.physicsBody!.velocity.dx = 400
        
        addChild(asteroid)
    }
    
    override func update(_ currentTime: TimeInterval) {
        //        cam.position = austronautSprite.position
        
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        currentAsteroidSpawnTime += dt
        
        if currentAsteroidSpawnTime > asteroidSpawnRate {
            currentAsteroidSpawnTime = 0
            spawnAsteroid()
        }
    }
    
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("yes contact")
                
        if contact.bodyA.categoryBitMask == AsteroidCategory {
            let body = contact.bodyA
            body.node?.removeFromParentWithParticles()
//            score += 1
        } else if contact.bodyB.categoryBitMask == AsteroidCategory {
            let body = contact.bodyB
            body.node?.removeFromParentWithParticles()
//            let node = body.node
//            let bonus = node as? SKSpriteNode
//            node?.removeFromParentWithParticles()
//            score += 1
//        }
//
//        if contact.bodyA.categoryBitMask == BitMasks.enemy {
//            fatalError()
//        } else if contact.bodyB.categoryBitMask == BitMasks.enemy {
//            fatalError()
        }
    }
}

extension SKNode {
    func removeFromParentWithParticles(particlesName: String = "Boom") {
        let part = SKEmitterNode(fileNamed: "Boom")!
        part.position = self.position
        self.parent?.addChild(part)
        self.removeFromParent()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            part.removeFromParent()

        }
        
    }
}

