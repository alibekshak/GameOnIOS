//
//  GameScene.swift
//  GameOnIOS
//
//  Created by Apple on 11.12.2023.
//

import SpriteKit

class GameScene: SKScene {

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        addChild(background)
    }
}
