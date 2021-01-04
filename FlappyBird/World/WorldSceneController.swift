//
//  WorldSceneController.swift
//  FlappyBird
//
//  Created by Савелий Никулин on 26.12.2020.
//

import SpriteKit
import AVKit

class WorldSceneController {

    private enum GameAction {
        case gameOver, restart
    }
    
    private enum SoundEffect {
        case Die, Hit, Point, Swooshing, Wing
    }

    private var worldScene: WorldScene

    public var isGameOver: Bool = false
    public var isGameStarted: Bool = false
    public let worldSpeed: CGFloat = 8

    private let pipeCategory: UInt32 = 0x1 << 2
    private let baseCategory: UInt32 = 0x1 << 3
    
    private let soundStartGame = SKAction.playSoundFileNamed("sfx_swooshing", waitForCompletion: false)
    private let soundDie = SKAction.playSoundFileNamed("sfx_die", waitForCompletion: false)
    private let soundHit = SKAction.playSoundFileNamed("sfx_hit", waitForCompletion: false)
    private let soundPoint = SKAction.playSoundFileNamed("sfx_point", waitForCompletion: false)
    private let soundWing = SKAction.playSoundFileNamed("sfx_wing", waitForCompletion: false)

    init(worldScene: WorldScene) {

        self.worldScene = worldScene

    }

    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameStarted {
            isGameStarted = true
            worldScene.userInterface.firstLaunchText(show: false)
            playSound(soundEffect: .Swooshing)
        }

        if !isGameOver {
            worldScene.player.touchesBegan()
        }
        // if user was clicked on first launch or reset button then sound will not play
        if !worldScene.hasActions() && !isGameOver {
            playSound(soundEffect: .Wing)
        }
    }

    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        for index in touches {
            let locate = index.location(in: self.worldScene)

            // If user pressed on the 'Restart' button
            if worldScene.userInterface.getPlayButtonSprite.contains(locate)
                && isGameOver {
                // restartGame()
                gameAction(action: .restart)
                playSound(soundEffect: .Swooshing)
            }

        }

        if !isGameOver {
            worldScene.player.touchesEnded()
        }

    }

    func didBegin(_ contact: SKPhysicsContact) {
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        switch collision {
        case worldScene.player.playerCategory | pipeCategory:
            if !isGameOver {
                playSound(soundEffect: .Hit)
                playSound(soundEffect: .Die)
            }
            gameAction(action: .gameOver)
        case worldScene.player.playerCategory | baseCategory:
            if !isGameOver { playSound(soundEffect: .Hit) }
            gameAction(action: .gameOver)
        case worldScene.player.playerCategory | 0x1 << 4:
            worldScene.pipesGenerator.collisionHiddenRect(action: {
                self.worldScene.userInterface.setCountValue(value: self.worldScene.player.countIncr())
                self.playSound(soundEffect: .Point)
            })
        default: break
        }
    }

    func update(_ currentTime: TimeInterval) {
        if !isGameOver {

            worldScene.base.baseMoving()

            // If it's first lauch then pipes dont moving
            if isGameStarted {
                worldScene.pipesGenerator.pipesMoving()
            }
        }
    }

    private func gameAction(action: GameAction) {
        isGameOver = (action == .gameOver) ? true : false
        action == .gameOver ? worldScene.base.stopMoving() : worldScene.base.restart()
        action == .gameOver ? worldScene.pipesGenerator.stopMoving() : worldScene.pipesGenerator.restart()
        action == .gameOver ? worldScene.player.stopMoving() : worldScene.player.restart()
        action == .gameOver ? worldScene.userInterface.flash() : switchDayNight()
        worldScene.userInterface.setCounterPosition(pos: (action == .gameOver) ? .afterFall : .default1)
        worldScene.userInterface.gameOverText(show: (action == .gameOver) ? true : false)
        worldScene.userInterface.playButtonShow(show: (action == .gameOver) ? true : false)
        guard action == .restart else { return }
        worldScene.userInterface.setCountValue(value: 0)
    }

    func switchDayNight() {

        let rand = Int.random(in: -2...(-1))
        worldScene.backgroundDay.zPosition = CGFloat(rand)

    }
    
    private func playSound(soundEffect: SoundEffect) {
        switch soundEffect {
        case .Die:
            worldScene.run(soundDie)
        case .Hit:
            worldScene.run(soundHit)
        case .Point:
            worldScene.run(soundPoint)
        case .Swooshing:
            worldScene.run(soundStartGame)
        case .Wing:
            worldScene.run(soundWing)
        }
    }
    
}
