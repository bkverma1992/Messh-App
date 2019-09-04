//
//  textfieldCell.swift
//  EditProfileDesign
//
//  Created by Ruchi on 2/6/19.
//  Copyright © 2019 Ruchi. All rights reserved.
//

import UIKit

class textfieldCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var txtfield: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
