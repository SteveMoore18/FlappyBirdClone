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
    
    private var scene: SKScene!
    
    var getGameOverSprite: SKSpriteNode {
        get {
            gameOverSprite
        }
    }
    
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
        
    }
    
    func gameOverText(show: Bool) {
        gameOverSprite.alpha = show ? 1 : 0
    }
    
}
