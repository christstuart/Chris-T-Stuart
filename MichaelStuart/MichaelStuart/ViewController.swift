//
//  ViewController.swift
//  MichaelStuart
//
//  Created by Chris T Stuart on 2/28/16.
//  Copyright © 2016 Chris T Stuart. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    
    @IBOutlet var tableView: UITableView!
    
    var indexPath1: NSIndexPath!
    
    let cellImages = ["social","fans","surf","music","style","event","artist"]
    let cellText = ["Social Media","Fan Chat","Hobbies","Music","MyStyle","Event","Artist"]
    let cellSort = ["nothing","nothig","Title","albumText","Title","Title","Title"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cellImages.count
        
        
        tableView.rowHeight = 100
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController?.navigationBar.backItem?.title = ""
        
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Moon", size: 20)!]
        
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeAction(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        
        
        
    }
    
    
}

extension ViewController: UITableViewDataSource{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TableViewCell
        
        cell.bgImage.image = UIImage(named: cellImages[indexPath.row])
        cell.cellText.text = cellText[indexPath.row]
        
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        indexPath1 = indexPath
        
        print(cellText[indexPath.row])
        
        if cellText[indexPath.row] == "Fan Chat" {
            
            performSegueWithIdentifier("email", sender: indexPath.row)
            
        } else if cellText[indexPath.row] == "Social Media" {
            
            performSegueWithIdentifier("social", sender: indexPath.row)
            
        } else {
            
            performSegueWithIdentifier("detail", sender: indexPath.row)
            
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "detail" {
            
            let detail = segue.destinationViewController as! detailViewController
            
            detail.topImageUI = UIImage(named: cellImages[indexPath1.row])
            detail.database = cellText[indexPath1.row]
            detail.topLabelText = cellText[indexPath1.row]
            detail.sort1 = cellSort[indexPath1.row]
            
            
        } else if segue.identifier == "email" {
            
            let email = segue.destinationViewController as! userViewController
            
            
            email.topI = UIImage(named: cellImages[indexPath1.row])
            
        }
    }
    
    
    
}
