//
//  GameScene.swift
//  FlappyBird
//
//  Created by Савелий Никулин on 21.12.2020.
//

import SpriteKit
import GameplayKit

class WorldScene: SKScene, SKPhysicsContactDelegate {

    var base: Base!
    var player: Player!
    var pipesGenerator: PipesGenerator!
    var userInterface: UserInterface!
    var worldSceneController: WorldSceneController!

    public var backgroundDay: SKSpriteNode!
    private var backgroundNight: SKSpriteNode!

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -20)

        worldSceneController = WorldSceneController(worldScene: self)

        base = Base(scene: self, worldSpeed: worldSceneController.worldSpeed)
        player = Player(scene: self)
        pipesGenerator = PipesGenerator(scene: self, worldSpeed: worldSceneController.worldSpeed)
        userInterface = UserInterface(scene: self)

        backgroundDay = self.childNode(withName: "backgroundDay") as? SKSpriteNode
        backgroundNight = self.childNode(withName: "backgroundNight") as? SKSpriteNode

        for index in pipesGenerator.spritesLower {
            self.addChild(index)
        }

        for index in pipesGenerator.spritesHigher {
            self.addChild(index)
        }

        for index in base.sprites {
            self.addChild(index)
        }

        self.addChild(player.sprite)
        self.addChild(userInterface.getGameOverSprite)
        self.addChild(userInterface.getFirstLaunchSprite)
        self.addChild(userInterface.getPlayButtonSprite)
        self.addChild(pipesGenerator.hiddenRect)
        self.addChild(userInterface.getCounterSprite)
        self.addChild(userInterface.getFlashRect)

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        worldSceneController.touchesBegan(touches, with: event)

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        worldSceneController.touchesEnded(touches, with: event)
    }

    override func update(_ currentTime: TimeInterval) {
        worldSceneController.update(currentTime)
    }

    func didBegin(_ contact: SKPhysicsContact) {
        worldSceneController.didBegin(contact)
    }

}
