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
    private var currentObjectSpawnTime : TimeInterval = 0
    private var objectSpawnRate : TimeInterval = 2000
    
    var diamondsCount = 0

    let spacing : CGFloat = 50
    
    var austronautSprite = AustronautSprite()
    var asteroid : AsteroidSprite!
    var diamond : DiamondSprite!
    
    private var cameraNode = SKCameraNode()
    
    lazy var floor : SKSpriteNode = {
        let floor = SKSpriteNode(imageNamed: "ground")
        floor.size = .init(width: 10000, height: 30)
        floor.position.x = frame.minX
        floor.position.y = frame.minY + 20
        floor.physicsBody = .init(rectangleOf: .init(width: 10000, height: 1))
        floor.physicsBody?.isDynamic = false
        floor.physicsBody?.categoryBitMask = FloorCategory
        floor.physicsBody?.contactTestBitMask = AstronautCategory | AsteroidCategory
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
    
    lazy var scoreLabel : SKLabelNode = {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - spacing)
        return scoreLabel
    }()
    
    lazy var livesLabel : SKLabelNode = {
        livesLabel = SKLabelNode(text: "❤️❤️❤️")
        livesLabel.horizontalAlignmentMode = .left
        livesLabel.position = CGPoint(x: frame.minX + spacing, y: frame.maxY - spacing)
        return livesLabel
    }()
    
//    var joystick = Joystick()

    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = .init(x: 0.5, y: 0.5)
        
        cameraNode.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(cameraNode)
        camera = cameraNode
    
        [scoreLabel, livesLabel].forEach { sprite in
            cameraNode.addChild(sprite)
        }
        
//        joystick.position = CGPoint(x: frame.minX + spacing * 2, y: frame.minY + spacing * 2)
        
        [floor, austronautSprite, moon, mountain1, mountain2].forEach { sprite in
            self.addChild(sprite)
        }

        physicsWorld.contactDelegate = self
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        
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
        
        spawnDiamond()
 
    }
    

    @objc func tapped(_ sender: UITapGestureRecognizer) {

            austronautSprite.astroRun()
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
    
    func spawnObject() {
        let randomNumber = Int.random(in: 1...100)
        if randomNumber <= 90 {
            spawnAsteroid()
        } else if randomNumber < 98 {
            spawnDiamond()
        } else if randomNumber < 100 {
            spawnBonus()
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
        diamond.anchorPoint = .init(x: 0, y: 0)
        diamond.position.x = .random(in: frame.minX...frame.maxX)
        diamond.position.y = .random(in: frame.minY + 10...frame.minY + spacing * 5)
        self.addChild(diamond)
    }
    
    func spawnBonus() {
        print ("bonus spawned")
    }
    
    func decreaseLife() {
        let currentLives = livesLabel.text?.count
        if currentLives! > 0 {
            livesLabel.text?.removeLast()
        } else {
            print ("game over!")
        }
    }

    
    override func update(_ currentTime: TimeInterval) {
        
//        if joystick.velocity.x != 0 || joystick.velocity.y != 0 {
//            austronautSprite.astroWalk(direction: "left")
//            }

        camera?.position.x = austronautSprite.position.x
        
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        currentObjectSpawnTime += dt
        
        if currentObjectSpawnTime > objectSpawnRate {
            currentObjectSpawnTime = 0
            
            spawnObject()
        }

        
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == AsteroidCategory || contact.bodyB.categoryBitMask == AsteroidCategory {
            handleAsteroidHit(contact: contact)
        }
        if contact.bodyA.categoryBitMask == DiamondCategory || contact.bodyB.categoryBitMask == DiamondCategory {
            handleDiamondContact(contact: contact)
        }
        
    }
    
    func handleAsteroidHit(contact: SKPhysicsContact) {
        var otherBody : SKPhysicsBody
        var asteroidBody : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask == AsteroidCategory {
            otherBody = contact.bodyB
            asteroidBody = contact.bodyA
        } else {
            otherBody = contact.bodyA
            asteroidBody = contact.bodyB
        }
        
        if otherBody.categoryBitMask == AstronautCategory {
            decreaseLife()
            asteroidBody.node?.removeFromParentWithParticles()
        } else {
            asteroidBody.node?.removeFromParentWithParticles()
        }
    }
    
    func handleDiamondContact(contact: SKPhysicsContact) {
        var otherBody : SKPhysicsBody
        var diamondBody : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask == DiamondCategory {
            otherBody = contact.bodyB
            diamondBody = contact.bodyA
        } else {
            otherBody = contact.bodyA
            diamondBody = contact.bodyB
        }
        
        if otherBody.categoryBitMask == AstronautCategory {
            diamondBody.node?.removeFromParent()
            score += 1

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

