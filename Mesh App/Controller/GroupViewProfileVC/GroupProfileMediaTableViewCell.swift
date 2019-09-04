//
//  GroupProfileMediaTableViewCell.swift
//  Mesh App
//
//  Created by Mac admin on 27/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class GroupProfileMediaTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet weak var groupMediaNewCollection: UICollectionView!
    
    weak var cellSelectedGroupMediaDelegate: SelectedGroupMediaCellDelegate?
    
    var arrMediaImages  = NSMutableArray();
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
         arrMediaImages = ["pic1","pic2","pic3", "pic4"]
        
        self.groupMediaNewCollection.delegate = self
        self.groupMediaNewCollection.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Collection View Datasource and Delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMediaImages.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell : GroupProfileMediaCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "idGroupMediaCollectionCell", for: indexPath) as! GroupProfileMediaCollectionViewCell
        
        let imageString : String  = String.init(format: "%@", arrMediaImages[indexPath.item] as! CVarArg);
        cell.imgGroupMediaImages.image = UIImage.init(named: "\(imageString)");
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let imageString : String  = String.init(format: "%@", arrMediaImages[indexPath.item] as! CVarArg);
        //        DefaultsValues.setStringValueToUserDefaults(imageString, forKey: "mediaImage")
        //        NotificationCenter.default.post(name: .pushViewController, object: nil)
        
        cellSelectedGroupMediaDelegate?.didSelectGroupMedia_Click(indexPath.item, _strImage: imageString)
    }
    
    @IBAction func btnAllMediaList_Click(_ sender: UIButton)
    {
        cellSelectedGroupMediaDelegate?.didPressMediaButton(sender.tag)
    }
}

protocol SelectedGroupMediaCellDelegate : class {
    func didSelectGroupMedia_Click(_ tag: Int, _strImage: String)
    func didPressMediaButton(_ tag: Int)
}
