//
//  EditProfileTableViewCell.swift
//  Mesh App
//
//  Created by Mac admin on 24/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var txtSubTitle: UITextField!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblExtraInfo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
