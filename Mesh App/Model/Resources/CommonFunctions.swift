//
//  CommonFunctions.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 02/11/2018.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class CommonFunctions: NSObject {
        
    class func giveBottomShadowToView(_view: UIView)
    {
        _view.layer.shadowOffset = CGSize(width: 0, height: 2)
        _view.layer.shadowOpacity = 0.6
        _view.layer.shadowRadius = 3.0
        _view.layer.shadowColor = UIColor.red.cgColor
    }
}
