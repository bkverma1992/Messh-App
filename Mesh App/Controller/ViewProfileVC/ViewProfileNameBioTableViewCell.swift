//
//  ViewProfileNameBioTableViewCell.swift
//  Mesh App
//
//  Created by Mac admin on 27/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class ViewProfileNameBioTableViewCell: UITableViewCell {
    
    weak var cellBioDelegate: cellEditBioDelegate?

    @IBOutlet weak var btnEditInfo: UIButton!
    @IBOutlet weak var viewNameBio: UIView!
    @IBOutlet weak var lblShortBio: UILabel!
    @IBOutlet weak var lblDesignation: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnEdit_Click(_ sender: UIButton)
    {
        cellBioDelegate?.didEditButton_Click(sender.tag)
    }
}

protocol cellEditBioDelegate : class {
    func didEditButton_Click(_ tag: Int)
}
