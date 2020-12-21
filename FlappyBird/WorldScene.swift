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
    
    override func didMove(to view: SKView) {
        
        base = Base(scene: self, worldSpeed: worldSpeed)
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        base.baseMoving()
        
    }
    
    
    
}
