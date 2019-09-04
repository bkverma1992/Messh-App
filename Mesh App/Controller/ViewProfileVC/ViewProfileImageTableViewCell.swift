//
//  ViewProfileImageTableViewCell.swift
//  Mesh App
//
//  Created by Mac admin on 26/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class ViewProfileImageTableViewCell: UITableViewCell, menuViewDelegate
{
    weak var cellMyImageDelegate: MyProfileImageCellDelegate?
    @IBOutlet weak var lblProfileText: UILabel!
    @IBOutlet weak var imgUserImage: UIImageView!
    @IBOutlet var backBTN: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
   
    
    func navigateToController(index: Int)
    {
        if index == 0
        {
            //let objPrivacyVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idPrivacyVC") as! PrivacyVC
            //self.navigationController?.pushViewController(objPrivacyVC, animated: true)
        }
        else if index == 1
        {
            //let objEditProfileVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idEditProfileVC") as! EditProfileVC
            //self.navigationController?.pushViewController(objEditProfileVC, animated: true)
        }
        else if index == 2
        {
           // let objCreateGroupVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idCreateGroupVC") as! CreateGroupVC
            //self.navigationController?.pushViewController(objCreateGroupVC, animated: true)
        }
        else if index == 3
        {
            //let objFaqVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idFaqVC") as! FaqVC
            //self.navigationController?.pushViewController(objFaqVC, animated: true)
        }
    }

    @IBAction func btnMenu_Click(_ sender: UIButton)
    {
        cellMyImageDelegate?.didMyProfileMenuButton(sender.tag)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

protocol MyProfileImageCellDelegate : class {
    func didMyProfileMenuButton(_ tag: Int)
    //func didPressMenuButton(_tag: Int )
}
