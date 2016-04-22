//
//  sampleViewController.swift
//  MichaelStuart
//
//  Created by Chris T Stuart on 3/18/16.
//  Copyright © 2016 Chris T Stuart. All rights reserved.
//

import UIKit

class sampleViewController: UIViewController {
    
    @IBOutlet var topImage: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    
    var topI: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize.height = 2000
        scrollView.contentSize.width = UIScreen.mainScreen().bounds.size.width
        
        print(topI)
        
        topImage.image = topI
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        topImage.frame = CGRectMake(0, 0, 10, UIScreen.mainScreen().bounds.size.height * 2)
        topImage.contentMode = .ScaleToFill
        
        print(topImage.frame)
    }
    
    @IBAction func dismiss(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
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


extension sampleViewController: UIScrollViewDelegate {
    
    
    
    
}