//
//  Level2.swift
//  Phantasm
//
//  Created by Chris T Stuart on 1/16/16.
//  Copyright © 2016 Chris T Stuart. All rights reserved.
//

import SpriteKit
import GameKit
import UIKit

class Level2: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate {
    
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
    var bullet = SKSpriteNode()
    var enemy = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var camera1 = SKCameraNode()
    var smoke = SKEmitterNode()
    var enemyLocation: CGPoint?
    var swipeRight = UISwipeGestureRecognizer()
    var lpgr = UILongPressGestureRecognizer()
    var lives = 2
    var livesNode = SKLabelNode()
    var spike = SKSpriteNode()
    var audioAction:SKAction = SKAction()
    var dropAudioAction:SKAction = SKAction()
    var score = 0
    var last = 0
    
    
    var gameCenterAchievements = [String: GKAchievement]()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let playerActionAtack: SKAction = SKAction.animateWithTextures([SKTexture(imageNamed: "frame-1a"),SKTexture(imageNamed: "frame-2a"),SKTexture(imageNamed: "frame-3a"),SKTexture(imageNamed: "frame-4a")], timePerFrame: 0.15, resize: true, restore: true)
    
    let playerActionRunning: SKAction = SKAction.animateWithTextures([SKTexture(imageNamed: "frame1-1"),SKTexture(imageNamed: "frame2-2"),SKTexture(imageNamed: "frame3-3"),SKTexture(imageNamed: "frame4-4"),SKTexture(imageNamed: "frame5-5"),SKTexture(imageNamed: "frame6-6")], timePerFrame: 0.1, resize: true, restore:  true)
    
    
    let playerAction: SKAction = SKAction.animateWithTextures([SKTexture(imageNamed: "frame-1"),SKTexture(imageNamed: "frame-2"),SKTexture(imageNamed: "frame-3"),SKTexture(imageNamed: "frame-4"),SKTexture(imageNamed: "frame-5"),SKTexture(imageNamed: "frame-7"),SKTexture(imageNamed: "frame-8"),SKTexture(imageNamed: "frame-9")], timePerFrame: 0.1, resize: true, restore:  true)
    
    let enemyDead: SKAction = SKAction.animateWithTextures([SKTexture(imageNamed: "frame-1g"),SKTexture(imageNamed: "frame-2g"),SKTexture(imageNamed: "frame-3g"),SKTexture(imageNamed: "frame-4g")], timePerFrame: 0.3, resize: true, restore: true)
    
    override func didMoveToView(view: SKView) {
        
        last = defaults.integerForKey("last")
        
        // runAction(SKAction.repeatActionForever(SKAction.playSoundFileNamed("bgmusic.wav", waitForCompletion: true)))
        
        print("worked")
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -7.0)
        self.physicsWorld.contactDelegate = self
        
        
        audioAction = SKAction.playSoundFileNamed("jump", waitForCompletion: true)
        dropAudioAction = SKAction.playSoundFileNamed("drop", waitForCompletion: true)
        
        
        //self.physicsBody!.friction = 0.0;
        
        player = childNodeWithName("player") as! SKSpriteNode
        
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.dynamic = true
        player.physicsBody!.categoryBitMask = physicsCategories.playerCategory
        //player.physicsBody!.collisionBitMask = physicsCategories.floor | physicsCategories.box
        player.physicsBody?.contactTestBitMask = physicsCategories.box | physicsCategories.enemyCategory
        player.physicsBody?.usesPreciseCollisionDetection = true
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.allowsRotation = false
        
        pause1 = player.childNodeWithName("pause1") as! SKLabelNode
        pause1.name = "pause"
        
        
        camera1 = player.childNodeWithName("camera") as! SKCameraNode
        
        scoreLabel = camera1.childNodeWithName("score") as! SKLabelNode
        
        livesNode = player.childNodeWithName("lives") as! SKLabelNode
        
        livesNode.text = "Lives: \(lives)"
        
        enemy = childNodeWithName("enemy") as! SKSpriteNode
        
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody?.dynamic = true
        enemy.physicsBody!.categoryBitMask = physicsCategories.enemyCategory
        //player.physicsBody!.collisionBitMask = physicsCategories.floor | physicsCategories.box
        enemy.physicsBody?.contactTestBitMask = physicsCategories.box | physicsCategories.playerCategory | physicsCategories.bullet
        enemy.physicsBody?.usesPreciseCollisionDetection = true
        enemy.physicsBody?.affectedByGravity = true
        enemy.physicsBody?.allowsRotation = false
        
        
        
        ground = childNodeWithName("ground") as! SKSpriteNode
        
        ground.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "rzs_1ground"), size: CGSize(width: 700, height: 150))
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.pinned = true
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = physicsCategories.floor
        ground.physicsBody?.collisionBitMask = physicsCategories.playerCategory
        ground.physicsBody?.allowsRotation = false
        ground.physicsBody?.friction = 0.7
        
        
        
        ground1 = childNodeWithName("ground2") as! SKSpriteNode
        
        ground1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "rzs_1ground"), size: CGSize(width: 700, height: 150))
        ground1.physicsBody?.affectedByGravity = false
        ground1.physicsBody?.pinned = true
        ground1.physicsBody?.dynamic = false
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
        
        
        box = childNodeWithName("box") as! SKSpriteNode
        
        
        spike = childNodeWithName("spikes") as! SKSpriteNode
        
        spike.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "spike A"), size: CGSize(width: 30, height: 5))
        
        spike.name = physicsCategories.spikeCategoryName
        spike.physicsBody?.categoryBitMask = physicsCategories.spike
        spike.physicsBody?.contactTestBitMask = physicsCategories.playerCategory
        spike.physicsBody?.pinned = true
        spike.physicsBody?.dynamic = true
        spike.physicsBody?.affectedByGravity = true
        spike.physicsBody?.allowsRotation = false
        
        
        box.physicsBody?.categoryBitMask = physicsCategories.box
        box.physicsBody?.contactTestBitMask = physicsCategories.playerCategory
        box.physicsBody?.pinned = true
        
        
        
        
        lpgr = UILongPressGestureRecognizer(target: self, action: #selector(Level2.handleLongPress(_:)))
        lpgr.minimumPressDuration = 0.1
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        view.addGestureRecognizer(lpgr)
        
        
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(Level2.swipedUp(_:)))
        swipeUp.direction = .Up
        swipeUp.delaysTouchesBegan = true
        
        view.addGestureRecognizer(swipeUp)
        
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(Level2.swipedRight(_:)))
        swipeRight.direction = .Right
        swipeRight.delaysTouchesBegan = true
        
        view.addGestureRecognizer(swipeRight)
        
        enemy.runAction(SKAction.moveToX(player.position.x, duration: 7.0))
        
        
        view.multipleTouchEnabled = true
        
        
    }
    
    func check () {
        
        switch lives {
            
        case 2:
            print("2")
            increment("noDie", amount: 100)
            
        case 1:
            print("1")
            
            
        default:
            let secondScene = gameOver(fileNamed: "gameOver.sks")
            let transition = SKTransition.fadeWithDuration(1.0)
            secondScene!.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(secondScene!, transition: transition)
            self.lpgr.enabled = true
            increment("gamerOver", amount: 100)
        }
        
    }
    
    func swipedRight(sender:UISwipeGestureRecognizer){
        
        
        let shootBullet = SKAction.runBlock({ () -> Void in
            let bulletNode = self.createBullet()
            
            self.bullet = bulletNode
            
            self.addChild(bulletNode)
            bulletNode.physicsBody?.categoryBitMask = physicsCategories.bullet
            bulletNode.physicsBody?.contactTestBitMask = physicsCategories.enemyCategory | physicsCategories.floor
            bulletNode.physicsBody?.applyImpulse(CGVector(dx: 30.0, dy: 0))
        })
        
        
        
        let shoot = SKAudioNode(fileNamed: "gun.wav")
        
        shoot.autoplayLooped = false
        addChild(shoot)
        
        swipeRight.enabled = false
        
        player.runAction(SKAction.sequence([playerActionAtack,shootBullet,SKAction.runBlock({ () -> Void in
            shoot.runAction(SKAction.play())
            
            print(self.player.frame.size.width)
            self.swipeRight.enabled = true
            
        })]))
        
        
    }
    
    func createBullet() -> SKSpriteNode {
        
        
        let playerPosition = player.position
        
        let bullet = SKSpriteNode(imageNamed: "fire")
        
        bullet.position = CGPointMake(playerPosition.x + player.frame.size.width + 10, playerPosition.y + 70)
        
        bullet.name = physicsCategories.bulletCategoryName
        
        bullet.size.width = 55
        bullet.size.height = 37
        
        bullet.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "newBullet"), size: bullet.size)
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        bullet.physicsBody?.dynamic = true
        bullet.physicsBody?.affectedByGravity = false
        
        
        return bullet
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let name = self.nodeAtPoint(location)
            
            if name.name == "pause" {
                
                if view?.paused == false {
                    
                    runAction(SKAction.runBlock({ () -> Void in
                        self.pause1.text = "Play"
                        self.swipeRight.enabled = false
                        self.swipeUp.enabled = false
                        self.lpgr.enabled = false
                        self.enemy.removeAllActions()
                    }))
                    
                    runAction(SKAction.runBlock({ () -> Void in
                        self.view?.paused = true
                        
                    }))
                    
                    
                    
                } else if view?.paused == true {
                    
                    self.pause1.text = "Pause"
                    self.view?.paused = false
                    self.swipeRight.enabled = true
                    self.swipeUp.enabled = true
                    self.lpgr.enabled = true
                    self.enemy.runAction(SKAction.moveToX(self.player.position.x, duration: 7.0))
                    
                }
                
                
                
            }
            
            
        }
        
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        
        self.runAction(audioAction)
        
        
        
        // lpgr.enabled = false
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
                        
                        achi.percentComplete = 100
                        
                        var currentPerce = achi.percentComplete
                        
                        achi.showsCompletionBanner = true
                        
                        GKNotificationBanner.showBannerWithTitle("Tutorial", message: "You completed the tutorial levels", duration: 1.0, completionHandler: nil)
                        
                        
                        
                        
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
            
            self.swipeRight.enabled = true
            self.lpgr.enabled = true
            
        } else if gestureReconizer.state == .Began {
            
            
            _ = gestureReconizer.locationInView(self.view)
            
            let die = SKAudioNode(fileNamed: "walking.wav")
            
            die.autoplayLooped = false
            addChild(die)
            
            self.swipeRight.enabled = false
            
            die.runAction(SKAction.play())
            //            player.runAction(SKAction.sequence([playerActionRunning, SKAction.runBlock({ () -> Void in
            //                self.swipeRight.enabled = true
            //            })]))
            
            
            player.runAction(SKAction.repeatActionForever(SKAction.sequence([playerActionRunning, SKAction.runBlock({ () -> Void in
                
            })])), withKey: "running")
            
            
            
            //            player.runAction(SKAction.sequence([playerActionRunning, SKAction.runBlock({ () -> Void in
            //                self.swipeRight.enabled = true
            //            })]), withKey: "running")
            
            
            //   player.runAction(SKAction.moveToX(player.position.x + 150, duration: 0.7))
            
            let movingAction = SKAction.repeatActionForever(SKAction.moveByX(150, y: 0, duration: 0.7))
            
            player.runAction(movingAction, withKey: "moving")
            
            
            print("running")
            
        }
        
    }
    
    
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
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
        
        if firstBody.categoryBitMask == physicsCategories.playerCategory && secondBody.categoryBitMask == physicsCategories.enemyCategory {
            
            enemy.physicsBody?.dynamic = false
            
            
            lives -= 1
            
            
            
            
            check()
            
            livesNode.text = "Lives: \(lives)"
            
            enemy.removeAllActions()
            
            
            enemy.runAction(SKAction.sequence([enemyDead]))
            enemy.removeFromParent()
            
            player.runAction(SKAction.runBlock({ () -> Void in
                
                self.player.runAction(SKAction.moveToX(654, duration: 0.5))
                
            }))
            
            
            
        } else if firstBody.categoryBitMask == physicsCategories.enemyCategory && secondBody.categoryBitMask == physicsCategories.bullet {
            
            scoreLabel.text = "Score: 1"
            self.score += 1
            
            enemy.removeAllActions()
            
            enemy.physicsBody = nil
            
            //enemyLocation = enemy.position
            
            
            
            let done = SKAction.removeFromParent()
            
            
            
            let die = SKAudioNode(fileNamed: "dying.wav")
            
            die.autoplayLooped = false
            addChild(die)
            
            
            enemy.physicsBody?.dynamic = false
            //enemy.physicsBody?.pinned = true
            
            die.runAction(SKAction.play())
            
            print(enemy.position)
            
            
            
            
            
            enemy.runAction(SKAction.sequence([enemyDead,done]))
            
            
            
            
            
            bullet.removeFromParent()
            
            
            
            
            
            
            
        } else if firstBody.categoryBitMask == physicsCategories.playerCategory && secondBody.categoryBitMask == physicsCategories.box {
            
            
            let secondScene = GameScene(fileNamed: "start.sks")
            let transition = SKTransition.fadeWithDuration(1.0)
            secondScene!.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(secondScene!, transition: transition)
            view?.removeGestureRecognizer(lpgr)
            check()
            
            if score > last {
                savingH("monsterKilled", score: score)
                last = score
                defaults.setInteger(score, forKey: "last")
            }
            
            if score == 1 {
                increment("1Killed", amount: 100)
            } else if score == 5 {
                increment("5Killed", amount: 100)
            } else if score == 10 {
                increment("10Kill", amount: 100)
            }
            
            increment("tutorial", amount: 100)
            
            
            
            
        } else if firstBody.categoryBitMask == physicsCategories.playerCategory && secondBody.categoryBitMask == physicsCategories.spike {
            
            player.removeAllActions()

            
            player.runAction(SKAction.sequence([SKAction.moveToX(653, duration: 0.5), SKAction.runBlock({ () -> Void in
                self.spike.physicsBody?.dynamic = true
              //  --self.lives
                
                self.lives -= 1
                
                self.livesNode.text = "Lives: \(self.lives)"
                self.check()
                
            })]))

        } else {
            bullet.removeFromParent()
        }
        
    }
    
    
    func savingH(ident: String, score: Int) {
        
        
        if GKLocalPlayer.localPlayer().authenticated {
            
            
            let reporter = GKScore(leaderboardIdentifier: ident)
            
            reporter.value = Int64(score)
            
            let scoreArray = [reporter]
            
            GKScore.reportScores(scoreArray, withCompletionHandler: { (error) -> Void in
                guard error == nil else {
                    print(error)
                    return
                }
            })
            
        }
        
        
    }
    
    
    
    override func update(currentTime: CFTimeInterval) {

        if bullet.position.x > player.position.x + 400 {
            
            UIView.animateWithDuration(3.0, animations: { () -> Void in
                self.bullet.alpha = 0.0
                }, completion: { (true1) -> Void in
                    self.bullet.removeFromParent()
            })
            
            
        } else {
            
        }
        
        if enemyLocation != nil {
            box.position = enemyLocation!
            enemyLocation = nil
        }
        
    }
    
    
}
