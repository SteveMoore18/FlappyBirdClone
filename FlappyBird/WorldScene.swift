//
//  GameScene.swift
//  FlappyBird
//
//  Created by Савелий Никулин on 21.12.2020.
//

import SpriteKit
import GameplayKit

class WorldScene: SKScene {
    
    let worldSpeed: CGFloat = 4
    
    var base: Base!
    var player: Player!
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: -20)
        
        base = Base(scene: self, worldSpeed: worldSpeed)
        player = Player(scene: self)
        
        self.addChild(player.sprite)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.touchesBegan()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.touchesEnded()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        base.baseMoving()
        player.update()
        
    }
    
    
    
}
