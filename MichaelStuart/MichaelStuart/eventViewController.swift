//
//  eventViewController.swift
//  MichaelStuart
//
//  Created by Chris T Stuart on 3/18/16.
//  Copyright © 2016 Chris T Stuart. All rights reserved.
//

import UIKit
import MapKit
import EventKit
import EventKitUI

class eventViewController: UIViewController {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var topImage: UIImageView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var eventName: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var eventImage: UIImageView!
    
    let eventStore = EKEventStore()
    let kNoticeTitle = "Notice"
    let kSubtitle = "Allow Calendars on the settings page to have better use of this App."
    
    var topI: UIImage!
    var dropPin = MKPointAnnotation()
    var textForDate = ""
    var textForEvent = ""
    var textForPrice = ""
    var imageForEvent: UIImage!
    var lat: Double!
    var long: Double!
    var dropT = ""
    var dropS = ""
    var startDate = [Int]()
    var endDate = [Int]()
    var location = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topImage.image = topI
        mapView.delegate = self
        
        dateLabel.text = textForDate
        eventName.text = textForEvent
        priceLabel.text = textForPrice
        
        
        let fullsailLocation = CLLocationCoordinate2DMake(lat, long)
        
        dropPin.coordinate = fullsailLocation
        dropPin.title = dropT
        dropPin.subtitle = dropS
        mapView.addAnnotation(dropPin)
        
        
        
        let location = CLLocationCoordinate2D(latitude: dropPin.coordinate.latitude, longitude: dropPin.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let region = MKCoordinateRegionMake(location, span)
        
        mapView.setRegion(region, animated: true)
        
        
        
        let status = EKEventStore.authorizationStatusForEntityType(.Event)
        
        switch status {
        case .NotDetermined:
            eventStore.requestAccessToEntityType(.Event, completion: { (succ, error) -> Void in
                if succ {
                    print("Granted")
                    self.saveButton.enabled = true
                } else {
                    print("what")
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.saveButton.enabled = false
                    })
                    
                    print(error)
                }
            })
        case .Authorized:
            print("worked")
        case .Denied:
            
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            })
            
            self.showActionSheet(kNoticeTitle, message: kSubtitle, alertActions: [action])
            
            self.saveButton.enabled = false
            
        default:
            print("break")
        }
        
        
       
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func saveEvent(sender: UIButton) {
        
        let eventStartDateComponents = NSDateComponents()
        eventStartDateComponents.year = startDate[0]
        eventStartDateComponents.month = startDate[1]
        eventStartDateComponents.day = startDate[2]
        eventStartDateComponents.hour = startDate[3]
        eventStartDateComponents.minute = startDate[4]
        eventStartDateComponents.second = startDate[5]
        
        let eventStartDate = NSCalendar.currentCalendar().dateFromComponents(eventStartDateComponents)!
        
        
        let eventEndDateComponents = NSDateComponents()
        eventEndDateComponents.year = endDate[0]
        eventEndDateComponents.month = endDate[1]
        eventEndDateComponents.day = endDate[2]
        eventEndDateComponents.hour = endDate[3]
        eventEndDateComponents.minute = endDate[4]
        eventEndDateComponents.second = endDate[5]
        
        
        let eventEndDate = NSCalendar.currentCalendar().dateFromComponents(eventEndDateComponents)!
  
        
        let eVC = EKEventEditViewController()
        
        let event = EKEvent(eventStore: eventStore)
        
        eVC.event = event
        
        eVC.eventStore = eventStore
        
        eVC.event?.startDate = eventStartDate
        
        eVC.event?.endDate = eventEndDate
        
        eVC.event?.title = textForEvent
        
        eVC.event?.location = location
        
        eVC.editViewDelegate = self
        
        eVC.modalPresentationStyle = .Popover
        
        self.presentViewController(eVC, animated: true, completion: nil)
        
        
        
    }
    
    
    @IBAction func dismiss(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
}


extension eventViewController: EKEventEditViewDelegate {
    
    
    func eventEditViewController(controller: EKEventEditViewController, didCompleteWithAction action: EKEventEditViewAction) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
}


extension eventViewController: MKMapViewDelegate {
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if (annotation is MKUserLocation) {
            return nil
        }
        
        let reuseId = "Pin"
        
        let pin = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        
        
        if #available(iOS 9.0, *) {
            pin?.pinTintColor = UIColor.grayColor()
        } else {
            pin?.pinColor = MKPinAnnotationColor.Red
        }
        
        
        pin?.animatesDrop = true
        pin?.canShowCallout = true
        
        return pin
    }
    
    
    
}
