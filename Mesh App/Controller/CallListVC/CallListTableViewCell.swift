//
//  CallListTableViewCell.swift
//  Mesh App
//
//  Created by Mac admin on 24/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class CallListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCallType: UIImageView!
    @IBOutlet weak var lblCallTime: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var imgCallProfile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
