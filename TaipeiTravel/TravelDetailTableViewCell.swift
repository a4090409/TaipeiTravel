//
//  TravelDetailTableViewCell.swift
//  TaipeiTravel
//
//  Created by ChinBuck on 2017/2/12.
//  Copyright © 2017年 ChinBuck. All rights reserved.
//

import UIKit

class TravelDetailTableViewCell: UITableViewCell {

    
    @IBOutlet  var FieldLabel:UILabel!
    @IBOutlet var  ValueLabel:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
