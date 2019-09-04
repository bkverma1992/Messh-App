//
//  GroupFullProfileTableViewCell.swift
//  Mesh App
//
//  Created by Mac admin on 27/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class GroupFullProfileTableViewCell: UITableViewCell
{
    @IBOutlet weak var lblParticipantsShortBio: UILabel!
    @IBOutlet weak var imgParticipantsProfile: UIImageView!
    @IBOutlet weak var lblParticipantsName: UILabel!    
    @IBOutlet weak var btnIsAdmin: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


