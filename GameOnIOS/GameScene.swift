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
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        makeBouncer(at: CGPoint(x: 0, y: 22))
        makeBouncer(at: CGPoint(x: 256, y: 22))
        makeBouncer(at: CGPoint(x: 512, y: 22))
        makeBouncer(at: CGPoint(x: 768, y: 22))
        makeBouncer(at: CGPoint(x: 1024, y: 22))
        
        makeSlot(at: CGPoint(x: 128, y: 22), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 22), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 22), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 22), isGood: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let ball = SKSpriteNode(imageNamed: "ballRed")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        ball.physicsBody?.restitution = 0.4
        ball.position = location
        addChild(ball)
    }
    
    func makeBouncer(at position: CGPoint){
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool){
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood{
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 7)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
}
