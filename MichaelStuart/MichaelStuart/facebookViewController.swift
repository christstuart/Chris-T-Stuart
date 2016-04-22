//
//  facebookViewController.swift
//  MichaelStuart
//
//  Created by Chris T Stuart on 4/10/16.
//  Copyright © 2016 Chris T Stuart. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

class facebookViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var Requset : FBSDKGraphRequest
        
        print("\(FBSDKAccessToken.currentAccessToken())")
        
        let acessToken = String(format:"%@", "CAAZAYVNjQTbIBANKBssMhXaNUTMbRZAic1j1rs1fZAUrbjslZBY2vCazivUpdYi3dlk5jsEnPZB3TyZBIiVMtrvuWnS71RqAyZBfov7BTHDnGszzTjA4m3MoETvXHDrZCeaqufLB5n2VXPTi88Ceobl1cdn3E9pv1YdoXhSZCTVLqvvISWU9B1f3MonyCT7PslwyHYb3ON7vkQQZDZD") as String
        
        print("\(acessToken)")
        
        let parameters1 = ["access_token":"CAAZAYVNjQTbIBANKBssMhXaNUTMbRZAic1j1rs1fZAUrbjslZBY2vCazivUpdYi3dlk5jsEnPZB3TyZBIiVMtrvuWnS71RqAyZBfov7BTHDnGszzTjA4m3MoETvXHDrZCeaqufLB5n2VXPTi88Ceobl1cdn3E9pv1YdoXhSZCTVLqvvISWU9B1f3MonyCT7PslwyHYb3ON7vkQQZDZD","fields": "id,name,message,story,description,picture,type,source","limit":"100"]
        
        
        Requset = FBSDKGraphRequest(graphPath:"/me/feed", parameters:parameters1, HTTPMethod:"GET")
        
        Requset.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            
            
            if ((error) != nil)
            {
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                
              //  let dataDict: AnyObject = result!.objectForKey("data")!
                
//                print(dataDict)
                
            }
        })
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
