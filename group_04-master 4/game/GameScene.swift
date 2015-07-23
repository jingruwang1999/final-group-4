//
//  GameScene.swift
//  collisions
//
//  Created by Martin Jaroszewicz on 7/20/15.
//  Copyright (c) 2015 com.jaroszewicz. All rights reserved.
//

import SpriteKit
import UIKit
import CoreMotion
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
   // let wall1 = NSBundle.mainBundle().URLForResource("Clarinetmono",withExtension:"wav")
   // let wall2 = NSBundle.mainBundle().URLForResource("dubstep1mono",withExtension:"wav")
    var audioplayer:AVAudioPlayer? = AVAudioPlayer()
    
    let motionManager = CMMotionManager()
    
    
    let mySprite : SKSpriteNode =  SKSpriteNode(color: SKColor(red: 1, green: 0.6, blue: 0.7, alpha: 1), size: CGSizeMake(40,40))
    
    var wTop : [SKSpriteNode] = [SKSpriteNode]()
    var wBottom : [SKSpriteNode] = [SKSpriteNode]()
    var wLeft : [SKSpriteNode] = [SKSpriteNode]()
    var wRight : [SKSpriteNode] = [SKSpriteNode]()
    
    var lastSpawnTimeInterval:CFTimeInterval = 0
    var lastUpdateTimeInterval:CFTimeInterval = 0
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.whiteColor()
        //     physicsWorld.gravity = CGVectorMake(gravityX, gravityY)
        physicsWorld.contactDelegate = self
        
        addWalls()
        addSprite()
        startAccelerationCollection()
        
    }
    
    func startAccelerationCollection()->Void{
        var speedOfGravity : Double = 20
        motionManager.deviceMotionUpdateInterval = 0.01
        motionManager.startAccelerometerUpdates()
        if motionManager.accelerometerAvailable{
            let queue = NSOperationQueue()
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler:
                {(data: CMAccelerometerData!, error: NSError!) in
                    self.physicsWorld.gravity.dx = CGFloat(data.acceleration.x*speedOfGravity)
                    self.physicsWorld.gravity.dy = CGFloat(data.acceleration.y*speedOfGravity)
                    
            })
        }else{
            println("Accelerometer is not available")
        }
    }
    
    
    
    func addWalls(){
        var x: Int
        var random1, random2, random3: Float
    
        for x = 0; x < 4; ++x {
            random1 = Float(arc4random()) / 0xFFFFFFFF
            random2 = Float(arc4random()) / 0xFFFFFFFF
            random3 = Float(arc4random()) / 0xFFFFFFFF
            
            wBottom.append(SKSpriteNode(color: SKColor(red: CGFloat(random1), green: CGFloat(random2), blue: CGFloat(random3), alpha: 1), size: CGSizeMake(256,50)))
            
            wBottom[x].position = CGPoint(x: x*256+(256/2), y: 25)
            wBottom[x].name = "wallbottom\(x)"
            self.addChild(wBottom[x])
            wBottom[x].physicsBody = SKPhysicsBody(rectangleOfSize: wBottom[x].size)
            wBottom[x].physicsBody?.dynamic = false
            wBottom[x].physicsBody?.contactTestBitMask = PhysicsCategory.Ball
            wBottom[x].physicsBody?.collisionBitMask = PhysicsCategory.None
        }
        for x = 0; x < 4; ++x {
            random1 = Float(arc4random()) / 0xFFFFFFFF
            random2 = Float(arc4random()) / 0xFFFFFFFF
            random3 = Float(arc4random()) / 0xFFFFFFFF
            
            wTop.append(SKSpriteNode(color: SKColor(red: CGFloat(random1), green: CGFloat(random2), blue: CGFloat(random3), alpha: 1), size: CGSizeMake(256,50)))
            
            wTop[x].position = CGPoint(x: Int(x*256+(256/2)), y: Int(size.height - 25))
            wTop[x].name = "walltop\(x)"
            self.addChild(wTop[x])
            wTop[x].physicsBody = SKPhysicsBody(rectangleOfSize: wTop[x].size)
            wTop[x].physicsBody?.dynamic = false
            wTop[x].physicsBody?.contactTestBitMask = PhysicsCategory.Ball
            wTop[x].physicsBody?.collisionBitMask = PhysicsCategory.None
        }
        
        for x = 0; x < 4; ++x {
            random1 = Float(arc4random()) / 0xFFFFFFFF
            random2 = Float(arc4random()) / 0xFFFFFFFF
            random3 = Float(arc4random()) / 0xFFFFFFFF
            
            wLeft.append(SKSpriteNode(color: SKColor(red: CGFloat(random1), green: CGFloat(random2), blue: CGFloat(random3), alpha: 1), size: CGSizeMake(50,196)))
            
            wLeft[x].position = CGPoint(x: 25, y: Int(x*192+(192/2)))
            wLeft[x].name = "wallleft\(x)"
            self.addChild(wLeft[x])
            wLeft[x].physicsBody = SKPhysicsBody(rectangleOfSize: wLeft[x].size)
            wLeft[x].physicsBody?.dynamic = false
            wLeft[x].physicsBody?.contactTestBitMask = PhysicsCategory.Ball
            wLeft[x].physicsBody?.collisionBitMask = PhysicsCategory.None
        }
        
        for x = 0; x < 4; ++x {
            random1 = Float(arc4random()) / 0xFFFFFFFF
            random2 = Float(arc4random()) / 0xFFFFFFFF
            random3 = Float(arc4random()) / 0xFFFFFFFF
            
            wRight.append(SKSpriteNode(color: SKColor(red: CGFloat(random1), green: CGFloat(random2), blue: CGFloat(random3), alpha: 1), size: CGSizeMake(50,196)))
            
            wRight[x].position = CGPoint(x: Int(size.width-25), y: Int(x*192)+(192/2))
            wRight[x].name = "wallright\(x)"
            self.addChild(wRight[x])
            wRight[x].physicsBody = SKPhysicsBody(rectangleOfSize: wRight[x].size)
            wRight[x].physicsBody?.dynamic = false
            wRight[x].physicsBody?.contactTestBitMask = PhysicsCategory.Ball
            wRight[x].physicsBody?.collisionBitMask = PhysicsCategory.None
        }
    }
    
    
    func addSprite(){
        mySprite.position = CGPoint(x: 200, y: size.height/2)
        self.addChild(mySprite)
        mySprite.physicsBody = SKPhysicsBody(rectangleOfSize: mySprite.size)
        mySprite.physicsBody?.linearDamping = 0
        mySprite.physicsBody?.mass = 1
        mySprite.physicsBody?.restitution = 0.5
        //mySprite.physicsBody?.allowsRotation = false
        mySprite.physicsBody?.dynamic = true
        mySprite.physicsBody?.contactTestBitMask = PhysicsCategory.Walls
        mySprite.physicsBody?.collisionBitMask = PhysicsCategory.Ball
    }
    
    func ballDidCollideWithWall(ball:SKSpriteNode, wall:SKSpriteNode) {
        println(wall.name!)
        var sound = NSBundle.mainBundle().URLForResource(wall.name!,withExtension:"wav")
        playSound(sound!)
        
    }

    func playSound(soundfile: NSURL){
        var error: NSError?
        audioplayer = AVAudioPlayer(contentsOfURL: soundfile, error: &error)
        if let audioplayer = audioplayer {
            audioplayer.prepareToPlay()
            audioplayer.play()
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.Walls != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Ball != 0)) {
                ballDidCollideWithWall(firstBody.node as! SKSpriteNode, wall: secondBody.node as! SKSpriteNode)
        }
        
    }
    
}

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Walls   : UInt32 = 0b1       // 1
    static let Ball: UInt32 = 0b10      // 2
}