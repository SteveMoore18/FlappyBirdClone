//
//  Base.swift
//  FlappyBird
//
//  Created by Савелий Никулин on 21.12.2020.
//

import SpriteKit

class Base {
    
    private var base1: SKNode!
    private var base2: SKNode!
    private let baseWidth: CGFloat = 1385
    private var worldSpeed: CGFloat!
    
    init(scene: SKScene, worldSpeed: CGFloat) {
        
        // Getting from WorldScene.sks
        base1 = scene.childNode(withName: "Base1")
        base2 = scene.childNode(withName: "Base2")
        
        self.worldSpeed = worldSpeed
        
    }
    
    // The base is moving here
    func baseMoving() {
        
        // (336 * 3) is the size of 1 block multiplied by 3
        if base1.position.x < -baseWidth {
            base1.position.x = base2.position.x + (336 * 3)
        }
        
        if base2.position.x < -baseWidth {
            base2.position.x = base1.position.x + (336 * 3)
        }
        
        base1.position.x -= worldSpeed
        base2.position.x -= worldSpeed
    }
    
}
