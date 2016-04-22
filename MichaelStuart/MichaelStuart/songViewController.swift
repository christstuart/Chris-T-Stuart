//
//  songViewController.swift
//  MichaelStuart
//
//  Created by Chris T Stuart on 3/16/16.
//  Copyright © 2016 Chris T Stuart. All rights reserved.
//

import UIKit
import AVFoundation
import CloudKit
import SystemConfiguration

class songViewController: UIViewController {
    
    @IBOutlet var topImage: UIImageView!
    @IBOutlet var albumTitle: UILabel!
    @IBOutlet var albumTime: UILabel!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var musicButton: UIButton!
    
    var player = AVAudioPlayer()
    var time = ""
    var song = ""
    var album = ""
    var image: UIImage!
    var state = true
    var count = 0
    
    
    
    var playerItem:AVPlayerItem?
    var player2:AVPlayer?
    
    var stream = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //music()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(songViewController.networkStatusChanged1(_:)), name: ReachabilityStatusChangedNotification, object: nil)
        Reach().monitorReachabilityChanges()
        
        
        
        albumTime.text = time
        albumTitle.text = song
        topLabel.text = album
        topImage.image = image
        
        
        
        
        
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(songViewController.finishedPlaying(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem)
        
        
        
    }
    
    
    func networkStatusChanged1(notification: NSNotification) {
          let userInfo = notification.userInfo
         print(userInfo)
        
        if count == 0 {
            
            switch Reach().connectionStatus() {
            case .Unknown, .Offline:
                
                
                //  print("Not connected")
                musicButton.enabled = false
                
                let button = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (alert) in
                    self.count = 0
                })
                
                showAlert("No Internet Connection", message: "Make sure your device is connected to the internet.", alertActions: [button])
                
                
                defer {
                    self.count = 1
                }
                
            // print("Internet connection FAILED")
            case .Online(.WWAN):
                let url = NSURL(string: stream)
                
                playerItem = AVPlayerItem(URL: url!)
                player2 = AVPlayer(playerItem: playerItem!)
                let playerLayer = AVPlayerLayer(player: player2)
                playerLayer.frame = CGRectMake(0, 0, 300, 50)
                //self.view.layer.addSublayer(playerLayer)
                
                musicButton.enabled = true
                
                self.count = 1
                
            case .Online(.WiFi):
                let url = NSURL(string: stream)
                
                playerItem = AVPlayerItem(URL: url!)
                player2 = AVPlayer(playerItem: playerItem!)
                let playerLayer = AVPlayerLayer(player: player2)
                playerLayer.frame = CGRectMake(0, 0, 300, 50)
                // self.view.layer.addSublayer(playerLayer)
                
                musicButton.enabled = true
                
                self.count = 1
                
            }
            
        }
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(sender: UIButton) {
        
        player2?.pause()
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func finishedPlaying(myNotification:NSNotification) {
        
        let stopedPlayerItem: AVPlayerItem = myNotification.object as! AVPlayerItem
        stopedPlayerItem.seekToTime(kCMTimeZero)
    }
    
    @IBAction func musicButton(sender: UIButton) {
        if player2?.rate == 0
        {
            musicButton.setTitle("| |", forState: .Normal)
            player2!.play()
            
        } else {
            musicButton.setTitle(">", forState: .Normal)
            player2!.pause()
            
        }
        
    }
    
}



