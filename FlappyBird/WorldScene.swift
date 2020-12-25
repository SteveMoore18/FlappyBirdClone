//
//  GameScene.swift
//  FlappyBird
//
//  Created by Савелий Никулин on 21.12.2020.
//

import SpriteKit
import GameplayKit

class WorldScene: SKScene, SKPhysicsContactDelegate {
    
    var worldSpeed: CGFloat = 7
    
    var base: Base!
    var player: Player!
    var pipesGenerator: PipesGenerator!
    var userInterface: UserInterface!
    
    private var isGameOver: Bool = false
    private var isGameStarted: Bool = false
    
    private let pipesAndBaseCategory: UInt32 = 0x1 << 2
    
    private var backgroundDay: SKSpriteNode!
    private var backgroundNight: SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -20)
        
        base = Base(scene: self, worldSpeed: worldSpeed)
        player = Player(scene: self)
        pipesGenerator = PipesGenerator(scene: self, worldSpeed: worldSpeed)
        userInterface = UserInterface(scene: self)
        
        backgroundDay = self.childNode(withName: "backgroundDay") as? SKSpriteNode
        backgroundNight = self.childNode(withName: "backgroundNight") as? SKSpriteNode
        
        for i in pipesGenerator.spritesLower {
            self.addChild(i)
        }
        
        for i in pipesGenerator.spritesHigher {
            self.addChild(i)
        }
        
        for i in base.sprites {
            self.addChild(i)
        }
        
        self.addChild(player.sprite)
        self.addChild(userInterface.getGameOverSprite)
        self.addChild(userInterface.getFirstLaunchSprite)
        self.addChild(userInterface.getPlayButtonSprite)
        self.addChild(pipesGenerator.hiddenRect)
        self.addChild(userInterface.getCounterSprite)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !isGameStarted {
            isGameStarted = true
            userInterface.firstLaunchText(show: false)
        }
        
        if !isGameOver {
            player.touchesBegan()
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for i in touches {
            let locate = i.location(in: self)
            
            // If user pressed on the 'Restart' button
            if userInterface.getPlayButtonSprite.contains(locate)
                && isGameOver {
                restartGame()
            }
            
        }
        
        if !isGameOver {
            player.touchesEnded()
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if !isGameOver {
            
            base.baseMoving()
            
            // If it's first lauch then pipes dont moving
            if isGameStarted {
                pipesGenerator.pipesMoving()
            }
            
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        
        switch collision {
        case player.playerCategory | pipesAndBaseCategory:
            gameOver()
        case player.playerCategory | 0x1 << 4:
            pipesGenerator.collisionHiddenRect(action: {
                self.userInterface.setCountValue(value: self.player.countIncr())
            })
        default: break
        }
        
    }
    
    func gameOver() {
        isGameOver = true
        base.stopMoving()
        pipesGenerator.stopMoving()
        player.stopMoving()
        userInterface.gameOverText(show: true)
        userInterface.playButtonShow(show: true)
        userInterface.setCounterPosition(pos: .AfterFall)
    }
    
    func restartGame() {
        
        isGameOver = false
        base.restart()
        pipesGenerator.restart()
        player.restart()
        userInterface.gameOverText(show: false)
        userInterface.playButtonShow(show: false)
        switchDayNight()
        userInterface.setCountValue(value: 0)
        userInterface.setCounterPosition(pos: .Default)
    }
    
    func switchDayNight() {
        
        let rand = Int.random(in: -2...(-1))
        backgroundDay.zPosition = CGFloat(rand)
        
    }
}
