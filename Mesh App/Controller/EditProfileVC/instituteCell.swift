//
//  instituteCell.swift
//  EditProfileDesign
//
//  Created by Ruchi on 2/6/19.
//  Copyright © 2019 Ruchi. All rights reserved.
//

import UIKit

class instituteCell: UITableViewCell {

    @IBOutlet var lblTitleInInstitute: UILabel!
    
    @IBOutlet var txtPassingYear: UITextField!
    
    @IBOutlet var txtInstitute: UITextField!
    
    @IBOutlet var imgPlus: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
