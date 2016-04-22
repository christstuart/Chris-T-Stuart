import UIKit
import TwitterKit

class twitterViewController: TWTRTimelineViewController {
    
    var count = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = TWTRAPIClient()
        let dataSource = TWTRUserTimelineDataSource(screenName: "MICHAELSTUARTc", APIClient: client)
        
        self.dataSource = dataSource
        
        self.showTweetActions = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(twitterViewController.networkStatusChanged(_:)), name: ReachabilityStatusChangedNotification, object: nil)
        Reach().monitorReachabilityChanges()
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController?.navigationBar.backItem?.title = ""
        
        
        
        // Do any additional setup after loading the view.
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
                

                
                
            case .Online(.WiFi):
                
                self.count = 1
                
                
                
            }
        }
        
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
