//
//  ItinTableViewCell.swift
//  itinerary
//
//  Created by Anthony on 5/6/16.
//  Copyright © 2016 Anthony. All rights reserved.
//

import UIKit

class ItinTableViewCell: UITableViewCell {
    @IBOutlet weak var alermTimeLab: UILabel!
    @IBOutlet weak var senderImage: UIImageView!
    @IBOutlet weak var senderNameLab: UILabel!
    @IBOutlet weak var msgLab: UILabel!
    @IBAction func setAlarmSwh(sender: AnyObject) {
    }
    @IBOutlet weak var setAlarmSwh: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
