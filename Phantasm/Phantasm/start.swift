//
//  GameScene.swift
//  Phantasm
//
//  Created by Chris T Stuart on 1/14/16.
//  Copyright (c) 2016 Chris T Stuart. All rights reserved.
//

import SpriteKit
import AVFoundation
import GameKit


class GameScene: SKScene, AVAudioPlayerDelegate, GKGameCenterControllerDelegate{
    
    var start = SKLabelNode()
    var button = SKSpriteNode()
    var music = SKAudioNode()
    var credit = SKLabelNode()
    var gameCenter = SKLabelNode()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var gameCenterAchievements = [String: GKAchievement]()
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        
        auth()
        

        start = childNodeWithName("start") as! SKLabelNode
        start.name = "start"
        
        button = childNodeWithName("button") as! SKSpriteNode
        button.name = "button"
        
        credit = childNodeWithName("credits") as! SKLabelNode
        credit.name = "credits"
        
        gameCenter = childNodeWithName("gamecenter") as! SKLabelNode
        gameCenter.name = "gamecenter"
        
        let path  = NSBundle.mainBundle().pathForResource("bgmusic", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: path!)
        
        do {
            myMusicPlayer = try AVAudioPlayer(contentsOfURL: soundURL)
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }
        
        if(myMusicPlayer != nil){
            myMusicPlayer?.delegate = self
            myMusicPlayer?.numberOfLoops = -1
            myMusicPlayer?.prepareToPlay()
            myMusicPlayer?.play()
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
    
    
    func auth() {
        
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = { (viewController, error) -> Void in
            
            if viewController != nil {
                
                let vc = self.view?.window?.rootViewController!
                vc?.presentViewController(viewController!, animated: true, completion: nil)
                
            } else {
                
                print("Authentication is \(GKLocalPlayer.localPlayer().authenticated)")
                
               
                self.gameCenterAchievements.removeAll()
                self.loadAch()
                
                
                
                
            }
            
        }
        
        
    }
 
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            
            
            if touchedNode.name == "start" || touchedNode.name == "button" {
                
                let secondScene = game(fileNamed: "GameScene.sks")
                let transition = SKTransition.fadeWithDuration(1.0)
                secondScene!.scaleMode = SKSceneScaleMode.AspectFill
                self.scene!.view?.presentScene(secondScene!, transition: transition)
                //music.runAction(SKAction.stop())
            } else if touchedNode.name == "credits" {
                
                let secondScene = Credits(fileNamed: "Credits.sks")
                let transition = SKTransition.fadeWithDuration(1.0)
                secondScene!.scaleMode = SKSceneScaleMode.AspectFill
                self.scene!.view?.presentScene(secondScene!, transition: transition)
                
            } else if touchedNode.name == "gamecenter" {
                
                
                 self.showGame()
                
            }
            
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {

        
    }
    
    
    func showGame() {
        
        
        let gmCon = GKGameCenterViewController()
        gmCon.gameCenterDelegate = self
        
        let vc = self.view?.window?.rootViewController
        vc?.presentViewController(gmCon, animated: true, completion: nil)
        
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        gameCenterAchievements.removeAll()
        self.loadAch()
    }
 
    
}
