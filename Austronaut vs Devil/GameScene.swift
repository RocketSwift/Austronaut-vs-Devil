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
    var diamond : DiamondSprite!
    
    let cam = SKCameraNode()
    
    lazy var floor : SKSpriteNode = {
        let floor = SKSpriteNode(imageNamed: "ground")
        floor.size = .init(width: 10000, height: 30)
        floor.position.x = frame.minX
        floor.position.y = frame.minY + 20
        floor.physicsBody = .init(rectangleOf: .init(width: 10000, height: 1))
        floor.physicsBody?.isDynamic = false
        floor.physicsBody?.categoryBitMask = FloorCategory
        floor.physicsBody?.contactTestBitMask = WorldFrameCategory | AstronautCategory | AsteroidCategory
        return(floor)
    }()
    
    
    lazy var moon : SKSpriteNode = {
        let moon = SKSpriteNode(imageNamed: "moon")
        moon.size = .init(width: 210, height: 210)
        moon.zPosition = -1
        return moon
    }()
    
    lazy var mountain1 : SKSpriteNode = {
        let mountain1 = SKSpriteNode(imageNamed: "mountain1")
        let texture = SKTexture(imageNamed: "mountain1")
        mountain1.size = .init(width: 150, height: 110)
        mountain1.position.x = frame.midX - 200
        mountain1.position.y = frame.minY + 60
        mountain1.zPosition = -1
        return mountain1
    }()
    
    lazy var mountain2 : SKSpriteNode = {
        let mountain2 = SKSpriteNode(imageNamed: "mountain2")
        let texture = SKTexture(imageNamed: "mountain2")
        mountain2.size = .init(width: 150, height: 110)
        mountain2.position.x = frame.midX + 200
        mountain2.position.y = frame.minY + 60
        mountain2.zPosition = -1
        return mountain2
    }()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var scoreLabel : SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.horizontalAlignmentMode = .center
        // scoreLabel розташований дуже костильно, розташувати без костиля не виходить
        scoreLabel.position.x = cam.frame.minX - 200
        scoreLabel.position.y = cam.frame.minY + 110
        cam.addChild(scoreLabel)

        camera = cam

        self.addChild(cam)
        
        physicsWorld.contactDelegate = self
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -2.721)
        
//        var worldFrame = frame
//        worldFrame.origin.x -= 100
//        worldFrame.origin.y -= 100
//        worldFrame.size.height += 200
//        worldFrame.size.width += 200
        
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
        

        self.addChild(floor)
        self.addChild(austronautSprite)
        
        addChild(moon)
        addChild(mountain1)
        addChild(mountain2)
        
    }
    

    @objc func tapped(_ sender: UITapGestureRecognizer) {

            austronautSprite.jump()
        }

    @objc func swiped(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            austronautSprite.astroWalk(direction: "left")
            
            moon.run(SKAction.moveBy(x: -40, y: 0, duration: 2))
            
            [mountain1, mountain2].forEach({$0.run(SKAction.moveBy(x: -60, y: 0, duration: 2))})

        case .right:
            austronautSprite.astroWalk(direction: "right")
            moon.run(SKAction.moveBy(x: 40, y: 0, duration: 2))

            [mountain1, mountain2].forEach({$0.run(SKAction.moveBy(x: 60, y: 0, duration: 2))})
        case .up:
            austronautSprite.jump()
            moon.run(SKAction.moveBy(x: 40, y: 0, duration: 2))
            
            [mountain1, mountain2].forEach({$0.run(SKAction.moveBy(x: 60, y: 0, duration: 2))})
        default:
            austronautSprite.jump()
        }
    }
    
    func spawnAsteroid() {
        let velocityDirection = Int.random(in: -200...200)
        asteroid = AsteroidSprite.newInstance()
        asteroid.position.x = .random(in: frame.minX...frame.maxX)
        asteroid.position.y = frame.size.height + asteroid.size.height
        asteroid.physicsBody!.velocity.dx = CGFloat(velocityDirection)
        let emitter = SKEmitterNode(fileNamed: "FireParticle")
        emitter?.position = CGPoint(x: 0, y: 0)
        emitter?.targetNode = self
        emitter?.zPosition = 1
        asteroid.addChild(emitter!)
        addChild(asteroid)
    }
    
    func spawnDiamond() {
        diamond = DiamondSprite.newInstance()
        diamond.position.x = .random(in: 1...floor.size.width)
        diamond.anchorPoint = .init(x: 0, y: 0)

        diamond.zRotation = .pi / 4
        addChild(diamond)
    }

    
    override func update(_ currentTime: TimeInterval) {
        camera?.position.x = austronautSprite.position.x
        
//        scoreLabel.position.x = (camera?.position.x)!
//        scoreLabel.position.y = (camera?.position.y)!
        
//        camera?.position.y = austronautSprite.position.y
//        background.position.x = (camera?.position.x)!
        
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        currentAsteroidSpawnTime += dt
        
        if currentAsteroidSpawnTime > asteroidSpawnRate {
            currentAsteroidSpawnTime = 0
            
            spawnAsteroid()
            spawnDiamond()
        }
    }
    
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        score += 1
                
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

