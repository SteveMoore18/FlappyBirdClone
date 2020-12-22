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
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -20)
        
        base = Base(scene: self, worldSpeed: worldSpeed)
        player = Player(scene: self)
        pipesGenerator = PipesGenerator(scene: self, worldSpeed: worldSpeed)
        userInterface = UserInterface(scene: self)
        
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameOver {
            player.touchesBegan()
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameOver {
            player.touchesEnded()
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if !isGameOver {
            base.baseMoving()
            player.update()
            pipesGenerator.pipesMoving()
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        
        switch collision {
        case 0x1 << 1 | 0x1 << 2:
            gameOver()
        case  0x1 << 1 | 0x1 << 3:
            gameOver()
        default: break
            
        }
        
    }
    
    func gameOver() {
        isGameOver = true
        base.stopMoving()
        pipesGenerator.stopMoving()
        player.stopMoving()
        userInterface.gameOverText(show: true)
    }
    
}
