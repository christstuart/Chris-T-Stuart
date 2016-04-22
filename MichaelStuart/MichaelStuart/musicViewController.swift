//
//  musicViewController.swift
//  MichaelStuart
//
//  Created by Chris T Stuart on 3/9/16.
//  Copyright © 2016 Chris T Stuart. All rights reserved.
//

import UIKit
import CloudKit

class musicViewController: UIViewController {
    
    @IBOutlet var topImage: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var albumLabel: UILabel!
    
    var topI: UIImage!
    var string = ""
    var index: NSIndexPath!
    
    var albumName = ""
    var albumSongs = [String]()
    var albumTime = [String]()
    var albumNumber = [String]()
    var songs = [String]()
    var albumLink = ""
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView.tableFooterView = UIView(frame: CGRectZero)
        
        albumLabel.text = albumName
        topImage.image = topI
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func buyAlbum(sender: UIButton) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: albumLink)!)
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let songView = segue.destinationViewController as! songViewController
        
        // print(albumTime[index.row])
        
        songView.time = albumTime[index.row]
        songView.song = albumSongs[index.row]
        songView.image = topI
        songView.stream = songs[index.row]
        
    
        
    }
    
    
    
    
}


extension musicViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! musicTableViewCell
        
        cell.songName.text = albumSongs[indexPath.row]
        cell.songTime.text = albumTime[indexPath.row]
        cell.songNumber.text = albumNumber[indexPath.row]
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumSongs.count
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        index = indexPath
        performSegueWithIdentifier("song", sender: indexPath.row)
        
    }
    
    
    
}


