//
//  Player.swift
//  FlappyBird
//
//  Created by Савелий Никулин on 21.12.2020.
//

import SpriteKit

class Player {
    
    private enum FlapPosition: Int {
        case Up, Middle, Down
    }
    private var currFlapPos: FlapPosition = .Middle
    
    private var redBirdTextures: [SKTexture]!
    private var playerSprite: SKSpriteNode!
    private var isAnimatePlaying = true
    
    var sprite: SKSpriteNode { playerSprite }
    
    private let rotateUp = SKAction.rotate(toAngle: CGFloat.pi / 4, duration: 0.08)
    private let rotateDown = SKAction.rotate(toAngle: -CGFloat.pi / 2 , duration: 1.65)
    
    private var scene: SKScene!
    
    public let playerCategory: UInt32 = 0x1 << 1
    private let baseAndPipeContact: UInt32 = 0x1 << 2
    
    
    init(scene: SKScene) {
        
        self.scene = scene
        
        redBirdTextures = [
            SKTexture(imageNamed: "redbird-upflap"),
            SKTexture(imageNamed: "redbird-midflap"),
            SKTexture(imageNamed: "redbird-downflap")
        ]
        
        playerSprite = SKSpriteNode(texture: redBirdTextures[currFlapPos.rawValue])
        playerSprite.zPosition = 2
        playerSprite.setScale(3)
        
        playerSprite.position = CGPoint(
            x: scene.position.x - scene.frame.width / 4,
            y: 200
        )
        
        
        playerSprite.physicsBody = SKPhysicsBody(
            texture: redBirdTextures[currFlapPos.rawValue],
            size: CGSize(
                width: redBirdTextures[currFlapPos.rawValue].size().width * 3,
                height: redBirdTextures[currFlapPos.rawValue].size().height * 3
            )
        )
        
        playerSprite.physicsBody?.mass = 1
        playerSprite.physicsBody?.isDynamic = true
        playerSprite.physicsBody?.restitution = 0
        playerSprite.physicsBody?.angularDamping = 1
        playerSprite.physicsBody?.categoryBitMask = playerCategory
        playerSprite.physicsBody?.contactTestBitMask = baseAndPipeContact
        // so that the bird dont not fall
        playerSprite.physicsBody?.affectedByGravity = false
        
        var isMiddleAfterDown = false
        Timer.scheduledTimer(withTimeInterval: TimeInterval(0.1), repeats: true, block: {_ in
            
            /*
             bird's wing animation cycle
             
             up
             middle
             down
             middle
             up
             
             */
            if self.isAnimatePlaying {
                switch self.currFlapPos {
                
                case .Up:
                    self.currFlapPos = .Middle
                case .Middle:
                    
                    if !isMiddleAfterDown {
                        self.currFlapPos = .Down
                        isMiddleAfterDown = true
                    } else {
                        self.currFlapPos = .Up
                        isMiddleAfterDown = false
                    }
                    
                case .Down:
                    self.currFlapPos = .Middle
                
                }
                
                self.playerSprite.texture = self.redBirdTextures[self.currFlapPos.rawValue]
            }
            
            
        })
        
    }
    
    func stopMoving() {
        self.isAnimatePlaying = false
    }
    
    func restart() {
        self.isAnimatePlaying = true
        playerSprite.position = CGPoint(
            x: scene.position.x - scene.frame.width / 4,
            y: 200
        )
        playerSprite.removeAllActions()
        playerSprite.run(SKAction.rotate(toAngle: 0, duration: 0))
        playerSprite.position.x = scene.position.x - scene.frame.width / 4
        playerSprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    func touchesBegan() {
        playerSprite.physicsBody?.affectedByGravity = true
        
        playerSprite.removeAction(forKey: "RotateUp")
        playerSprite.run(rotateUp, withKey: "RotateUp")
        
        playerSprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        playerSprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1000))
        
        
    }
    
    func touchesEnded() {
        playerSprite.removeAction(forKey: "RotateDown")
        playerSprite.run(rotateDown, withKey: "RotateDown")
    }
    
    func update() {
        
        //playerSprite.position.x = scene.position.x - scene.frame.width / 4
        
    }
    
}
