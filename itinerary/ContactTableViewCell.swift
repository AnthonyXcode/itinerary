//
//  ContactTableViewCell.swift
//  itinerary
//
//  Created by Anthony on 5/4/16.
//  Copyright © 2016 Anthony. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactNameLab: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
