//
//  MessageBaseCollectionCell.swift
//  Mesh App
//
//  Created by Mac admin on 15/10/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class MessageBaseCollectionCell: UICollectionViewCell
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        let objMessageCell:MessageCollectionCell = MessageCollectionCell()
        objMessageCell.setUpNewCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: has not been implemented")
    }
    
}
