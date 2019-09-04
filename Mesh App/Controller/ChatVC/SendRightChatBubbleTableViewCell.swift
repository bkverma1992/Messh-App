//
//  SendRightChatBubbleTableViewCell.swift
//  Mesh App
//
//  Created by Mac admin on 16/10/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class SendRightChatBubbleTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSendTime: UILabel!
    @IBOutlet weak var lblSendMsg: UILabel!
    @IBOutlet weak var viewSendChat: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewSendChat.layer.cornerRadius = 4.0
        self.viewSendChat.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
