//
//  ReceiveLeftChatBubbleTableViewCell.swift
//  Mesh App
//
//  Created by Mac admin on 16/10/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class ReceiveLeftChatBubbleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblReceiveTime: UILabel!
    @IBOutlet weak var lblReceiveMsg: UILabel!
    @IBOutlet weak var viewReceiveChat: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.viewReceiveChat.layer.cornerRadius = 4.0
        //self.viewReceiveChat.layer.borderColor = UIColor.gray.cgColor
        //self.viewReceiveChat.layer.borderWidth = 1.0
        self.viewReceiveChat.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
