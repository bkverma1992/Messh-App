//
//  ContactListTableViewCell.swift
//  Mesh App
//
//  Created by Mac admin on 28/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class ContactListTableViewCell: UITableViewCell {

    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var lblContactNo: UILabel!
    @IBOutlet weak var lblContactName: UILabel!
    @IBOutlet weak var imgContactProfile: UIImageView!
    @IBOutlet weak var lblTitleName: UILabel!
    
    weak var cellContactDelegate: ContactListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgContactProfile.layer.cornerRadius = 4.0 //self.imgContactProfile.frame.size.height/2
        self.imgContactProfile.layer.masksToBounds = true
        
        self.btnInvite.layer.cornerRadius = 4.0
        self.btnInvite.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnInvite_Click(_ sender: UIButton)
    {
        cellContactDelegate?.didPressInviteButton(sender.tag)
    }
}

protocol ContactListCellDelegate : class {
    func didPressInviteButton(_ tag: Int)
}

