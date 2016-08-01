//
//  MessageTableViewCell.swift
//  itinerary
//
//  Created by Anthony on 5/5/16.
//  Copyright © 2016 Anthony. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    var testStr:String!
    @IBOutlet weak var sentMsg: UILabel!
    @IBOutlet weak var sentTiem: UILabel!
    @IBOutlet weak var realTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        testStr = "abc"
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
