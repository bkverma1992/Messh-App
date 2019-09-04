//
//  CreateGroupTableViewCell.swift
//  Mesh App
//
//  Created by Mac admin on 03/10/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class CreateGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgProfile.layer.cornerRadius = 4.0 //self.imgContactProfile.frame.size.height/2
        self.imgProfile.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
