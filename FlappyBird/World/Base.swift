//
//  Base.swift
//  FlappyBird
//
//  Created by Савелий Никулин on 21.12.2020.
//

import SpriteKit

class Base {
    
    private var baseTexture: SKTexture!
    private var baseBlocks: [SKSpriteNode]!
    private let baseCount = 4
    private let baseWidth: CGFloat = 336
    private var worldSpeed: CGFloat!
    private var scene: SKScene!
    
    private let baseCategory: UInt32 = 0x1 << 2
    
    var sprites: [SKSpriteNode] {
        get {
            baseBlocks
        }
    }
    
    init(scene: SKScene, worldSpeed: CGFloat) {
        self.worldSpeed = worldSpeed
        self.scene = scene
        
        baseTexture = SKTexture(imageNamed: "base")
        baseBlocks = []
        
        for i in 0..<baseCount {
            baseBlocks.append(SKSpriteNode(texture: baseTexture))
            
            baseBlocks[i].position = CGPoint(
                x: -scene.size.width / 2 + CGFloat(i) * baseWidth,
                y: -scene.size.height / 2 + baseTexture.size().height / 2
            )
            baseBlocks[i].physicsBody = SKPhysicsBody(rectangleOf: baseTexture.size())
            baseBlocks[i].physicsBody?.affectedByGravity = false
            baseBlocks[i].physicsBody?.allowsRotation = false
            baseBlocks[i].physicsBody?.isDynamic = false
            baseBlocks[i].physicsBody?.categoryBitMask = baseCategory
            baseBlocks[i].zPosition = 1
        }
        
        
    }
    
    func stopMoving() {
        self.worldSpeed = 0
    }
    
    func restart() {
        self.worldSpeed = 10
    }
    
    // The base is moving here
    func baseMoving() {
        
        baseBlocks = baseBlocks.map({ (item) -> SKSpriteNode in
            
            if item.position.x < -self.scene.size.width {
                item.position.x = item.position.x + CGFloat(baseCount) * baseWidth
            }
            item.position.x -= self.worldSpeed
            return item
        })
        
    }
    
}
