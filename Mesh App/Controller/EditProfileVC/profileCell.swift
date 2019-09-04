//
//  profileCell.swift
//  EditProfileDesign
//
//  Created by Ruchi on 2/6/19.
//  Copyright © 2019 Ruchi. All rights reserved.
//

import UIKit

class profileCell: UITableViewCell {
    @IBOutlet weak var btnUserProfile: UIButton!
    @IBOutlet weak var imgUserProfile: UIImageView!
    weak var cellProfileDelegate: ImageProfileDelegate?

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgUserProfile.layer.cornerRadius = 4.0
        self.imgUserProfile.layer.masksToBounds = true
        self.imgUserProfile.layer.borderColor = UIColor.lightGray.cgColor
        self.imgUserProfile.layer.borderWidth = 1.0
        
        self.btnUserProfile.layer.cornerRadius = 4.0
        self.btnUserProfile.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnProfileChange_Click(_ sender: UIButton)
    {
        cellProfileDelegate?.didChangeImage(sender.tag)
    }
}

protocol ImageProfileDelegate : class {
    func didChangeImage(_ tag: Int)
    //func didPressMenuButton(_tag: Int )
}
