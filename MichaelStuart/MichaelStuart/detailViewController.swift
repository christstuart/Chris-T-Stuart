//
//  detailViewController.swift
//  MichaelStuart
//
//  Created by Chris T Stuart on 3/2/16.
//  Copyright © 2016 Chris T Stuart. All rights reserved.
//

import UIKit
import CloudKit
import AVFoundation

class detailViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var topImage: UIImageView!
    @IBOutlet var imageText: UILabel!
    
    var topImageUI: UIImage!
    var data1 = [CKRecord]()
    var database: String!
    var topLabelText: String!
    var sort1: String!
    var player = AVAudioPlayer()
    
    var count = 0
    
    var index: NSIndexPath!
    
    @IBOutlet  var theCellImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(detailViewController.networkStatusChanged(_:)), name: ReachabilityStatusChangedNotification, object: nil)
        Reach().monitorReachabilityChanges()
        
        
        imageText.text = topLabelText
        topImage.image = topImageUI
        
        
        
        
        
    }
    
    
    func networkStatusChanged(notification: NSNotification) {
        let userInfo = notification.userInfo
        print(userInfo)
        
        if count == 0 {
            
            switch Reach().connectionStatus() {
            case .Unknown, .Offline:
                
                count = 1
                
                let button = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (alert) in
                    self.count = 0
                })
                
                showAlert("No Internet Connection", message: "Make sure your device is connected to the internet.", alertActions: [button])
                
            case .Online(.WWAN):
                
                count = 1
                
                CKContainer.defaultContainer().accountStatusWithCompletionHandler { (status, error) -> Void in
                    guard error == nil else {
                        print(error)
                        return
                    }
                    
                    switch status {
                    case .Available:
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.getData()
                        })
                        
                    case .NoAccount:
                        self.showAlertWithTitle("You have no account in your iCloud.")
                    
                    case .CouldNotDetermine:
                        self.showAlertWithTitle("Your iCloud account is not determine.")
                    
                    case .Restricted:
                        self.showAlertWithTitle("Your iCould restrictions are restricted.")
                        
                        
                    }
                    
                }
                
                
            case .Online(.WiFi):
                
                self.count = 1
                
                
                CKContainer.defaultContainer().accountStatusWithCompletionHandler { (status, error) -> Void in
                    guard error == nil else {
                        print(error)
                        return
                    }
                    
                    switch status {
                    case .Available:
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.getData()
                            
                        })
                        
                    case .NoAccount:
                        self.showAlertWithTitle("You have no account in your iCloud.")
                    case .CouldNotDetermine:
                        self.showAlertWithTitle("Your iCloud account is not determine.")
                    case .Restricted:
                        self.showAlertWithTitle("Your iCould restrictions are restricted.")

                    }
                    
                }
                
                
            }
        }
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        
        
    }
    
    
    func getData() {
        
        
        
        
        let actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(actInd)
        actInd.startAnimating()
        
        
        let pred = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: sort1, ascending: false)
        
        let query = CKQuery(recordType: database, predicate: pred)
        query.sortDescriptors = [sort]
        
        CKContainer.defaultContainer().publicCloudDatabase.performQuery(query, inZoneWithID: nil) { (data, error) -> Void in
            guard error == nil else {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.showAlert("Important", message: error?.localizedDescription)
                    actInd.stopAnimating()
                })
                
                //print(error?.localizedDescription)
                actInd.stopAnimating()
                return
            }
            
            if let data = data {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.data1 = data
                    
                    
                    self.collectionView.reloadData()
                    actInd.stopAnimating()
                    
                    print(data.count)
                    
                    
                })
                
            }
        }
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if database == "Music" {
            
            let music = segue.destinationViewController as! musicViewController
            
            
            let image = data1[index.row]["albumImage"] as! CKAsset
            let formated = UIImage(contentsOfFile: image.fileURL.path!)
            
            music.topI = formated
            music.albumName = data1[index.row]["albumText"] as! String
            music.albumSongs = data1[index.row]["songNames"] as! [String]
            music.albumTime = data1[index.row]["songTimes"] as! [String]
            music.albumNumber = data1[index.row]["songNumbers"] as! [String]
            music.songs = data1[index.row]["stream"] as! [String]
            music.albumLink = data1[index.row]["albumLink"] as! String
            
        } else if database == "Event" {
            
            let event = segue.destinationViewController as! eventViewController
            
            
            let image = data1[index.row]["eventImage"] as! CKAsset
            let formated = UIImage(contentsOfFile: image.fileURL.path!)
            
            
            event.topI = formated
            
            event.textForDate = data1[index.row]["Date"] as! String
            event.textForEvent = data1[index.row]["Title"] as! String
            event.textForPrice = data1[index.row]["Price"] as! String
            event.lat = data1[index.row]["dropL"] as! Double
            event.long = data1[index.row]["dropLo"] as! Double
            event.dropT = data1[index.row]["dropT"] as! String
            event.dropS = data1[index.row]["dropS"] as! String
            event.location = data1[index.row]["EventLocation"] as! String
            
            
            event.startDate = data1[index.row]["startDate"] as! [Int]
            event.endDate = data1[index.row]["endDate"] as! [Int]
            
            
        } else {
            
            
            let nav = segue.destinationViewController as! UINavigationController
            
            
            let detailInfo = nav.topViewController as! infoTableViewController
            
            
            let image = data1[index.row]["firstImage"] as! CKAsset
            let formated = UIImage(contentsOfFile: image.fileURL.path!)
            
            
            let image2 = data1[index.row]["secondImage"] as! CKAsset
            let formated2 = UIImage(contentsOfFile: image2.fileURL.path!)
            
            detailInfo.topI = formated
            detailInfo.labelTop = data1[index.row]["Title"] as! String
            
            detailInfo.arTitle = data1[index.row]["Title"] as! String
            detailInfo.arSubtitle = data1[index.row]["Subtitle"] as! String
            detailInfo.arImage = formated2
            detailInfo.arAticleText = data1[index.row]["article"] as! String
            
        }
    }
    
    
    
    
}


extension detailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data1.count
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        
        let dataL = data1[indexPath.row]
        
        
        
        
        if database == "Music" {
            
            if let image = dataL["albumImage"] {
                let image = image as! CKAsset
                let formated = UIImage(contentsOfFile: image.fileURL.path!)
                
                cell.cellImage.image = formated
                cell.titleLabel.text = dataL["albumText"] as? String
                cell.subtitle.text = "Michael Stuart"
                
            }
        } else if database == "Event" {
            
            if let image = dataL["eventImage"] {
                
                let im = image as! CKAsset
                let formated = UIImage(contentsOfFile: im.fileURL.path!)
                
                cell.cellImage.image = formated
                cell.titleLabel.text = dataL["Title"] as? String
                
                
                
            }
            
        } else {
            
            if let image = dataL["firstImage"] {
                
                let image = image as! CKAsset
                let formated = UIImage(contentsOfFile: image.fileURL.path!)
                
                cell.cellImage.image = formated
                cell.titleLabel.text = dataL["Title"] as? String
                cell.subtitle.text = dataL["Subtitle"] as? String
                
                
            }
            
            
        }
        
        
        
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        index = indexPath
        
        if database == "Hobbies" {
            performSegueWithIdentifier("masDetail", sender: indexPath.row)
        } else if database == "Music" {
            performSegueWithIdentifier("music1", sender: indexPath.row)
        } else if database == "Event" {
            performSegueWithIdentifier("event", sender: indexPath.row)
        } else {
            performSegueWithIdentifier("masDetail", sender: indexPath.row)
        }
    }
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        if DeviceType.IS_IPHONE_6 {
            return CGSize(width: 200, height: 370)
        } else if DeviceType.IS_IPHONE_6P {
            return CGSize(width: 200, height: 400)
        } else if DeviceType.IS_IPHONE_4_OR_LESS {
            return CGSize(width: 140, height: 250)
        }
        
        return CGSize(width: 180, height: 313)
        
    }
    
    
}


enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}


