//
//  ViewController.swift
//  GDC
//
//  Created by Chris T Stuart on 12/4/15.
//  Copyright © 2015 Chris T Stuart. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var firstImageView: UIImageView!
    
    @IBOutlet weak var secondImageView: UIImageView!
    
    @IBOutlet weak var thirdImageView: UIImageView!
    
    @IBOutlet weak var fourthImageView: UIImageView!
    
    @IBOutlet weak var fifthImageView: UIImageView!
    
    @IBOutlet weak var sixImageView: UIImageView!
    
    @IBOutlet weak var sevenImageView: UIImageView!

    @IBOutlet weak var eightImageView: UIImageView!
    
    
    
    var imageArrayTemp = [UIImageView]()
    
    var uiImageArray = [UIImage]()
    
    
    var mySerialQueue: dispatch_queue_t!
    var myConcurrentQueue: dispatch_queue_t!
    
    
    let imageArray = ["http://hd.wallpaperswide.com/thumbs/mountain_landscape-t2.jpg", "http://hd.wallpaperswide.com/thumbs/metropolis_at_night-t2.jpg", "http://hd.wallpaperswide.com/thumbs/business-t2.jpg", "http://hd.wallpaperswide.com/thumbs/julia_pfeiffer_burns_beach_at_sunset-t2.jpg", "http://hd.wallpaperswide.com/thumbs/marguerite_daisy_flower-t2.jpg", "http://hd.wallpaperswide.com/thumbs/beautiful_autumn_3-t2.jpg", "http://hd.wallpaperswide.com/thumbs/above-t2.jpg","http://hd.wallpaperswide.com/thumbs/colorful_daisies-t2.jpg"]
    
    var count = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageArrayTemp = [(self.firstImageView),(self.secondImageView),(self.thirdImageView),(self.fourthImageView), (self.fifthImageView), (self.sixImageView), (self.sevenImageView),(self.eightImageView)]
        
        mySerialQueue = dispatch_queue_create("someUniqueStringGoesHere", DISPATCH_QUEUE_SERIAL)
        myConcurrentQueue = dispatch_queue_create("com.GDCLecture.myConcurrentQueue", DISPATCH_QUEUE_CONCURRENT)
        
    }

    @IBAction func clearAll(sender: UIButton) {
        
        let imageArrayTemp = [(self.firstImageView),(self.secondImageView),(self.thirdImageView),(self.fourthImageView), (self.fifthImageView), (self.sixImageView), (self.sevenImageView),(self.eightImageView)]
        
        for view in imageArrayTemp {
            
            view.image = nil
            
            uiImageArray.removeAll()
            
        }
        
    }
    
    @IBAction func downloadSerial(sender: UIButton) {

        var image = NSURL(string: imageArray[0])
        
        for i in 0 ..< 8 {
            
            let index = i
            
            image = NSURL(string: imageArray[i])
            
            self.downloadImageSerial(image!,index: index)
            
        }
        
        
    }
    
    @IBAction func downloadCon(sender: UIButton) {
        
        
        
        var image = NSURL(string: imageArray[0])
        
        for i in 0 ..< 8 {
            
            let index = i
            image = NSURL(string: imageArray[i])
            
            self.downloadImageCon(image!, index:  index)
            
        }
        
    }
    
    
    @IBAction func downloadRegular(sender: UIButton) {
        
        
        
        var image = NSURL(string: imageArray[0])
        
        for i in 0 ..< 8 {
            
            image = NSURL(string: imageArray[i])
            
            self.downloadImage(image!)
            
        }
        
    }

    
    func downloadImage(url: NSURL){
        
        let data = NSData(contentsOfURL: url)
        
        
        self.uiImageArray.append(UIImage(data: data!)!)
        
        if self.uiImageArray.count == self.imageArrayTemp.count {
            
            for i in 0 ..< self.imageArrayTemp.count {
                
                
                self.imageArrayTemp[i].image = self.uiImageArray[i]
                
                
            }
            
            
        }
    }
    

    func downloadImageSerial(url: NSURL, index: Int){
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 2), { () -> Void in
            
            dispatch_async(self.mySerialQueue) { () -> Void in
                
                let data = NSData(contentsOfURL: url)
                
                let loadImage = UIImage(data: data!)
                
                self.uiImageArray.append(UIImage(data: data!)!)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    
                    self.imageArrayTemp[index].image = loadImage
                    
                })
            }
            
        })
        
    }
    
    
    
    
    func downloadImageCon(url: NSURL, index: Int){
        
        dispatch_async(self.myConcurrentQueue) { () -> Void in
            
            let data = NSData(contentsOfURL: url)
            
            let loadImage = UIImage(data: data!)
            
            self.uiImageArray.append(UIImage(data: data!)!)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                
                self.imageArrayTemp[index].image = loadImage
                
                
            })
            
        }
        
    }
    
}





