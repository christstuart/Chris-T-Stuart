//
//  Credits.swift
//  Phantasm
//
//  Created by Chris T Stuart on 1/21/16.
//  Copyright © 2016 Chris T Stuart. All rights reserved.
//

import SpriteKit


class Credits: SKScene {
    
    
    override func didMoveToView(view: SKView) {
        
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let _ = touch.locationInNode(self)
            
            let secondScene = GameScene(fileNamed: "start.sks")
            let transition = SKTransition.fadeWithDuration(1.0)
            secondScene!.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(secondScene!, transition: transition)
            
            
        }
        
    }
    
}