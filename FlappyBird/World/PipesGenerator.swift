//
//  PipesGenerator.swift
//  FlappyBird
//
//  Created by Савелий Никулин on 22.12.2020.
//

import SpriteKit

class PipesGenerator {

    private var pipeTexture: SKTexture!
    private var pipeLowerSprites: [SKSpriteNode] = []
    private var pipeHigherSprites: [SKSpriteNode] = []
    private let pipeCount = 3

    // Distance between Lower and Higher pipe
    private let distBetLowHighPipe: Int = 1300
    // Distance between pipes
    private let distBetPipes: Int = 500
    // Distance to the first pipe
    private let distToFirstPipe: Int = 1000

    private let pipeGeneratorRange = -800...(-300)

    private let pipeCategory: UInt32 = 0x1 << 2

    var spritesLower: [SKSpriteNode] { pipeLowerSprites }

    var spritesHigher: [SKSpriteNode] { pipeHigherSprites }

    var worldSpeed: CGFloat!
    var scene: SKScene!

    // if player collide with rect then player.count += 1
    public var hiddenRect: SKShapeNode!

    init(scene: SKScene, worldSpeed: CGFloat) {

        self.worldSpeed = worldSpeed
        self.scene = scene

        pipeTexture = SKTexture(imageNamed: "pipe-green")

        for _ in 0..<pipeCount {
            pipeLowerSprites.append(SKSpriteNode(texture: pipeTexture))
            pipeHigherSprites.append(SKSpriteNode(texture: pipeTexture))
        }

        initHiddenRect()

        pipeLowerSprites = pipeLowerSprites.enumerated().map { (index, item) -> SKSpriteNode in

            let posX: CGFloat = CGFloat(distToFirstPipe + index * self.distBetPipes)
            let posY: CGFloat = CGFloat(Int.random(in: pipeGeneratorRange))

            return initPipe(item: item, posX: posX, posY: posY, category: pipeCategory)
        }

        pipeHigherSprites = pipeHigherSprites.enumerated().map { (index, item) -> SKSpriteNode in

            let posX: CGFloat = CGFloat(distToFirstPipe + index * self.distBetPipes)
            // Getting 'y' from pipeLowerSprites[index].pos.y
            let posY: CGFloat = pipeLowerSprites[index].position.y + CGFloat(self.distBetLowHighPipe)

            let result = initPipe(item: item, posX: posX, posY: posY, category: pipeCategory)
            result.run(SKAction.rotate(toAngle: CGFloat.pi, duration: 0))

            return result
        }

        let posY = (pipeLowerSprites[0].position.y + pipeHigherSprites[0].position.y) / 2
        hiddenRect.position = CGPoint(x: CGFloat(distToFirstPipe), y: posY)

    }

    private var isGot = false
    private var currPipeIndex = 1 // index of the pipe that the player passed through
    func collisionHiddenRect(action: @escaping () -> Void) {

        if !isGot {
            // Set new hidden rect position
            let posX = pipeLowerSprites[currPipeIndex].position.x
            // Set new 'y' by arithmetic mean pipeLowerSprite.y and pipeHigherSprite.y
            let posY = (pipeLowerSprites[currPipeIndex].position.y + pipeHigherSprites[currPipeIndex].position.y) / 2
            let move = SKAction.move(to: CGPoint(x: posX, y: posY), duration: 0.01)

            if currPipeIndex == (pipeCount - 1) { currPipeIndex = 0 } else { self.currPipeIndex += 1 }

            hiddenRect.run(move, completion: {
                self.isGot = false
                action()
            })
            isGot = true
        }

    }

    func stopMoving() {
        self.worldSpeed = 0
    }

    func restart() {
        self.worldSpeed = 7
        for index in 0..<pipeCount {
            let randY = Int.random(in: pipeGeneratorRange)
            pipeLowerSprites[index].position = CGPoint(x: distToFirstPipe + index * distBetPipes, y: randY)
            pipeHigherSprites[index].position = CGPoint(x: distToFirstPipe + index * distBetPipes, y: randY + distBetLowHighPipe)
        }
        let posY = (pipeLowerSprites[0].position.y + pipeHigherSprites[0].position.y) / 2
        hiddenRect.position = CGPoint(x: CGFloat(distToFirstPipe), y: posY)
        currPipeIndex = 1
        isGot = false
    }

    func pipesMoving() {

        // Moving Lower pipes
        pipeLowerSprites = pipeLowerSprites.map({ (item) -> SKSpriteNode in

            // Move pipe which went off-screen
            if item.position.x < -self.scene.size.width + 156 {
                let randY = Int.random(in: pipeGeneratorRange)
                item.position = CGPoint(
                    x: Int(item.position.x) + (distBetPipes * 3),
                    y: randY)
            }

            item.position.x -= self.worldSpeed
            return item
        })

        // Moving Higher pipes
        pipeHigherSprites = pipeHigherSprites.enumerated().map({ (index, item) -> SKSpriteNode in

            // Move pipe which went off-screen
            if item.position.x < -self.scene.size.width + 156 {
                item.position = CGPoint(
                    x: Int(item.position.x) + (distBetPipes * 3),
                    y: Int(pipeLowerSprites[index].position.y) + distBetLowHighPipe
                )
            }

            item.position.x -= self.worldSpeed
            return item
        })

        // Moving hidden rect
        hiddenRect.position.x -= self.worldSpeed
    }

    private func initHiddenRect() {
        hiddenRect = SKShapeNode(rect: CGRect(x: -50, y: -distBetPipes / 2, width: 100, height: distBetPipes))
        hiddenRect.strokeColor = .clear
        hiddenRect.physicsBody = SKPhysicsBody(rectangleOf: hiddenRect.frame.size)
        self.turnOffPhysics(node: hiddenRect)
        hiddenRect.physicsBody?.categoryBitMask = 0x1 << 4
        hiddenRect.physicsBody?.contactTestBitMask = 0x1 << 1
    }

    private func initPipe(item: SKSpriteNode, posX: CGFloat, posY: CGFloat, category: UInt32) -> SKSpriteNode {

        item.position = CGPoint(
            x: posX,
            y: posY
        )
        item.zPosition = 0
        item.setScale(3)

        item.physicsBody = SKPhysicsBody(texture: item.texture!,
            size: CGSize(
                width: item.frame.width,
                height: item.frame.height
            )
        )

        self.turnOffPhysics(node: item)
        item.physicsBody?.categoryBitMask = category

        return item
    }

    private func turnOffPhysics(node: SKNode) {
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.isDynamic = false
    }

}
