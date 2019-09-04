//
//  MessageCollectionCell.swift
//  Mesh App
//
//  Created by Mac admin on 15/10/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class MessageCollectionCell: MessageBaseCollectionCell
{
    let imgProfileImage : UIImageView = {
        let newImageView = UIImageView()
        newImageView.contentMode = .scaleAspectFill
        newImageView.layer.cornerRadius = 4.0
        newImageView.layer.masksToBounds = true
        return newImageView
    }()
    
//    let viewDivider : UIView = {
//        let dividerLineView = UIView()
//        dividerLineView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
//        return dividerLineView
//    }()
    
    func setUpNewCell()
    {
        self.backgroundColor = UIColor.blue
        addSubview(imgProfileImage)
        //addSubview(viewDivider)
        
        imgProfileImage.image = UIImage(named: "gallery9")
        imgProfileImage.translatesAutoresizingMaskIntoConstraints = false
        //viewDivider.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H: | [v0(68)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : imgProfileImage]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V: | [v0(68)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : imgProfileImage]))
        
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H: | [-02-[v0]]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : viewDivider]))
//
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V: | [v0(1)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : viewDivider]))
    }
}
