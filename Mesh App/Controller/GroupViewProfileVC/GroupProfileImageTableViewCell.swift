//
//  GroupProfileImageTableViewCell.swift
//  Mesh App
//
//  Created by Mac admin on 27/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class GroupProfileImageTableViewCell: UITableViewCell {

    @IBOutlet weak var btnNext: UIButton!
    
    weak var cellDelegate: GroupProfileImageCellDelegate?
    
    @IBOutlet weak var imgGroupProfile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    // connect the button from your cell with this method
    @IBAction func buttonPressed(_ sender: UIButton) {
        cellDelegate?.didPressButton(sender.tag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

protocol GroupProfileImageCellDelegate : class {
        func didPressButton(_ tag: Int)
        //func didPressMenuButton(_tag: Int )
}

extension String
{    
    func base64ToImage() -> UIImage? {
        
        if let url = URL(string: self),let data = try? Data(contentsOf: url),let image = UIImage(data: data) {
            return image
        }
        return nil        
    }
}

