//
//  TableViewCell.swift
//  MichaelStuart
//
//  Created by Chris T Stuart on 2/28/16.
//  Copyright © 2016 Chris T Stuart. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var bgImage: UIImageView!
    @IBOutlet var cellText: UILabel!
    @IBOutlet var bgText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
