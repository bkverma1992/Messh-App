//
//  textfieldWithDescCell.swift
//  EditProfileDesign
//
//  Created by Ruchi on 2/6/19.
//  Copyright © 2019 Ruchi. All rights reserved.
//

import UIKit

class textfieldWithDescCell: UITableViewCell {

    @IBOutlet var lblTitleInDesc: UILabel!
    
    @IBOutlet var txtFieldInDesc: UITextField!
    @IBOutlet weak var txtViewInDesc: UITextView!
    
    @IBOutlet var lblInDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
