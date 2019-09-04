//
//  GroupAdminSearchTableViewCell.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 24/06/2019.
//  Copyright © 2019 Swati. All rights reserved.
//

import UIKit

class GroupAdminSearchTableViewCell: UITableViewCell {

    @IBOutlet var lblParticipateName: UILabel!
    @IBOutlet var lblShortBio: UILabel!
    @IBOutlet var imgParticipateImage: UIImageView!
    @IBOutlet var adminBTN: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
