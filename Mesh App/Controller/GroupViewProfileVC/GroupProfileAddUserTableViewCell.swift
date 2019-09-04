//
//  GroupProfileAddUserTableViewCell.swift
//  Mesh App
//
//  Created by Mac admin on 27/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class GroupProfileAddUserTableViewCell: UITableViewCell {

    @IBOutlet weak var imgInviteLink: UIImageView!
    @IBOutlet weak var btnAddParticipants: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var lblTotalParticipants: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
