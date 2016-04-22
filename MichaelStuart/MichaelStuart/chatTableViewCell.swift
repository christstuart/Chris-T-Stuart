//
//  chatTableViewCell.swift
//  MichaelStuart
//
//  Created by Chris T Stuart on 3/29/16.
//  Copyright © 2016 Chris T Stuart. All rights reserved.
//

import UIKit

class chatTableViewCell: UITableViewCell {

    @IBOutlet var actualMsg: UILabel!
    @IBOutlet var name: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
