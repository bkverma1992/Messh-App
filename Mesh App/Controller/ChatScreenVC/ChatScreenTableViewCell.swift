//
//  ChatScreenTableViewCell.swift
//  Mesh App
//
//  Created by Mac admin on 11/10/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class ChatScreenTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var imgFriendImage: UIImageView!
    @IBOutlet weak var lblSentTime: UILabel!
    @IBOutlet weak var lblFriendMessage: UILabel!
    @IBOutlet weak var lblNameLocation: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        self.viewMessage.layer.cornerRadius = 4.0
        self.imgFriendImage.layer.cornerRadius = 4.0
        self.imgFriendImage.layer.borderColor = UIColor.lightGray.cgColor
        self.imgFriendImage.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
