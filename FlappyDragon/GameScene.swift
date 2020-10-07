//
//  GameScene.swift
//  FlappyDragon
//
//  Created by Vinícius Tinajero Salomão on 05/10/20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var floor: SKSpriteNode!
    var intro: SKSpriteNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var gameArea: CGFloat = 410.0
    var velocity: Double = 100.0
    var score: Int = 0
    var flyForce: CGFloat = 30.0
    
    var gameFinished = false
    var gameStarted = false
    var restart = false
    
    override func didMove(to view: SKView) {
        addBackground()
        addFloor()
        addIntro()
        addPlayer()
        moveFloor()
    }
    
    func addBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0
        addChild(background)
    }
    
    func addFloor() {
        floor = SKSpriteNode(imageNamed: "floor")
        floor.zPosition = 2
        floor.position = CGPoint(x: floor.size.width / 2, y: size.height - gameArea - floor.size.height / 2)
        addChild(floor)
    }
    
    func addIntro() {
        intro = SKSpriteNode(imageNamed: "intro")
        intro.zPosition = 3
        intro.position = CGPoint(x: size.width / 2, y: size.height - 210)
        addChild(intro)
    }
    
    func addPlayer() {
        player = SKSpriteNode(imageNamed: "player1")
        player.zPosition = 4
        player.position = CGPoint(x: 80, y: size.height - gameArea / 2)
        
        var playerTextures = [SKTexture]()
        for i in 1...4 {
            playerTextures.append(SKTexture(imageNamed: "player\(i)"))
        }
        
        let animationAction = SKAction.animate(with: playerTextures, timePerFrame: 0.09)
        let repeatAction = SKAction.repeatForever(animationAction)
        player.run(repeatAction)
        
        addChild(player)
    }
    
    func moveFloor() {
        let duration = Double(floor.size.width / 2) / velocity
        let moveFloorAction = SKAction.moveBy(x: -floor.size.width / 2, y: 0, duration: duration)
        let resetXAction = SKAction.moveBy(x: floor.size.width / 2, y: 0, duration: 0)
        let sequenceAction = SKAction.sequence([moveFloorAction, resetXAction])
        let repeatAction = SKAction.repeatForever(sequenceAction)
        
        floor.run(repeatAction)
    }
    
    func addScore() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontSize = 94
        scoreLabel.text = "\(score)"
        scoreLabel.zPosition = 5
        scoreLabel.alpha = 0.8
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 100)
        
        addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameFinished {
            if !gameStarted {
                intro.removeFromParent()
                addScore()
                
                player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2 - 10)
                player.physicsBody?.isDynamic = true
                player.physicsBody?.allowsRotation = true
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce))
                
                gameStarted = true
                
            } else {
                player.physicsBody?.velocity = CGVector.zero
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce))

            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if gameStarted {
            let yVelocity = player.physicsBody!.velocity.dy * 0.001 as CGFloat
            player.zRotation = yVelocity
        }
    }
}
