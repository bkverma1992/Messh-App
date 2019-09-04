//
//  GroupProfileNameBioTableViewCell.swift
//  Mesh App
//
//  Created by Mac admin on 27/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class GroupProfileNameBioTableViewCell: UITableViewCell
{
    weak var cellEditDelegate: GroupEditDelegate?

    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblGroupSubject: UILabel!
    @IBOutlet weak var lblGroupTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
//        let objParticipants =   Participants.init(dictionary: (self.arrAllParticipantsInfo[0] as? NSDictionary)!)
//
//        let isAdmin = objParticipants!.isAdmin
//
//        if isAdmin == true
//        {
//
//        }else
//        {
//
//        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnGroupEdit_Click(_ sender: UIButton)
    {
         cellEditDelegate?.didPressEditButton(sender.tag)
    }
}

protocol GroupEditDelegate : class {
    func didPressEditButton(_ tag: Int)
}
