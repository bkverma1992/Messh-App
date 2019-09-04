//
//  CreateGroupCollectionViewCell.swift
//  Mesh App
//
//  Created by Mac admin on 03/10/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class CreateGroupCollectionViewCell: UICollectionViewCell
{
    weak var cellParticipantsDelegate: DeleteParticipantsDelegate?
    
    @IBOutlet weak var lblSelParName: UILabel!
    @IBOutlet weak var btnDeleteParticipants: UIButton!
    @IBOutlet weak var imgParticipantsProfile: UIImageView!
    
    @IBAction func btnDelete_Click(_ sender: UIButton)
    {
        cellParticipantsDelegate?.didDeleteCell_Click(sender.tag)
    }
}

protocol DeleteParticipantsDelegate : class {
    //func didDeleteCell_Click(_ tag: Int, _strImage: String)
    func didDeleteCell_Click(_ tag: Int)
}
