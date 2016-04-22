//
//  ViewController.swift
//  Multipeer Rock Paper Scissors
//
//  Created by Chris T Stuart on 12/7/15.
//  Copyright © 2015 Chris T Stuart. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {
    
    @IBOutlet weak var disconnectButton: SwiftyButton!
    @IBOutlet weak var playButton: SwiftyButton!
    @IBOutlet weak var findOponent: SwiftyButton!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var imageViewHome: UIImageView!
    @IBOutlet weak var conectedToLabel: UILabel!
    
    var peerID: MCPeerID! // Our device's ID (name) as viewed by Other browsing devices.
    var session: MCSession! // The connection between devices.
    var browser: MCBrowserViewController! // Prebuilt viewcontroller that searches for nearby Advertisers.
    var advertiser: MCAdvertiserAssistant! // Helps us easily advertise ourselves to nearby MCBrowsers.
    var nearbyBrowser: MCNearbyServiceBrowser!
    
    var name = ""
    
    var state = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        disconnectButton.hidden = true
        
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.view.backgroundColor = UIColor.clearColor()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blueColor()]
        
        

        peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        
        session = MCSession(peer: peerID)
        session.delegate = self
        
        
        browser = MCBrowserViewController(serviceType: "game", session: session)
        
        
        advertiser = MCAdvertiserAssistant(serviceType: "game", discoveryInfo: nil, session: session)
        advertiser.start()
        
        
        nearbyBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: "game")
        nearbyBrowser.delegate = self
        
        self.navigationController?.navigationBarHidden = false
        
        playButton.enabled = false
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
     
        if state == false {
            
            peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
            
            session = MCSession(peer: peerID)
            session.delegate = self
            
            
            browser = MCBrowserViewController(serviceType: "game", session: session)
            
            
            advertiser = MCAdvertiserAssistant(serviceType: "game", discoveryInfo: nil, session: session)
            advertiser.start()
            
            
            nearbyBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: "game")
            nearbyBrowser.delegate = self
            
            self.navigationController?.navigationBarHidden = false
            
            playButton.enabled = false
            
        }
        
        
        print("Number of peers connected to session: \(session.connectedPeers.count)");
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    
    @IBAction func disconnect(sender: SwiftyButton) {
        
        session.disconnect()
        
    }
    
    
    
    @IBAction func findOponent(sender: UIButton) {
        
        if session != nil {
            
            // Our browser will look for advertisers that share the same serviceID
            
            browser = MCBrowserViewController(serviceType: "game", session: session)
            
            // We want to catch the callback methods in this class
            browser.delegate = self
            
            
            
            // present the browser
            presentViewController(browser, animated: true, completion: {
                //                self.nearbyBrowser.startBrowsingForPeers()
                
            })
            
        }
        
        
    }
    
    
    
    
    @IBAction func playAction(sender: SwiftyButton) {
        
        performSegueWithIdentifier("playWindow", sender: sender)
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let playView = segue.destinationViewController as! playViewController
        
        playView.session = session
        //playView.newName = name
        
    }
    
    
    
}






// MARK: -MCBrowserViewControllerDelegate

extension ViewController: MCBrowserViewControllerDelegate {
    
    // Notifies the delegate when the user taps the done button.
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // Notifies the delegate when the user taps the cancel button.
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}


// MARK: -MCSessionDelegate

extension ViewController: MCSessionDelegate {
    
    // remote peer changed state.
    
    
    
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        
        // Inform the user of connection status
        // This is run on a background thread
        
        switch state {
        case .NotConnected:
            print("Not Connected")
            
            
            
            self.state = false
            
            browser.dismissViewControllerAnimated(true, completion: nil)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.findOponent.hidden = false
                self.disconnectButton.hidden = true
                
                self.conectedToLabel.text = "Connected to:"
                self.playButton.enabled = false
                self.findOponent.enabled = true
                SweetAlert().showAlert("Diconnected", subTitle: "from \(peerID.displayName)", style: AlertStyle.Error, buttonTitle: "OK", action: { (isOtherButton) -> Void in
                    self.navigationController?.popToRootViewControllerAnimated(true)
                })
                
                self.advertiser.start()
                
            })
        case .Connecting:
            print("Connecting")
        case .Connected:
            print("working")
            
            self.state = true
            
            
            
            browser.dismissViewControllerAnimated(true, completion: nil)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.findOponent.hidden = true
                self.disconnectButton.hidden = false
                
                self.playButton.enabled = true
                self.findOponent.enabled = false
                self.conectedToLabel.text = "Connected to: \(peerID.displayName)"
                
                print("Connecting to: " + peerID.displayName);
                
                self.advertiser.stop()
            })
            
        }
        
        
        
        
    }
    
    
    
    // received data from remote peer.
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        
        print("Receiving Data")
        
        if let messageText = String(data: data, encoding: NSUTF8StringEncoding) {
            
            //let entityName = peerID.displayName
            
            print(messageText)
            
            // construct our string and dump it into the textView
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.name = messageText
                
                
            })
            
            
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





extension ViewController: MCNearbyServiceBrowserDelegate {
    
    func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {
        print(error)
    }
    
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print(peerID.displayName)
    }
    
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print(peerID.displayName)
    }
    
    
    
}




