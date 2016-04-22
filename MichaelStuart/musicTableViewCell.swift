//
//  musicTableViewCell.swift
//  MichaelStuart
//
//  Created by Chris T Stuart on 3/9/16.
//  Copyright © 2016 Chris T Stuart. All rights reserved.
//

import UIKit

class musicTableViewCell: UITableViewCell {
   
    @IBOutlet var songNumber: UILabel!
    @IBOutlet var songName: UILabel!
    @IBOutlet var songTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
