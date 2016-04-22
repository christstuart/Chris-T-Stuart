//
//  infoTableViewController.swift
//  MichaelStuart
//
//  Created by Chris T Stuart on 3/22/16.
//  Copyright © 2016 Chris T Stuart. All rights reserved.
//

import UIKit

class infoTableViewController: UITableViewController {
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var topImage: UIImageView!
    @IBOutlet var tableView2: UITableView!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var aTitle: UILabel!
    @IBOutlet var aSubtitle: UILabel!
    @IBOutlet var aImage: UIImageView!
    @IBOutlet weak var aArticle: UITextView!
    
    var topI: UIImage!
    var labelTop = ""
    var arTitle = ""
    var arSubtitle = ""
    var arImage: UIImage!
    var arAticleText = ""
    var number: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topLabel.text = labelTop
        
        tableView.rowHeight = 800
        
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        
        topImage.image = topI
        
        aTitle.text = arTitle
        aSubtitle.text = arSubtitle
        aImage.image = arImage
        
        
        print(arAticleText)
        print(aArticle.text)
        
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController?.navigationBar.backItem?.title = ""
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.addSubview(headerView)
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            
            number = 480
            
            tableView.contentInset = UIEdgeInsets(top: number, left: 0, bottom: 0, right: 0)
            tableView.contentOffset = CGPoint(x: 0, y: -number)
            updateHeaderView(number)
            
        } else if DeviceType.IS_IPHONE_5 {
            
            number = 570
            
            theTable(570)
            
            
        } else if DeviceType.IS_IPHONE_6 {
            
            number = 670
            theTable(670)
            
        } else if DeviceType.IS_IPHONE_6P {
            
            
            number = 740
            theTable(740)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        
        aArticle.text = arAticleText
        
        aArticle.font?.fontWithSize(22)
        
        aArticle.textColor = UIColor.whiteColor()
    }
    
    
    func theTable(num: CGFloat) {
        
        
        
        tableView.contentInset = UIEdgeInsets(top: num, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -num)
        updateHeaderView(num)
        
        
    }
    
    @IBAction func dismiss(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func updateHeaderView(num: CGFloat) {
        
        var headerRect = CGRect(x: 0, y: -num, width: tableView.bounds.width, height: num)
        
        
        if tableView.contentOffset.y < -num {
            
            headerRect.origin.y = tableView.contentOffset.y
            
            headerRect.size.height = -tableView.contentOffset.y
            
            
        }
        
        headerView.frame = headerRect
        
    }
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView(number)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
    
    // Configure the cell...
    
    return cell
    }
    */
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
