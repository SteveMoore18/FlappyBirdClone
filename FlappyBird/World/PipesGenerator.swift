//
//  PipesGenerator.swift
//  FlappyBird
//
//  Created by Савелий Никулин on 22.12.2020.
//

import SpriteKit

class PipesGenerator {
    
    private var pipeTexture: SKTexture!
    private var pipeLowerSprites: [SKSpriteNode]!
    private var pipeHigherSprites: [SKSpriteNode]!
    
    // Distance between Lower and Higher pipe
    private let distBetLowHighPipe: Int = 1300
    // Distance between pipes
    private let distBetPipes: Int = 500
    // Distance to the first pipe
    private let distToFirstPipe: Int = 1000
    
    private let pipeGeneratorRange = -800...(-300)
    
    private let pipeCategory: UInt32 = 0x1 << 2
    
    var spritesLower: [SKSpriteNode] { pipeLowerSprites }
    
    var spritesHigher: [SKSpriteNode] { pipeHigherSprites }
    
    var worldSpeed: CGFloat!
    var scene: SKScene!
    
    public var hiddenRect: SKShapeNode!
    
    init(scene: SKScene, worldSpeed: CGFloat) {
        
        self.worldSpeed = worldSpeed
        self.scene = scene
        
        pipeTexture = SKTexture(imageNamed: "pipe-green")
        pipeLowerSprites = [SKSpriteNode(texture: pipeTexture),
                       SKSpriteNode(texture: pipeTexture),
                       SKSpriteNode(texture: pipeTexture)
        ]
        
        pipeHigherSprites = [SKSpriteNode(texture: pipeTexture),
                       SKSpriteNode(texture: pipeTexture),
                       SKSpriteNode(texture: pipeTexture)
        ]
        
        hiddenRect = SKShapeNode(rect: CGRect(x: -50, y: -distBetPipes / 2, width: 100, height: distBetPipes))
        hiddenRect.strokeColor = .clear
        hiddenRect.physicsBody = SKPhysicsBody(rectangleOf: hiddenRect.frame.size)
        hiddenRect.physicsBody?.affectedByGravity = false
        hiddenRect.physicsBody?.allowsRotation = false
        hiddenRect.physicsBody?.isDynamic = false
        hiddenRect.physicsBody?.categoryBitMask = 0x1 << 4
        hiddenRect.physicsBody?.contactTestBitMask = 0x1 << 1
        
        for i in 0..<pipeLowerSprites.count {
            let randY = Int.random(in: pipeGeneratorRange)
            
            pipeLowerSprites[i].position = CGPoint(x: distToFirstPipe + i * distBetPipes, y: randY)
            pipeLowerSprites[i].zPosition = 0
            pipeLowerSprites[i].setScale(3)
            
            pipeHigherSprites[i].run(SKAction.rotate(toAngle: CGFloat.pi, duration: 0))
            pipeHigherSprites[i].position = CGPoint(x: distToFirstPipe + i * distBetPipes, y: randY + distBetLowHighPipe)
            pipeHigherSprites[i].zPosition = 0
            pipeHigherSprites[i].setScale(3)
            
            
            pipeLowerSprites[i].physicsBody = SKPhysicsBody(
                texture: pipeTexture,
                size: CGSize(
                    width: pipeTexture.size().width * 3,
                    height: pipeTexture.size().height * 3
                )
            )
            pipeLowerSprites[i].physicsBody?.affectedByGravity = false
            pipeLowerSprites[i].physicsBody?.allowsRotation = false
            pipeLowerSprites[i].physicsBody?.isDynamic = false
            pipeLowerSprites[i].physicsBody?.categoryBitMask = pipeCategory
            
            pipeHigherSprites[i].physicsBody = SKPhysicsBody(
                texture: pipeTexture,
                size: CGSize(
                    width: pipeTexture.size().width * 3,
                    height: pipeTexture.size().height * 3
                )
            )
            pipeHigherSprites[i].physicsBody?.affectedByGravity = false
            pipeHigherSprites[i].physicsBody?.allowsRotation = false
            pipeHigherSprites[i].physicsBody?.isDynamic = false
            pipeHigherSprites[i].physicsBody?.categoryBitMask = pipeCategory
            
        }
        
        let y = (pipeLowerSprites[0].position.y + pipeHigherSprites[0].position.y) / 2
        hiddenRect.position = CGPoint(x: CGFloat(distToFirstPipe), y: y)
        
    }
    
    var isGot = false
    var currHiddenRect = 1
    var count = 0
    func collisionHiddenRect(action: @escaping () -> Void) {
        
        if !isGot {
            let y = (pipeLowerSprites[currHiddenRect].position.y + pipeHigherSprites[currHiddenRect].position.y) / 2
            let mv = SKAction.move(to: CGPoint(x: pipeLowerSprites[currHiddenRect].position.x, y: y), duration: 0.01)
            
            switch currHiddenRect {
            case 0:
                currHiddenRect = 1
            case 1:
                currHiddenRect = 2
            case 2:
                currHiddenRect = 0
            default:
                break
            }
            
            hiddenRect.run(mv, completion: {
                self.isGot = false
                action()
            })
            isGot = true
        }
        
    }
    
    func stopMoving() {
        self.worldSpeed = 0
        
    }
    
    func restart() {
        self.worldSpeed = 7
        for i in 0..<pipeLowerSprites.count {
            let randY = Int.random(in: pipeGeneratorRange)
            pipeLowerSprites[i].position = CGPoint(x: distToFirstPipe + i * distBetPipes, y: randY)
            pipeHigherSprites[i].position = CGPoint(x: distToFirstPipe + i * distBetPipes, y: randY + distBetLowHighPipe)
        }
        let y = (pipeLowerSprites[0].position.y + pipeHigherSprites[0].position.y) / 2
        hiddenRect.position = CGPoint(x: CGFloat(distToFirstPipe), y: y)
        currHiddenRect = 1
        isGot = false
    }
    
    func pipesMoving() {
        
        for i in 0..<pipeLowerSprites.count {
            if pipeLowerSprites[i].position.x < -self.scene.size.width + 156 {
                let randY = Int.random(in: pipeGeneratorRange)
                
                if i == 0 {
                    pipeLowerSprites[0].position = CGPoint(
                        x: Int(pipeLowerSprites[2].position.x + CGFloat(distBetPipes)),
                        y: randY
                    )
                    pipeHigherSprites[0].position = CGPoint(
                        x: Int(pipeLowerSprites[2].position.x + CGFloat(distBetPipes)),
                        y: randY + distBetLowHighPipe
                    )
                } else {
                    pipeLowerSprites[i].position = CGPoint(
                        x: Int(pipeLowerSprites[i - 1].position.x + CGFloat(distBetPipes)),
                        y: randY
                    )
                    pipeHigherSprites[i].position = CGPoint(
                        x: Int(pipeLowerSprites[i - 1].position.x + CGFloat(distBetPipes)),
                        y: randY + distBetLowHighPipe
                    )
                }
                
                
            }
            pipeLowerSprites[i].position.x -= self.worldSpeed
            pipeHigherSprites[i].position.x -= self.worldSpeed
            
        }
        hiddenRect.position.x -= self.worldSpeed
    }
    
}
