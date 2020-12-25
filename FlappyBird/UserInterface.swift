//
//  UserInterface.swift
//  FlappyBird
//
//  Created by Савелий Никулин on 23.12.2020.
//

import SpriteKit

class UserInterface {
    
    public enum CounterPosition {
        case Default, AfterFall
    }
    
    private var gameOverTexture: SKTexture!
    private var gameOverSprite: SKSpriteNode!
    
    private var firstLaunchTexture: SKTexture!
    private var firstLaunchSprite: SKSpriteNode!
    
    private var playButtonTexture: SKTexture!
    private var playButtonSprite: SKSpriteNode!
    
    private var numberTextures: [SKTexture]!
    private var numberSprites: [SKSpriteNode]!
    private var counterNumberSprites: [SKSpriteNode]!
    private var counterSprite: SKSpriteNode!
    public var getCounterSprite: SKSpriteNode { counterSprite }
    
    private var scene: SKScene!
    
    var getGameOverSprite: SKSpriteNode { gameOverSprite }
    var getFirstLaunchSprite: SKSpriteNode { firstLaunchSprite }
    var getPlayButtonSprite: SKSpriteNode { playButtonSprite }
    
    let animationDuration: TimeInterval = 0.1
    
    private var count: Int = 0
    
    init(scene: SKScene) {
        self.scene = scene
        
        gameOverTexture = SKTexture(imageNamed: "gameover")
        gameOverSprite = SKSpriteNode(texture: gameOverTexture)
        gameOverSprite.position = CGPoint(
            x: 0,
            y: 300)
        gameOverSprite.setScale(2)
        gameOverSprite.alpha = 0
        gameOverSprite.zPosition = 2
        
        firstLaunchTexture = SKTexture(imageNamed: "message")
        firstLaunchSprite = SKSpriteNode(texture: firstLaunchTexture)
        firstLaunchSprite.position = CGPoint(x: 0, y: 0)
        firstLaunchSprite.zPosition = 2
        firstLaunchSprite.alpha = 1
        firstLaunchSprite.setScale(3)
        
        playButtonTexture = SKTexture(imageNamed: "playbutton")
        playButtonSprite = SKSpriteNode(texture: playButtonTexture)
        playButtonSprite.position = CGPoint(x: 0, y: -350)
        playButtonSprite.zPosition = 2
        playButtonSprite.alpha = 0
        playButtonSprite.setScale(3)
        
        numberTextures = []
        numberSprites = []
        for i in 0...9 {
            numberTextures.append(SKTexture(imageNamed: "\(i)"))
            numberSprites.append(SKSpriteNode(texture: numberTextures[i]))
        }
        
        counterSprite = SKSpriteNode()
        counterSprite.zPosition = 3
        counterSprite.setScale(3)
        counterSprite.position = CGPoint(x: 0, y: 300)
        counterSprite.alpha = 0
        
        counterNumberSprites = []
        for i in 0..<3 {
            let t = SKSpriteNode(texture: numberTextures[0])
            if i != 0 {
                t.alpha = 0
            }
            t.position.x = CGFloat(i * 24)
            counterNumberSprites.append(t)
            counterSprite.addChild(t)
        }
        setCountValue(value: 0)
    }
    
    func setCountValue(value: Int) {
        self.count = value
        
        var t = 0
        if value >= 0 && value <= 9 {
            counterNumberSprites[0].texture = numberTextures[value]
            for number in counterNumberSprites {
                if t != 0 { number.alpha = 0 }
                number.position.x = CGFloat(t * 24)
                t += 1
            }
        } else if value >= 10 && value <= 99 {
            counterSprite.position.x = -48
            
            counterNumberSprites[1].alpha = 1
            let a = value / 10
            let b = value % 10
            
            counterNumberSprites[0].texture = numberTextures[a]
            counterNumberSprites[1].texture = numberTextures[b]
            
        } else if value >= 100 && value <= 999 {
            counterSprite.position.x = -72
            
            counterNumberSprites[1].alpha = 1
            counterNumberSprites[2].alpha = 1
            
            let a = value / 100
            let b = (value / 10) % 10
            let c = value % 10
            
            counterNumberSprites[0].texture = numberTextures[a]
            counterNumberSprites[1].texture = numberTextures[b]
            counterNumberSprites[2].texture = numberTextures[c]
        }
    }
    
    func playButtonShow(show: Bool) {
        let alpha: CGFloat = show ? 1 : 0
        playButtonSprite.run(SKAction.fadeAlpha(to: alpha, duration: animationDuration))
    }
    
    func gameOverText(show: Bool) {
        let alpha: CGFloat = show ? 1 : 0
        gameOverSprite.run(SKAction.fadeAlpha(to: alpha, duration: animationDuration))
    }
    
    func firstLaunchText(show: Bool) {
        firstLaunchSprite.alpha = show ? 1 : 0
        counterSprite.run(SKAction.fadeAlpha(to: 1, duration: animationDuration))
    }
    
    func setCounterPosition(pos: CounterPosition) {
        switch pos {
        case .Default:
            counterSprite.run(SKAction.move(to: CGPoint(x: 0, y: 300), duration: animationDuration))
        case .AfterFall:
            // if count two-digit or three-digit then 'x' is shifted
            var x = 0
            if count >= 10 && count <= 99 {
                x = -48
            } else if count >= 100 && count <= 999 {
                x = -72
            }
            counterSprite.run(SKAction.move(to: CGPoint(x: x, y: 0), duration: animationDuration))
        }
    }
}
