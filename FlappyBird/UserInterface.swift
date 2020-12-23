//
//  UserInterface.swift
//  FlappyBird
//
//  Created by Савелий Никулин on 23.12.2020.
//

import SpriteKit

class UserInterface {
    
    private var gameOverTexture: SKTexture!
    private var gameOverSprite: SKSpriteNode!
    
    private var firstLaunchTexture: SKTexture!
    private var firstLaunchSprite: SKSpriteNode!
    
    private var playButtonTexture: SKTexture!
    private var playButtonSprite: SKSpriteNode!
    
    private var scene: SKScene!
    
    var getGameOverSprite: SKSpriteNode { gameOverSprite }
    var getFirstLaunchSprite: SKSpriteNode { firstLaunchSprite }
    var getPlayButtonSprite: SKSpriteNode { playButtonSprite }
    
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
        playButtonSprite.position = CGPoint(x: 0, y: 0)
        playButtonSprite.zPosition = 2
        playButtonSprite.alpha = 0
        playButtonSprite.setScale(3)
        
    }
    
    
    func playButtonShow(show: Bool) {
        playButtonSprite.alpha = show ? 1 : 0
    }
    
    func gameOverText(show: Bool) {
        gameOverSprite.alpha = show ? 1 : 0
    }
    
    func firstLaunchText(show: Bool) {
        firstLaunchSprite.alpha = show ? 1 : 0
    }
    
}
