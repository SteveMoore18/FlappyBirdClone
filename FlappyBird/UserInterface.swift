//
//  UserInterface.swift
//  FlappyBird
//
//  Created by Савелий Никулин on 23.12.2020.
//

import SpriteKit

class UserInterface {

    public enum CounterPosition {
        case default1, afterFall
    }

    private var gameOverTexture: SKTexture!
    private var gameOverSprite: SKSpriteNode!

    private var firstLaunchTexture: SKTexture!
    private var firstLaunchSprite: SKSpriteNode!

    private var playButtonTexture: SKTexture!
    private var playButtonSprite: SKSpriteNode!

    private var flashRect: SKShapeNode!
    private var flashWasUsed = false

    private var numberTextures: [SKTexture]!
    private var numberSprites: [SKSpriteNode]!
    private var counterNumberSprites: [SKSpriteNode]!
    private var counterSprite: SKSpriteNode!
    public var getCounterSprite: SKSpriteNode { counterSprite }

    private var scene: SKScene!

    var getGameOverSprite: SKSpriteNode { gameOverSprite }
    var getFirstLaunchSprite: SKSpriteNode { firstLaunchSprite }
    var getPlayButtonSprite: SKSpriteNode { playButtonSprite }
    var getFlashRect: SKShapeNode { flashRect }

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

        flashRect = SKShapeNode(rect: CGRect(
                                    x: -scene.frame.width / 2,
                                    y: -scene.frame.height / 2,
                                    width: scene.frame.width,
                                    height: scene.frame.height))
        flashRect.zPosition = 4
        flashRect.fillColor = .white
        flashRect.alpha = 0

        numberTextures = []
        numberSprites = []
        for index in 0...9 {
            numberTextures.append(SKTexture(imageNamed: "\(index)"))
            numberSprites.append(SKSpriteNode(texture: numberTextures[index]))
        }

        counterSprite = SKSpriteNode()
        counterSprite.zPosition = 3
        counterSprite.setScale(3)
        counterSprite.position = CGPoint(x: 0, y: 300)
        counterSprite.alpha = 0

        counterNumberSprites = []
        for index in 0..<3 {
            let temp = SKSpriteNode(texture: numberTextures[0])
            if index != 0 {
               temp.alpha = 0
            }
           temp.position.x = CGFloat(index * 24)
            counterNumberSprites.append(temp)
            counterSprite.addChild(temp)
        }
        setCountValue(value: 0)
    }

    func setCountValue(value: Int) {
        self.count = value
        flashWasUsed = false
        var temp = 0
        if value >= 0 && value <= 9 {
            counterNumberSprites[0].texture = numberTextures[value]
            for number in counterNumberSprites {
                if temp != 0 { number.alpha = 0 }
                number.position.x = CGFloat(temp * 24)
                temp += 1
            }
        } else if value >= 10 && value <= 99 {
            counterSprite.position.x = -48

            counterNumberSprites[1].alpha = 1
            let number1 = value / 10
            let number2 = value % 10

            counterNumberSprites[0].texture = numberTextures[number1]
            counterNumberSprites[1].texture = numberTextures[number2]

        } else if value >= 100 && value <= 999 {
            counterSprite.position.x = -72

            counterNumberSprites[1].alpha = 1
            counterNumberSprites[2].alpha = 1

            let number1 = value / 100
            let number2 = (value / 10) % 10
            let number3 = value % 10

            counterNumberSprites[0].texture = numberTextures[number1]
            counterNumberSprites[1].texture = numberTextures[number2]
            counterNumberSprites[2].texture = numberTextures[number3]
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
        case .default1:
            counterSprite.run(SKAction.move(to: CGPoint(x: 0, y: 300), duration: animationDuration))
        case .afterFall:
            // if count two-digit or three-digit then 'x' is shifted
            var posX = 0
            if count >= 10 && count <= 99 {
                posX = -48
            } else if count >= 100 && count <= 999 {
                posX = -72
            }
            counterSprite.run(SKAction.move(to: CGPoint(x: posX, y: 0), duration: animationDuration))
        }
    }

    func flash() {
        if !flashWasUsed {
            flashRect.run(SKAction.fadeAlpha(to: 0.7, duration: 0.1), completion: {
                self.flashRect.run(SKAction.fadeAlpha(to: 0, duration: 0.1))
            })
            flashWasUsed = true
        }
    }
}
