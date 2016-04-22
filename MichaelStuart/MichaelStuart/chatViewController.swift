//
//  chatViewController.swift
//  MichaelStuart
//
//  Created by Chris T Stuart on 3/29/16.
//  Copyright © 2016 Chris T Stuart. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class chatViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var msgInput: UITextField!
    @IBOutlet var tableView: UITableView!
    
    var chat: NSMutableArray = NSMutableArray()
    var firebase: Firebase = Firebase(url: "https://michael-stuart.firebaseio.com")
    var name: String = "Guest"
    var people = [String]()
    
    var values = [AnyObject]()
    
    var prefs = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController?.navigationBar.backItem?.title = ""
        
        
        fetchName()
        
        name = people[0]
        
        self.firebase.observeEventType(.ChildAdded, withBlock: {snapshot in
           
            print(snapshot)
            
            self.values.append(snapshot.value)
            
            //print(self.values[0]["text"])
            
            print(self.values.count)
            
            self.tableView!.reloadData()
        })
        
        
        self.firebase.observeEventType(.ChildChanged, withBlock: {snapshot in
            
            let body = snapshot.value["text"] as! String
            
            self.values.removeLast()
            
            self.values.append(snapshot.value)
            
            self.tableView.reloadData()
            
            print(self.values.count)
            
            print(body)
            
        })
        
        
        
        
       
        
        self.firebase.observeEventType(.ChildAdded, withBlock: {snapshot in
            
            print(snapshot.value)
            
            let body = snapshot.value["text"] as! String
            var bodies = [String]()
            
            
            print(body)
            
            bodies.append(body)
            
            
            // print(bodies)
            
            
            
            
            for i in badWord {
                
                
                if body.containsString(i) {
                    
                    
                    var value = [String:String]()
                    value = ["name": self.name, "text":"Comment removed"]
                    
                    self.firebase.updateChildValues([snapshot.key : value])
                    
                    
                    
                    self.tableView.reloadData()
                    
                    
                }
            }
            
            
            
            
            
            
            
        })
        
       

        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        var value = [String:String]()
        value = ["name": self.name, "text": msgInput!.text!]
        

        
        self.firebase.childByAutoId().setValue(value)
        
        textField.text = ""
        
        
        scrollToBottom(true)
        
        return false
        
    }
    
    @IBAction func pop(sender: UIButton) {
        
        performSegueWithIdentifier("bye", sender: sender)
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        scrollToBottom(true)
    }
    

    
    func fetchName() {
        
        
        if let name = prefs.stringForKey("user"){
            
            people.append(name)
        }
        
//        //1
//        let appDelegate =
//            UIApplication.sharedApplication().delegate as! AppDelegate
//        
//        let managedContext = appDelegate.managedObjectContext
//        
//        //2
//        let fetchRequest = NSFetchRequest(entityName: "User")
//        
//        //3
//        do {
//            let results =
//                try managedContext.executeFetchRequest(fetchRequest)
//            people = results as! [NSManagedObject]
//        } catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }
        
    }
    

    func scrollToBottom(animated: Bool) {
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRowsInSection(numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
            }
            
        })
    }

    
    
    
}



extension chatViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
       
        
        cell.textLabel!.text = self.values[indexPath.row]["text"] as? String
        cell.detailTextLabel!.text = self.values[indexPath.row]["name"] as? String
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return 1
    }
    
}
