//
//  game.swift
//  Phantasm
//
//  Created by Chris T Stuart on 1/14/16.
//  Copyright © 2016 Chris T Stuart. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit


struct physicsCategories {
    
    static let playerCategory : UInt32 = 0x1<<0
    static let enemyCategory : UInt32  = 0x1<<1
    static let bullet : UInt32 = 0x1<<2
    static let floor : UInt32 = 0x1<<3
    static let box : UInt32 = 0x1<<4
    static let spike : UInt32 = 0x1<<5
    
    static let playerCategoryName : String = "player"
    static let enemyCategoryName : String = "enemy"
    static let bulletCategoryName : String = "bullet"
    static let floorCategoryName : String = "floor"
    static let boxCategoryName : String = "box"
    static let spikeCategoryName : String = "spike"
    
}




class game: SKScene, SKPhysicsContactDelegate,UIGestureRecognizerDelegate {
    
    var forwardMarch: Bool?
    var mightAsWellJump: Bool?
    
    var initial: CGPoint?
    
    // var camera1 = SKCameraNode()
    
    var player = SKSpriteNode()
    var ground = SKSpriteNode()
    var ground1 = SKSpriteNode()
    var ground3 = SKSpriteNode()
    var ground4 = SKSpriteNode()
    var tree = SKSpriteNode()
    var pause1 = SKLabelNode()
    var pauseState = false
    var box = SKSpriteNode()
    var swipeUp = UISwipeGestureRecognizer()
    var lpgr = UILongPressGestureRecognizer()
    var audioAction:SKAction = SKAction()
    var dropAudioAction:SKAction = SKAction()
    var walkingAudioAction = SKAction()
    
    var gameCenterAchievements = [String: GKAchievement]()
    
    let playerActionAtack: SKAction = SKAction.animateWithTextures([SKTexture(imageNamed: "frame-1a"),SKTexture(imageNamed: "frame-2a"),SKTexture(imageNamed: "frame-3a"),SKTexture(imageNamed: "frame-4a")], timePerFrame: 0.09, resize: true, restore: true)
    
    let playerActionRunning: SKAction = SKAction.animateWithTextures([SKTexture(imageNamed: "frame1-1"),SKTexture(imageNamed: "frame2-2"),SKTexture(imageNamed: "frame3-3"),SKTexture(imageNamed: "frame4-4"),SKTexture(imageNamed: "frame5-5"),SKTexture(imageNamed: "frame6-6")], timePerFrame: 0.11, resize: true, restore:  true)
    
    
    let playerAction: SKAction = SKAction.animateWithTextures([SKTexture(imageNamed: "frame-1"),SKTexture(imageNamed: "frame-2"),SKTexture(imageNamed: "frame-3"),SKTexture(imageNamed: "frame-4"),SKTexture(imageNamed: "frame-5"),SKTexture(imageNamed: "frame-7"),SKTexture(imageNamed: "frame-8"),SKTexture(imageNamed: "frame-9")], timePerFrame: 0.1, resize: true, restore:  true)
    
    override func didMoveToView(view: SKView) {
        
        // runAction(SKAction.repeatActionForever(SKAction.playSoundFileNamed("bgmusic.wav", waitForCompletion: true)))
        
        
        //  self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -7.0)
        self.physicsWorld.contactDelegate = self
        
        
        audioAction = SKAction.playSoundFileNamed("jump", waitForCompletion: true)
        dropAudioAction = SKAction.playSoundFileNamed("drop", waitForCompletion: true)
        walkingAudioAction = SKAction.playSoundFileNamed("walking", waitForCompletion: true)
        
        //self.physicsBody!.friction = 0.0;
        
        player = childNodeWithName("player") as! SKSpriteNode
        
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.dynamic = true
        player.physicsBody!.categoryBitMask = physicsCategories.playerCategory
        player.physicsBody!.collisionBitMask = physicsCategories.floor | physicsCategories.box
        player.physicsBody?.contactTestBitMask = physicsCategories.box
        player.physicsBody?.usesPreciseCollisionDetection = true
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.allowsRotation = false
        
        pause1 = player.childNodeWithName("pause1") as! SKLabelNode
        pause1.name = "pause"
        
        
        
        
        ground = childNodeWithName("ground") as! SKSpriteNode
        
        ground.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "rzs_1ground"), size: CGSize(width: 700, height: 150))
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.pinned = true
        ground.physicsBody?.dynamic = true
        ground.physicsBody?.categoryBitMask = physicsCategories.floor
        ground.physicsBody?.collisionBitMask = physicsCategories.playerCategory
        ground.physicsBody?.allowsRotation = false
        ground.physicsBody?.friction = 0.7
        
        
        
        ground1 = childNodeWithName("ground2") as! SKSpriteNode
        
        ground1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "rzs_1ground"), size: CGSize(width: 700, height: 150))
        ground1.physicsBody?.affectedByGravity = false
        ground1.physicsBody?.pinned = true
        ground1.physicsBody?.dynamic = true
        ground1.physicsBody?.categoryBitMask = physicsCategories.floor
        ground1.physicsBody?.collisionBitMask = physicsCategories.playerCategory
        ground1.physicsBody?.allowsRotation = false
        ground1.physicsBody?.friction = 0.7
        
        
        
        ground3 = childNodeWithName("ground3") as! SKSpriteNode
        
        ground3.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "rzs_1ground"), size: CGSize(width: 700, height: 150))
        ground3.physicsBody?.affectedByGravity = false
        ground3.physicsBody?.pinned = true
        ground3.physicsBody?.dynamic = false
        ground3.physicsBody?.categoryBitMask = physicsCategories.floor
        ground3.physicsBody?.collisionBitMask = physicsCategories.playerCategory
        ground3.physicsBody?.allowsRotation = false
        ground3.physicsBody?.friction = 0.7
        
        
        
        ground4 = childNodeWithName("ground4") as! SKSpriteNode
        
        ground4.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "rzs_1ground"), size: CGSize(width: 500, height: 150))
        ground4.physicsBody?.affectedByGravity = false
        ground4.physicsBody?.pinned = true
        ground4.physicsBody?.dynamic = false
        ground4.physicsBody?.categoryBitMask = physicsCategories.floor
        ground4.physicsBody?.collisionBitMask = physicsCategories.playerCategory
        ground4.physicsBody?.allowsRotation = false
        ground4.physicsBody?.friction = 0.7
        
        tree = childNodeWithName("tree") as! SKSpriteNode
        
        tree.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Treetrunk 1"), size: CGSize(width: 500, height: 180))
        tree.physicsBody?.affectedByGravity = false
        tree.physicsBody?.dynamic = false
        tree.physicsBody?.allowsRotation = false
        tree.physicsBody?.pinned = true
        tree.physicsBody?.friction = 0.7
        
        box = childNodeWithName("box") as! SKSpriteNode
        
        box.physicsBody?.categoryBitMask = physicsCategories.box
        box.physicsBody?.contactTestBitMask = physicsCategories.playerCategory
        box.physicsBody?.pinned = true
        
        
        
        lpgr = UILongPressGestureRecognizer(target: self, action: #selector(game.handleLongPress(_:)))
        lpgr.minimumPressDuration = 0.3
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        view.addGestureRecognizer(lpgr)
        
        view.multipleTouchEnabled = true
        
        
        
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(game.swipedUp(_:)))
        swipeUp.direction = .Up
        swipeUp.delaysTouchesBegan = true
        
        view.addGestureRecognizer(swipeUp)
        

        
        loadAch()
        
        
    }
    
    
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let name = self.nodeAtPoint(location)
            
            if name.name == "pause" {
                
                if view?.paused == false {
                    
                    runAction(SKAction.runBlock({ () -> Void in
                        self.pause1.text = "Play"
                        myMusicPlayer?.pause()
                        //self.player.removeAllActions()
                        self.swipeUp.enabled = false
                        self.lpgr.enabled = false
                        
                    }))
                    
                    runAction(SKAction.runBlock({ () -> Void in
                        self.view?.paused = true
                        
                    }))
                    
                    
                } else if view?.paused == true {
                    
                    self.pause1.text = "Pause"
                    self.view?.paused = false
                    myMusicPlayer?.play()
                    self.swipeUp.enabled = true
                    self.lpgr.enabled = true
                    
                    
                }
                
                
                
            }
            
        }
        
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        
        
        
        self.runAction(audioAction)
        
        
        
        lpgr.enabled = false
        self.swipeUp.enabled = false
        //pause1.userInteractionEnabled = false
        
        player.runAction(SKAction.sequence([SKAction.animateWithTextures([SKTexture(imageNamed: "jump")], timePerFrame: 0.4, resize: true, restore: true),SKAction.animateWithTextures([SKTexture(imageNamed: "jumpdown")], timePerFrame: 0.5, resize: true, restore: true), SKAction.runBlock({ () -> Void in
            self.runAction(self.dropAudioAction)
            self.swipeUp.enabled = true
            self.lpgr.enabled = true
            // self.pause1.userInteractionEnabled = true
        })]))
        
        
        
        
        player.physicsBody?.applyImpulse(CGVector(dx: 450, dy: 750))
        
        
        
    }
    
    
    func increment(indent: String, amount: Double) {
        
        if GKLocalPlayer.localPlayer().authenticated {
            
            var currentPercent = false
            
            if gameCenterAchievements.count != 0 {
                
                for (id, achi) in gameCenterAchievements {
                    
                    
                    if id == indent {
                        
                        currentPercent = true
                        
                            var currentPerce = achi.percentComplete
                        
                            achi.showsCompletionBanner = true
                        
                            currentPerce = currentPerce + amount
                        
                        report(indent, amount : currentPerce)
                        
                        break
                        
                    }
                    
                }
                
            }
            
            
            if currentPercent == false {
                
                
                report(indent, amount : amount)
                
                
            }
            
            
        }
        
        
    }
    
    
    func loadAch() {
        
        print("percentage")
        
        GKAchievement.loadAchievementsWithCompletionHandler { (ach, error) -> Void in
            
            
            
            
            if ach != nil {
                
                for i in ach! {
                    
                    if let theA: GKAchievement  = i {
                        
                        self.gameCenterAchievements[theA.identifier!] = theA
                        
                    }
                    
                }
                
                for (id, achiv) in self.gameCenterAchievements {
                    
                    print("\(id) - \(achiv.percentComplete)")
                    
                }
                
            }
            
            
        }
        
    }
    

    
    
    func report(ind:String, amount: Double) {
        
        let achiv = GKAchievement(identifier: ind)
        
        achiv.percentComplete = amount
        
        let achievementArray: [GKAchievement] = [achiv]
        
        GKAchievement.reportAchievements(achievementArray) { (error) -> Void in
            guard error == nil else {
                
                print(error)
                return
                
            }
        }
        
        
        
    }
    
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
       
        
        
        if gestureReconizer.state == .Ended {
            
            player.removeActionForKey("moving")
            player.removeActionForKey("running")
           
            self.lpgr.enabled = true
            
        } else if gestureReconizer.state == .Began {
            
            
            _ = gestureReconizer.locationInView(self.view)
            
            let die = SKAudioNode(fileNamed: "walking.wav")
            
            die.autoplayLooped = false
            addChild(die)
            
            swipeUp.enabled = true
            
            die.runAction(SKAction.play())

            
            player.runAction(SKAction.repeatActionForever(SKAction.sequence([playerActionRunning, SKAction.runBlock({ () -> Void in
                
            })])), withKey: "running")
            

            let movingAction = SKAction.repeatActionForever(SKAction.moveByX(150, y: 0, duration: 0.7))
            
            player.runAction(movingAction, withKey: "moving")
            
            
            print("running")
            
        }
        
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            
        }else {
            
            firstBody = contact.bodyB
            secondBody = contact.bodyA
            
        }
        
        if firstBody.categoryBitMask == physicsCategories.playerCategory && secondBody.categoryBitMask == physicsCategories.box {
            
            let secondScene = Level2(fileNamed: "Level2.sks")
            let transition = SKTransition.fadeWithDuration(1.0)
            secondScene!.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(secondScene!, transition: transition)
            view?.removeGestureRecognizer(lpgr)
            
            increment("tutorial", amount: 50)
            
            
        }  else {
            print("wtf")
        }
        
    }
    
    
    
    override func update(currentTime: CFTimeInterval) {

    }
    
}
