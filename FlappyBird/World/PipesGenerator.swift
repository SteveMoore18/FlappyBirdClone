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
    
    
    var spritesLower: [SKSpriteNode] {
        get {
            return pipeLowerSprites
        }
    }
    
    var spritesHigher: [SKSpriteNode] {
        get {
            return pipeHigherSprites
        }
    }
    
    var worldSpeed: CGFloat!
    var scene: SKScene!
    
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
            pipeLowerSprites[i].physicsBody?.categoryBitMask = 0x1 << 2
            
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
            pipeHigherSprites[i].physicsBody?.categoryBitMask = 0x1 << 2
            
        }
        
    }
    
    func stopMoving() {
        self.worldSpeed = 0
        
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
        
    }
    
}
