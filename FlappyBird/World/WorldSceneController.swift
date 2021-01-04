//
//  WorldSceneController.swift
//  FlappyBird
//
//  Created by Савелий Никулин on 26.12.2020.
//

import SpriteKit

class WorldSceneController {

    private enum GameAction {
        case gameOver, restart
    }

    private var worldScene: WorldScene

    public var isGameOver: Bool = false
    public var isGameStarted: Bool = false
    public let worldSpeed: CGFloat = 8

    private let pipesAndBaseCategory: UInt32 = 0x1 << 2

    init(worldScene: WorldScene) {

        self.worldScene = worldScene

    }

    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameStarted {
            isGameStarted = true
            worldScene.userInterface.firstLaunchText(show: false)
        }

        if !isGameOver {
            worldScene.player.touchesBegan()
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
            }

        }

        if !isGameOver {
            worldScene.player.touchesEnded()
        }

    }

    func didBegin(_ contact: SKPhysicsContact) {
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        switch collision {
        case worldScene.player.playerCategory | pipesAndBaseCategory:
            gameAction(action: .gameOver)
        case worldScene.player.playerCategory | 0x1 << 4:
            worldScene.pipesGenerator.collisionHiddenRect(action: {
                self.worldScene.userInterface.setCountValue(value: self.worldScene.player.countIncr())
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
}
