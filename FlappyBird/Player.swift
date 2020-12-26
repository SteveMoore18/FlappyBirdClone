//
//  Player.swift
//  FlappyBird
//
//  Created by Савелий Никулин on 21.12.2020.
//

import SpriteKit

class Player {

    private enum FlapPosition: Int {
        case top, middle, down
    }
    private enum BirdSkin: Int {
        case red, yellow, blue

        mutating func randomChange() {
            let rand = Int.random(in: 0...3)
            self = Player.BirdSkin(rawValue: rand) ?? .red
        }
    }

    private var currFlapPos: FlapPosition = .middle

    private var redBirdTextures: [SKTexture]!
    private var yellowBirdTextures: [SKTexture]!
    private var blueBirdTextures: [SKTexture]!
    private var playerSprite: SKSpriteNode!
    private var isAnimatePlaying = true

    var sprite: SKSpriteNode { playerSprite }

    private let rotateUp = SKAction.rotate(toAngle: CGFloat.pi / 4, duration: 0.08)
    private let rotateDown = SKAction.rotate(toAngle: -CGFloat.pi / 2, duration: 1.65)

    private var scene: SKScene!

    public let playerCategory: UInt32 = 0x1 << 1
    private let baseAndPipeContact: UInt32 = 0x1 << 2

    private var currentSkin = BirdSkin.blue

    private var count = 0

    init(scene: SKScene) {

        self.scene = scene

        redBirdTextures = [
            SKTexture(imageNamed: "redbird-upflap"),
            SKTexture(imageNamed: "redbird-midflap"),
            SKTexture(imageNamed: "redbird-downflap")
        ]

        yellowBirdTextures = [
            SKTexture(imageNamed: "yellowbird-upflap"),
            SKTexture(imageNamed: "yellowbird-midflap"),
            SKTexture(imageNamed: "yellowbird-downflap")
        ]

        blueBirdTextures = [
            SKTexture(imageNamed: "bluebird-upflap"),
            SKTexture(imageNamed: "bluebird-midflap"),
            SKTexture(imageNamed: "bluebird-downflap")
        ]

        playerSprite = SKSpriteNode(texture: redBirdTextures[currFlapPos.rawValue])
        playerSprite.zPosition = 2
        playerSprite.setScale(3)

        playerSprite.position = CGPoint(
            x: scene.position.x - scene.frame.width / 4,
            y: 200
        )

        playerSprite.physicsBody = SKPhysicsBody(
            texture: redBirdTextures[currFlapPos.rawValue],
            size: CGSize(
                width: redBirdTextures[currFlapPos.rawValue].size().width * 3,
                height: redBirdTextures[currFlapPos.rawValue].size().height * 3
            )
        )

        playerSprite.physicsBody?.mass = 1
        playerSprite.physicsBody?.isDynamic = true
        playerSprite.physicsBody?.restitution = 0
        playerSprite.physicsBody?.angularDamping = 1
        playerSprite.physicsBody?.categoryBitMask = playerCategory
        playerSprite.physicsBody?.contactTestBitMask = baseAndPipeContact
        playerSprite.physicsBody?.collisionBitMask = baseAndPipeContact
        // so that the bird dont not fall
        playerSprite.physicsBody?.affectedByGravity = false

        var isMiddleAfterDown = false
        Timer.scheduledTimer(withTimeInterval: TimeInterval(0.1), repeats: true, block: {_ in

            /*
             bird's wing animation cycle
             
             up
             middle
             down
             middle
             up
             
             */
            if self.isAnimatePlaying {
                switch self.currFlapPos {

                case .top:
                    self.currFlapPos = .middle
                case .middle:

                    if !isMiddleAfterDown {
                        self.currFlapPos = .down
                        isMiddleAfterDown = true
                    } else {
                        self.currFlapPos = .top
                        isMiddleAfterDown = false
                    }

                case .down:
                    self.currFlapPos = .middle

                }

                self.playerSprite.texture = self.birdTexture(skin: self.currentSkin)[self.currFlapPos.rawValue]
            }

        })

    }

    func countIncr() -> Int {
        count += 1
        return count
    }

    private func birdTexture(skin: BirdSkin) -> [SKTexture] {
        switch currentSkin {
        case .blue:
            return self.blueBirdTextures
        case .yellow:
            return self.yellowBirdTextures
        case .red:
            return self.redBirdTextures
        }
    }

    func stopMoving() {
        self.isAnimatePlaying = false
        playerSprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        playerSprite.removeAllActions()
    }

    func restart() {
        self.isAnimatePlaying = true
        playerSprite.position = CGPoint(
            x: scene.position.x - scene.frame.width / 4,
            y: 200
        )
        playerSprite.removeAllActions()
        playerSprite.run(SKAction.rotate(toAngle: 0, duration: 0))
        playerSprite.position.x = scene.position.x - scene.frame.width / 4
        playerSprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        currentSkin.randomChange()
        self.playerSprite.texture = self.birdTexture(skin: self.currentSkin)[self.currFlapPos.rawValue]
        count = 0
    }

    func touchesBegan() {
        playerSprite.physicsBody?.affectedByGravity = true

        playerSprite.removeAction(forKey: "RotateUp")
        playerSprite.run(rotateUp, withKey: "RotateUp")

        playerSprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        playerSprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1000))

    }

    func touchesEnded() {
        playerSprite.removeAction(forKey: "RotateDown")
        playerSprite.run(rotateDown, withKey: "RotateDown")
    }

}
