//
//  ViewProfileTableViewCell.swift
//  Mesh App
//
//  Created by Mac admin on 26/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class ViewProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var viewProfileInfo: UIView!
    @IBOutlet weak var lblProfileTitle: UILabel!
    @IBOutlet weak var lblProfileDescription: UILabel!
    @IBOutlet weak var imgProfileDetails: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //CommonFunctions.giveBottomShadowToView(_view: self.viewProfileInfo)

        // Configure the view for the selected state
    }

}
