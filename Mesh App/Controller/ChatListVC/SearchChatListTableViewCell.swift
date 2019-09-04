//
//  SearchChatListTableViewCell.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 07/01/2019.
//  Copyright © 2019 Swati. All rights reserved.
//

import UIKit

class SearchChatListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblChatText: UILabel!
    @IBOutlet weak var lblChatTime: UILabel!
    @IBOutlet weak var lblChatUserName: UILabel!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgProfile.layer.cornerRadius = 4.0
        self.imgProfile.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
