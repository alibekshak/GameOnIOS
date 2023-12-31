//
//  GameScene.swift
//  GameOnIOS
//
//  Created by Apple on 11.12.2023.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLable: SKLabelNode!
    var score = 0 {
        didSet{
            scoreLable.text = "Score \(score)"
        }
    }
    
    var editLable: SKLabelNode!
    
    var balls = ["ballBlue", "ballGreen", "ballGrey", "ballRed", "ballYellow", "ballPurple", "ballCyan"]
    
    var editingMode: Bool = false {
        didSet{
            if editingMode{
                editLable.text = "Done"
            } else {
                editLable.text = "Edit"
            }
        }
    }

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLable = SKLabelNode(fontNamed: "")
        scoreLable.text = "Score: 0"
        scoreLable.horizontalAlignmentMode = .right
        scoreLable.position = CGPoint(x: 980, y: 700)
        addChild(scoreLable)
        
        editLable = SKLabelNode(fontNamed: "")
        editLable.text = "Edit"
        editLable.position = CGPoint(x: 80, y: 700)
        addChild(editLable)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 128, y: 22), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 22), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 22), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 22), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 22))
        makeBouncer(at: CGPoint(x: 256, y: 22))
        makeBouncer(at: CGPoint(x: 512, y: 22))
        makeBouncer(at: CGPoint(x: 768, y: 22))
        makeBouncer(at: CGPoint(x: 1024, y: 22))
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let objects = nodes(at: location)
        
        if objects.contains(editLable){
            editingMode.toggle()
        } else {
            if editingMode{
                let size = CGSize(width: Int.random(in: 12...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green:  CGFloat.random(in: 0...1), blue:  CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                addChild(box)
            } else{
                let ball = SKSpriteNode(imageNamed: balls.randomElement() ?? "ballRed")
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                ball.physicsBody?.restitution = 0.4
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                ball.position = location
                ball.name = "ball"
                addChild(ball)
            }
        }
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
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 7)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collision(between ball: SKNode, object: SKNode){
        if object.name == "good"{
            destroy(ball: ball)
            score += 1
        } else if object.name == "bad"{
            destroy(ball: ball)
            if score > 0{
                score -= 1
            }
        }
    }
    
    func  destroy(ball: SKNode){
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles"){
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball"{
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball"{
            collision(between: nodeB, object: nodeA)
        }
    }
}
