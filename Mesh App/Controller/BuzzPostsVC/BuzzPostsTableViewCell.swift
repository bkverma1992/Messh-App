//
//  BuzzPostsTableViewCell.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 13/12/2018.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit
import SwiftMessageBar
import SwiftLinkPreview
import AlamofireImage
import ImageSlideshow

class BuzzPostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblUserProfession: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var centerLoadingActivityIndicatorView: UIActivityIndicatorView?
    @IBOutlet weak var viewPostText: UIView!
    //@IBOutlet private weak var textField: UITextField?
    //@IBOutlet private weak var randomTextButton: UIButton?
    @IBOutlet weak var submitButton: UIButton?
    @IBOutlet weak var openWithButton: UIButton?
    @IBOutlet weak var indicatorPreviewArea: UIActivityIndicatorView?
    @IBOutlet weak var viewPreviewArea: UIView?
    @IBOutlet weak var lblPreviewArea: UILabel?
    @IBOutlet weak var slideshow: ImageSlideshow?
    @IBOutlet weak var lblBuzzPostTitle: UILabel?
    @IBOutlet weak var lblBuzzPostUrl: UILabel?
    @IBOutlet weak var lblBuzzPostDescription: UILabel?
    @IBOutlet weak var viewDetailed: UIView?
    @IBOutlet weak var imgUrlPic: UIImageView?

    @IBOutlet weak var imgBuzzPostPic: UIImageView!
    @IBOutlet weak var lblBuzzPostText: UILabel!
    @IBOutlet weak var btnReportShare: UIButton!
    
    @IBOutlet weak var btnLink: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgUserProfile.layer.cornerRadius = 4.0
        self.imgUserProfile.layer.masksToBounds = true
        //self.imgUrlPic!.layer.cornerRadius = 4.0
        //self.imgUrlPic!.layer.masksToBounds = true
        self.imgBuzzPostPic.layer.cornerRadius = 4.0
        self.imgBuzzPostPic.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
