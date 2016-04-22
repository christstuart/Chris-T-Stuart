//
//  userViewController.swift
//  MichaelStuart
//
//  Created by Chris T Stuart on 3/28/16.
//  Copyright © 2016 Chris T Stuart. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import CloudKit
import TextFieldEffects

class userViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailField: HoshiTextField!
    @IBOutlet var topImage: UIImageView!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var fullName: HoshiTextField!
    
    
    var topI: UIImage!
    var people = [String]()
    var names = [String]()
    
    var prefs = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        topImage.image = topI
        
        emailField.delegate = self
        fullName.delegate = self
        
        fullName.returnKeyType = .Done
        emailField.returnKeyType = .Next
        
        doneButton.layer.cornerRadius = 2
        
        // Do any additional setup after loading the view.
        
        fetchName()
        
        
        if people.count == 0 {
            
            print("ok stay here")
            
        } else {
            
            
            
            print("keep going")
            
            performSegueWithIdentifier("chat", sender: self)
            
            
        }
        
        
    
        
        
        let firebaselink = Firebase(url: "https://michael-stuart.firebaseio.com/")
        
        
        
        firebaselink.observeEventType(.ChildAdded, withBlock: {snapshot in
            
            
            
            self.names.append(snapshot.value["name"] as! String)
            
            
        })
        
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        emailField.layer.borderColor = UIColor.redColor().CGColor
        emailField.layer.borderWidth = 0
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            
            if textField == fullName {
                
                animateViewMoving(true, moveValue: 80)
            }
            
        }
        
        animateViewMoving(true, moveValue: 130)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            
            if textField == fullName {
                
                animateViewMoving(false, moveValue: 80)
            }
            
        }
        
        animateViewMoving(false, moveValue: 130)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailField {
            emailField.resignFirstResponder()
            fullName.becomeFirstResponder()
            
        } else {
            
            fullName.resignFirstResponder()
            fullName.returnKeyType = .Done
            
            if emailField.text == "" && fullName.text == "" {
                showAlertWithTitle("Please provide a email and a name.")
            } else if isValidEmail(emailField.text!) == false {
                showAlertWithTitle("Please provide a correct email.")
            } else if fullName.text == "" {
                showAlertWithTitle("Please provide a name.")
            }
            else  {
                
                print("everything fine.")
                
            }
            
            
            
        }
        return true
    }
    
    
    func saveName(name: String) {
        
        
        var check = [String]()
        
        let lowerCaseName = name.lowercaseString
        
        check.append(lowerCaseName)
        
        for i in badWord {
            
            
            if check.contains(i) {
                
                
                showAlertWithTitle("Innapropiate name.")
                
                return
                
            }
            
        }
        
        
        
        
        
        
        print(names)
        
        print(check)
        
        
        for i in self.names {
            
            let name = i.lowercaseString
            
            if check.contains(name) {
                
                
                
                
                self.showAlertWithTitle("Name already taken.")
                return
            }
            
        }
        
        
        
        
        prefs.setValue(name, forKey: "user")
        
        let name = prefs.stringForKey("user")
        
        print(name)
        
       // people.append(name!)
        
        saveEmail(emailField.text!)
        performSegueWithIdentifier("chat", sender: self)
        
        
        //        //1
        //        let appDelegate =
        //            UIApplication.sharedApplication().delegate as! AppDelegate
        //
        //        let managedContext = appDelegate.managedObjectContext
        //
        //        //2
        //        let entity =  NSEntityDescription.entityForName("User",
        //                                                        inManagedObjectContext:managedContext)
        //
        //        let person = NSManagedObject(entity: entity!,
        //                                     insertIntoManagedObjectContext: managedContext)
        //
        //        //3
        //        person.setValue(name, forKey: "name")
        //
        //        //4
        //        do {
        //            try managedContext.save()
        //            //5
        //            people.append(person)
        //            saveEmail(emailField.text!)
        //            performSegueWithIdentifier("chat", sender: self)
        //        } catch let error as NSError  {
        //            print("Could not save \(error), \(error.userInfo)")
        //        }
        
        
        
        
        
        
        
        
        
        
    }
    
    @IBAction func save(sender: UIButton) {
        
        if emailField.text == "" && fullName.text == "" {
            showAlertWithTitle("Please provide an email and a name.")
        } else if isValidEmail(emailField.text!) == false {
            showAlertWithTitle("Please provide a correct email.")
        } else if fullName.text == "" {
            
            showAlertWithTitle("Provide a name.")
            
        } else {
            if people.count == 0 {
                saveName(fullName.text!)
            }
        }
        
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        
        
        return emailTest.evaluateWithObject(testStr)
    }
    
    
    func fetchName() {
        
        
      //  let name = prefs.stringForKey("user")
        
        if let name = prefs.stringForKey("user"){
            
            people.append(name)
        }
        
    }
    
    
    func remove() {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try managedContext.executeRequest(deleteRequest)
            } catch  {
                // TODO: handle the error
            }
        } else {
            
            let appDelegate =
                UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext
            
            let allCars: NSFetchRequest = NSFetchRequest()
            allCars.entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedContext)
            allCars.includesPropertyValues = false
            //only fetch the managedObjectID
            do {
                let cars: [AnyObject] = try managedContext.executeFetchRequest(allCars)
                //  allCars
                //error handling goes here
                for car in cars {
                    managedContext.deleteObject(car as! NSManagedObject)
                }
                do {
                    try managedContext.save()
                } catch {
                    
                }
            } catch {
                
            }
            
            
        }
        
        
    }
    
    
    
    
    
    func saveEmail(email:String) {
        
        let record = CKRecord(recordType: "User")
        
        
        record.setValue(email, forKey: "email")
        
        
        CKContainer.defaultContainer().publicCloudDatabase.saveRecord(record) { (record, error) -> Void in
            guard error == nil else {
                print(error)
                return
            }
            
            print(record)
            
            
            
        }
        
        
        
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
