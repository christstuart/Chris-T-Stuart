//
//  socialViewController.swift
//  MichaelStuart
//
//  Created by Chris T Stuart on 3/29/16.
//  Copyright © 2016 Chris T Stuart. All rights reserved.
//

import UIKit

class socialViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func instaAction(sender: UIButton) {
        
        performSegueWithIdentifier("insta", sender: sender)
        
    }
    
    @IBAction func twitterAction(sender: UIButton) {
        
        performSegueWithIdentifier("twitter", sender: sender)
        
    }
    
    @IBAction func facebookAction(sender: UIButton) {
        
        showAlertWithTitle("Still working on it.")
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
