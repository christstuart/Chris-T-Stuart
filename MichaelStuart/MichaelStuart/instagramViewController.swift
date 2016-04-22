//
//  instagramViewController.swift
//
//
//  Created by Chris T Stuart on 3/30/16.
//
//

import UIKit
import SwiftyJSON

class instagramViewController: UIViewController {
    
    @IBOutlet var theCollectionView: UICollectionView!
    
    var contentImages = [Image]()
    var contentText = [String]()
    var mySerialQueue: dispatch_queue_t!
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        mySerialQueue = dispatch_queue_create("instaSerial", DISPATCH_QUEUE_SERIAL)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(instagramViewController.networkStatusChanged(_:)), name: ReachabilityStatusChangedNotification, object: nil)
        Reach().monitorReachabilityChanges()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func networkStatusChanged(notification: NSNotification) {
        
        
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
                getInstaData()
                
                
                
            case .Online(.WiFi):
                
                self.count = 1
                getInstaData()
                
                
            }
        }
        
    }
    
    
    
    func getInstaData() {
        
        
        let actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(actInd)
        actInd.startAnimating()
        
        let url = NSURL(string: "https://api.instagram.com/v1/users/self/media/recent/?access_token=23558641.1677ed0.1cb52bb1d04f4126a76f349716dc94d7&count=20")
        
        // creating a  NSURLSessionConfiguration
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        // creating a session
        
        let session = NSURLSession(configuration: config)
        
        if url == url {
            
            session.dataTaskWithURL(url!) { (data, response, error) -> Void in
                
                if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200, let data = data {
                    let json = JSON(data: data)
                    
                    let data = json["data"].array
                    
                    
                    if let data = data {
                        
                        
                        
                        for i in data {
                            
                            // print(i["caption"].dictionary)
                            
                            if let caption = i["caption"].dictionary {
                                
                                
                                print(caption["text"]?.string)
                                
                                self.contentText.append((caption["text"]?.string)!)
                                
                            }
                            
                            let images = i["images"].dictionary
                            if let images = images {
                                
                                print(images);
                                
                                let standar = images["standard_resolution"]?.dictionary
                                if let standar = standar {
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        
                                        
                                        self.contentImages.append(Image(image: UIImage(data: NSData(contentsOfURL: NSURL(string: standar["url"]!.string!)!)!)!))
                                        
                                        
                                        self.theCollectionView.reloadData()
                                        actInd.stopAnimating()
                                        
                                    })
                                }
                                
                            }
                        }
                    }
                    
                    
                }
                
                }.resume()
            
        }

        
    }
    
    
    override func viewDidAppear(animated: Bool) {
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

extension instagramViewController: UICollectionViewDelegate, UICollectionViewDataSource, JTSImageViewControllerInteractionsDelegate {
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // Create image info
        let imageInfo: JTSImageInfo = JTSImageInfo()
        imageInfo.image = contentImages[indexPath.row].image
        
        let imageViewer: JTSImageViewController = JTSImageViewController(imageInfo: imageInfo, mode: .Image, backgroundStyle: .Blurred)
        // Present the view controller.
        
        
        imageViewer.showFromViewController(self, transition: .FromOffscreen)
        
        
    }
    
    func imageViewerDidLongPress(imageViewer: JTSImageViewController!, atRect rect: CGRect) {
        
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! instagramCollectionViewCell
        
        
            cell.customImage.image = self.contentImages[indexPath.item].image
            cell.desc.text = self.contentText[indexPath.row]
      
        
        cell.layer.cornerRadius = 5.0
        cell.layer.shadowColor = UIColor.grayColor().CGColor
        
        return cell
        
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
}