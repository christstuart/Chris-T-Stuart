//
//  ViewController.swift
//  MemoryGame
//
//  Created by Chris T Stuart on 12/2/15.
//  Copyright © 2015 Chris T Stuart. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var memoryCards: [UIImageView]!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    // array to hold both of my pressed views
    
    var images = [UIView]()
    
    // array to store shuffle images
    
    var newImages = [String]()
    
    // array to hold the name of the images to compare them
    
    var storedName = [String]()
    
    // timer
    
    var timer = NSTimer()
    
    // timer
    var newT = NSTimer()
    
    // variable for my time
    
    var counter = 0
    
    // timer
    
    var newTimer = NSTimer()
    
    // timer
    
    var back = NSTimer()
    
    // variable to check how many views I have matched
    
    var count = 0
    
    // custom banner wen the game starts
    
    var banner = Banner()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // func to start the game
        
        checkGame()
        
        // shadow for my top and bottom view
        
        topView.layer.shadowOpacity = 0.4
        topView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        
        bottomView.layer.shadowOpacity = 0.7
        bottomView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        
        
        // assign the count to the shuffle array
        
        count = newImages.count
        
        
        
    }
    
    
    
    
    
    func checkGame() {
        
        // creating a tapGesture for my views
        
        var tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapGestureRecognized(_:)))
        
        // checking for the current device
        
        if UIDevice.currentDevice().model == "iPhone" {
            
            // my image array
            
            var imageNames = ["buttons add","buttons add","buttons cancel","buttons cancel","buttons do","buttons do","buttons facebook","buttons facebook","buttons feed","buttons feed","buttons remove","buttons remove","buttons share","buttons share","buttons skip","buttons skip","buttons upload upgrade","buttons upload upgrade","casino dice","casino dice"]
            
            // looping through all my views
            
            for i in memoryCards {
                
                // creating a random number with the count of my image array
                
                let random = arc4random_uniform(UInt32(imageNames.count))
                
                // checking if my image array count is larger than 0
                
                if imageNames.count > 0 {
                    
                    // appending my shuffle images to my shuffle array
                    
                    newImages.append(imageNames[Int(random)])
                    imageNames.removeAtIndex(Int(random))
                    
                    // disableling my userInteraction
                    
                    i.userInteractionEnabled = false
                    
                    // assigning a tapGesture to my views
                    
                    tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapGestureRecognized(_:)))
                    
                    i.addGestureRecognizer(tapGesture)
                    i.alpha = 1.0
                    
                    // assigning the back of the image
                    
                    i.image = UIImage(named: "backCard")
                    
                    
                }
                
                
            }
            
            // checking for the current device
            
        } else if UIDevice.currentDevice().model == "iPad" {
            
            // my image array
            
            var imageNames = ["buttons add","buttons add","buttons cancel","buttons cancel","buttons do","buttons do","buttons facebook","buttons facebook","buttons feed","buttons feed","buttons remove","buttons remove","buttons share","buttons share","buttons skip","buttons skip","buttons upload upgrade","buttons upload upgrade","casino dice","casino dice", "casino horse shoe", "casino party on", "casino token", "chess black pawn","casino horse shoe", "casino party on", "casino token", "chess black pawn","chess white horse","chess white horse"]
            
            
            // looping through all my views
            
            for i in memoryCards {
                
                // creating a random number with the count of my image array
                
                let random = arc4random_uniform(UInt32(imageNames.count))
                
                // checking if my image array count is larger than 0
                
                if imageNames.count > 0 {
                    
                    // appending my shuffle images to my shuffle array
                    
                    newImages.append(imageNames[Int(random)])
                    imageNames.removeAtIndex(Int(random))
                    
                    // disableling my userInteraction
                    i.userInteractionEnabled = false
                    
                    // assigning a tapGesture to my views
                    
                    tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapGestureRecognized(_:)))
                    i.addGestureRecognizer(tapGesture)
                    i.alpha = 1.0
                    i.image = UIImage(named: "backCard")
                    
                    
                }
                
                
            }
            
            
            
        }
        
        // stoping my time timer
        
        newTimer.invalidate()
        
        
    }
    
    
    // function called wen views and images are equal
    
    func countUp(timer: NSTimer) {
        
        // animating the UIView to fade out
        
        UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.images[0].alpha = 0.0
            self.images[1].alpha = 0.0
            
            }, completion: nil)
        
        // decrementing my total count of views
        
        count -= 1
        count -= 1
        
        // removing all values from my array both are used to check the views and image name
        
        images.removeAll()
        storedName.removeAll()
        
        // looping through my views
        
        for i in memoryCards {
            
            // enable the userInteraction of my views
            
            i.userInteractionEnabled = true
            
        }
        
        
        // checking if I have matched all the views
        
        if count == 0 {
            
            // assing the counter to 0
            counter = 0
            // assing the count to 0
            count = 0
            
            // present a custom banner wen the user finishs the game
            
            banner = Banner(title: "Game Over", subtitle: "Good job", image: UIImage(named: "Icon"), backgroundColor: UIColor.redColor())
            
            
            banner.dismissesOnTap = true
            
            banner.show(duration: 1.0)
            
            // removing all values from my shuffle array
            
            newImages.removeAll()
            
            // calling my starting function to start the game
            
            checkGame()
            
            // assign the count to the count of the shuffle array
            
            count = newImages.count
            
            // enable the playButton
            
            playButton.enabled = true
            
            
        }
    }
    
    // function to check if views are not equal
    
    func countDown(timer: NSTimer) {
        
        // make sure theres two views stored
        
        if storedName.count == 2 {
            
            // animate the first view touched to the back card
            
            UIView.transitionWithView(images[0], duration: 0.5, options: .TransitionFlipFromRight, animations: { () -> Void in
                (self.images[0] as! UIImageView).image = UIImage(named: "backCard")
                }, completion: nil)
            
            // animate the second view touched to the back card
            
            UIView.transitionWithView(images[1], duration: 0.5, options: .TransitionFlipFromRight, animations: { () -> Void in
                (self.images[1] as! UIImageView).image = UIImage(named: "backCard")
                }, completion: nil)
            
            // remove all values from my arrays
            
            storedName.removeAll()
            images.removeAll()
            
            // enable user interaction
            
            for i in memoryCards {
                
                i.userInteractionEnabled = true
                
            }
            
            
            
        }
        
        
    }
    
    // func to start my time timer
    
    func gameStart() {
        
        counter += 1
        
        counterLabel.text = "Time: \(counter) seconds"
        
        
        
    }
    
    // IBAction to start my game
    
    @IBAction func playButton(sender: UIButton) {
        
        // custom banner to show game started
        
        banner = Banner(title: "Game Started", subtitle: "", image: UIImage(named: "Icon"), backgroundColor: UIColor(red:48.00/255.0, green:174.0/255.0, blue:51.5/255.0, alpha:1.000))
        
        banner.dismissesOnTap = true
        banner.show(duration: 1.5)
        
        // enable all my views userInteraction
        
        for i in memoryCards {
            i.userInteractionEnabled = true
        }
        
        // starting my timer
        
        newTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.gameStart), userInfo: nil, repeats: true)
        
        //disable my play button
        
        playButton.enabled = false
        
    }
    
    
    // tapGesture for my views
    
    func tapGestureRecognized(sender: UITapGestureRecognizer) {
        
        // enable all userInteraction
        
        for i in memoryCards {
            
            i.userInteractionEnabled = true
            
            
        }
        
        // check if my view array has 2 values
        
        if storedName.count == 0 || storedName.count == 1 {
            
            // animation to open the touched view
            
            UIView.transitionWithView(sender.view!, duration: 0.5, options: .TransitionFlipFromLeft, animations: { () -> Void in
                (sender.view as! UIImageView).image = UIImage(named: self.newImages[(sender.view?.tag)!])
                
                // apending the views image name
                
                self.images.append(sender.view!)
                }, completion: nil)
            
            // appending the view to my view array
            
            storedName.append(newImages[(sender.view?.tag)!])
            
            // if theres two views in my view array
            
            if storedName.count == 2 {
                
                // disable userInteraction
                
                for i in memoryCards {
                    
                    i.userInteractionEnabled = false
                    
                }
                
                
                // if the first and second view are equal
                
                if self.images[0] == self.images[1] {
                    
                    // animate to the back card
                    
                    UIView.transitionWithView(images[0], duration: 1, options: .TransitionFlipFromRight, animations: { () -> Void in
                        (self.images[0] as! UIImageView).image = UIImage(named: "backCard")
                        }, completion: nil)
                    
                    // remove all values from my arrays
                    
                    storedName.removeAll()
                    images.removeAll()
                    
                    // enable userInteraction
                    
                    
                    for i in memoryCards {
                        
                        i.userInteractionEnabled = true
                    }
                    
                    // jumps out of the if statement
                    
                    return
                    
                }
                
                // if the image name are equal
                
                if storedName[0] == storedName[1] {
                    
                    // start my timer to check cards
                    
                    timer = NSTimer.scheduledTimerWithTimeInterval(1.3, target: self, selector: #selector(ViewController.countUp(_:)), userInfo: nil, repeats: false)
                    
                    // validate my timer
                    
                    timer.valid
                    
                    
                    // else my image name are not equal
                    
                } else {
                    
                    
                    // start my setting my views to the backCard timer
                    
                    
                    newT = NSTimer.scheduledTimerWithTimeInterval(1.3, target: self, selector: #selector(ViewController.countDown(_:)), userInfo: nil, repeats: false)
                    
                    newT.valid
                }
                
            }
            
            
            
            
        }
        
        
    }
    
    
}




