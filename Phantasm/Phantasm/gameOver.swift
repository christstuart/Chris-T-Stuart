//
//  gameOver.swift
//  Phantasm
//
//  Created by Chris T Stuart on 1/16/16.
//  Copyright © 2016 Chris T Stuart. All rights reserved.
//

import SpriteKit


class gameOver: SKScene {
    
    override func didMoveToView(view: SKView) {
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        for _ in touches {

            let secondScene = GameScene(fileNamed:"start")
            let transition = SKTransition.fadeWithDuration(1.0)
            secondScene!.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(secondScene!, transition: transition)
            
        }
        
    }
    
}
