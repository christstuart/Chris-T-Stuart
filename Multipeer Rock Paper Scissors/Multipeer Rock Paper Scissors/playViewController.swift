//
//  playViewController.swift
//  Multipeer Rock Paper Scissors
//
//  Created by Chris T Stuart on 12/7/15.
//  Copyright © 2015 Chris T Stuart. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class playViewController: UIViewController {
    
    
    @IBOutlet var imageViews: [UIImageView]!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var hisImage: UIImageView!
    @IBOutlet weak var youLabel: UILabel!
    @IBOutlet weak var themLabel: UILabel!
    @IBOutlet weak var readyUp: UIButton!
    
    
    var mImage = [String]()
    var hImage = [String]()
    
    
    var myScore = 0
    var hisScore = 0
    
    var currentActiveView: UIView?
    
    
    var myReady = false
    var hisReady = false
    
    
    var session: MCSession!
    var newName = ""
    
    var countdown = NSTimer()
    var timer = NSTimer()
    
    var imageArray = ["paper","rock","scissors"]
    
    
    @IBOutlet var countDownLabel: UILabel!
    
    var timecount = 3
    
    let saveTheScores = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        
//        hisScore = saveTheScores.integerForKey("his")
//        myScore = saveTheScores.integerForKey("my")
        
    
    
    
        readyUp.enabled = true
        
        // Do any additional setup after loading the view.
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.view.backgroundColor = UIColor.clearColor()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBarHidden = false
        
        if let back = navigationController?.navigationBar.backItem {
            back.hidesBackButton = true
        }
        
        session.delegate = self
        
        var tapGesture = UITapGestureRecognizer(target: self, action: #selector(playViewController.tapGestureRecognized(_:)))
        
        for i in imageViews {
            
            i.userInteractionEnabled = false
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(playViewController.tapGestureRecognized(_:)))
            i.addGestureRecognizer(tapGesture)
            
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewController = segue.destinationViewController as! ViewController
        
        viewController.session = session
        
    }
    
    override func viewDidAppear(animated: Bool) {
        session.delegate = self
        
        print(session.connectedPeers)
    }
    
    
    func tapGestureRecognized(sender: UITapGestureRecognizer) {
        
        print(sender.view!.tag)
        
        mImage.removeAll()
        
        myImage.image = UIImage(named: imageArray[(sender.view?.tag)!])
        
        if myReady == hisReady {
            
            
            if let image = imageArray[(sender.view?.tag)!].dataUsingEncoding(NSUTF8StringEncoding) {
                
                do {
                    mImage.append(imageArray[(sender.view?.tag)!])
                    try session.sendData(image, toPeers: session.connectedPeers, withMode: .Reliable)
                    
                    readyUp.enabled = false
                    
                    for i in imageViews {
                        i.userInteractionEnabled = true
                    }
                    
                } catch {
                    print(error)
                }
                
            }
            
        }
        
        currentActiveView?.layer.borderWidth = 0
        
        // Set a new current active view
        currentActiveView = sender.view
        
        // add highlight border to the selected view
        currentActiveView?.layer.borderColor = UIColor.whiteColor().CGColor
        currentActiveView?.layer.borderWidth = 1
        
        
        for i in imageViews {
            i.userInteractionEnabled = false
        }
    }
    
    @IBAction func goBackHome(sender: UIButton) {
        
        myReady = true
        
        if let ready = myReady.boolValue.description.dataUsingEncoding(NSUTF8StringEncoding) {
            
            do {
                try session.sendData(ready, toPeers: session.connectedPeers, withMode: .Reliable)
                readyUp.enabled = false
            } catch {
                print(error)
            }
            
        }
        
        if self.hisReady == true && self.myReady == true {
            self.countdown = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(playViewController.update), userInfo: nil, repeats: true)
        }
        
    }
    
    
    func enable() {
        
        for i in imageViews {
            i.userInteractionEnabled = true
            i.layer.borderWidth = 0
        }
        
        readyUp.enabled = false
        
        
    }
    
    
    func disable() {
        
        readyUp.enabled = true
        
        for i in imageViews {
            i.userInteractionEnabled = false
            i.layer.borderWidth = 0
        }
        
        countDownLabel.hidden = false
        countdown.invalidate()
        
    }
    
    
    
    func check() {
        
        print(mImage.count)
        print(hImage.count)
        
        
        countdown.invalidate()
        timecount = 3
        
        countDownLabel.hidden = true
        countDownLabel.text = String(timecount)
        
        if mImage.count == 0 || hImage.count == 0 {
            
            // self.hisImage.image = UIImage(named: self.hImage[0])
            
            self.myReady = false
            self.hisReady = false
            
            
            
            let refreshAlert = UIAlertController(title: "Try Again", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                self.mImage.removeAll()
                self.hImage.removeAll()
                
                self.myImage.image = nil
                self.hisImage.image = nil
                
                
                self.disable()
                
                
            }))
            
            
            presentViewController(refreshAlert, animated: true, completion: nil)
            
        } else {
            if mImage[0] == hImage[0] {
                
                self.hisImage.image = UIImage(named: self.hImage[0])
                
                self.myReady = false
                self.hisReady = false
                
                let refreshAlert = UIAlertController(title: "Equal", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    self.mImage.removeAll()
                    self.hImage.removeAll()
                    
                    self.myImage.image = nil
                    self.hisImage.image = nil
                    
                    
                    
                    self.disable()
                    
                    
                }))
                
                
                presentViewController(refreshAlert, animated: true, completion: nil)
                
                
            } else if mImage[0] == "rock" && hImage[0] == "scissors"  {
                print("not equal")
                
                self.hisImage.image = UIImage(named: self.hImage[0])
                
                self.myReady = false
                self.hisReady = false
                
                let refreshAlert = UIAlertController(title: "You won", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    self.mImage.removeAll()
                    self.hImage.removeAll()
                    
                  //  ++self.myScore
                    
                    self.myScore += 1
                    
                //    self.myScore = self.myScore - 1;
                    
                    self.youLabel.text = "You: \(self.myScore)"
                    
                    self.saveTheScores.setValue(self.myScore, forKey: "my");
                    
                    
                    self.myImage.image = nil
                    self.hisImage.image = nil
                    
                    self.disable()
                    
                    
                }))
                
                
                presentViewController(refreshAlert, animated: true, completion: nil)
                
                
            } else if mImage[0] == "scissors" && hImage[0] == "paper" {
                
                self.hisImage.image = UIImage(named: self.hImage[0])
                
                self.myReady = false
                self.hisReady = false
                
                let refreshAlert = UIAlertController(title: "You won", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    self.mImage.removeAll()
                    self.hImage.removeAll()
                    
                 //   ++self.myScore
                    
                    self.myScore += 1
                    
                    self.youLabel.text = "You: \(self.myScore)"
                    self.saveTheScores.setValue(self.myScore, forKey: "my");
                    
                    self.myImage.image = nil
                    self.hisImage.image = nil
                    
                    self.disable()
                    
                    
                }))
                
                
                presentViewController(refreshAlert, animated: true, completion: nil)
                
                
            } else if mImage[0] == "paper" && hImage[0] == "rock" {
                
                
                self.hisImage.image = UIImage(named: self.hImage[0])
                
                self.myReady = false
                self.hisReady = false
                
                let refreshAlert = UIAlertController(title: "You won", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    self.mImage.removeAll()
                    self.hImage.removeAll()
                    
                  //  ++self.myScore
                    
                    self.myScore += 1
                    
                    self.youLabel.text = "You: \(self.myScore)"
                    
                    self.saveTheScores.setValue(self.myScore, forKey: "my");
                    
                    self.myImage.image = nil
                    self.hisImage.image = nil
                    
                    self.disable()
                    
                    
                }))
                
                presentViewController(refreshAlert, animated: true, completion: nil)
                
            } else {
                
                self.hisImage.image = UIImage(named: self.hImage[0])
                
                self.myReady = false
                self.hisReady = false
                
                let refreshAlert = UIAlertController(title: "Oponent won", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    self.mImage.removeAll()
                    self.hImage.removeAll()
                    
                    self.hisScore += 1
                    
                    self.themLabel.text = "Them: \(self.hisScore)"
                    
                    self.saveTheScores.setValue(self.hisScore, forKey: "his");
                    
                    self.myImage.image = nil
                    self.hisImage.image = nil
                    
                    self.disable()
                    
                    
                }))
                
                presentViewController(refreshAlert, animated: true, completion: nil)
                
            }
        }
        
    }
    
}


extension playViewController: MCSessionDelegate {
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        
        // Inform the user of connection status
        // This is run on a background thread
        
        switch state {
        case .NotConnected:
            print("Not Connected")
            
            let viewController = self.navigationController?.viewControllers[0] as! ViewController
            
            
            viewController.browser.dismissViewControllerAnimated(true, completion: nil)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SweetAlert().showAlert("Diconnected", subTitle: "from: \(peerID.displayName)", style: AlertStyle.Error, buttonTitle: "OK", action: { (isOtherButton) -> Void in
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
                    
                    viewController.findOponent.hidden = false
                    viewController.disconnectButton.hidden = true
                    
                    
                    viewController.conectedToLabel.text = "Connected to:"
                    viewController.playButton.enabled = false
                    viewController.findOponent.enabled = true
                    
                    viewController.state = false
                    
                    
                })
                
                viewController.advertiser.start()
                
            })
            
            
        case .Connecting:
            print("Connecting")
        case .Connected:
            print("connected to \(peerID.displayName)")
            
            let viewController = self.navigationController?.viewControllers[0] as! ViewController
            
            viewController.browser.dismissViewControllerAnimated(true, completion: nil)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                viewController.findOponent.hidden = true
                viewController.disconnectButton.hidden = false
                
                viewController.playButton.enabled = true
                viewController.findOponent.enabled = false
                viewController.conectedToLabel.text = "Connected to: \(peerID.displayName)"
                viewController.advertiser.stop()
            })
            
        }
        
        
    }
    
    
    func update() {
        if(timecount > 0) {
            self.timecount -= 1
            self.countDownLabel.text = String(self.timecount)
            print(self.timecount)
            enable()
        } else {
            countdown.invalidate()
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(playViewController.check), userInfo: nil, repeats: false)
        }
    }
    
    
    // received data from remote peer.
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        
        if let messageText = String(data: data, encoding: NSUTF8StringEncoding) {
            
            if let what = messageText.toBool() {
                hisReady = what
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    
                    if self.hisReady == true && self.myReady == true {
                        self.countdown = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(playViewController.update), userInfo: nil, repeats: true)
                    }
                }
            }
            
             hImage.removeAll()
            
            if messageText == "true" {
                print("true")
            } else {
                hImage.append(messageText)
            }
            
            
            
            
            //dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            //                if self.myReady == self.hisReady {
            //
            //
            //                    self.readyUp.enabled = false
            //
            //                    if self.mImage.count == 0 || self.hImage.count == 0 {
            //
            //                        self.countdown = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
            //                        self.enable()
            //                        self.timer = NSTimer.scheduledTimerWithTimeInterval(6.0, target: self, selector: "check", userInfo: nil, repeats: false)
            //
            //
            //                    }
            //
            //
            //
            //
            //                }
            
            
            //  })
            
        }
        
        
        
    
        
        
        
    }
    
    
    // received a byte stream from remote peer.
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    // Start receiving a resource from remote peer.
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        
    }
    
    // finished receivin a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox.
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        
    }
    
    
    
}

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}
