//
//  ViewProfileMediaTableViewCell.swift
//  Mesh App
//
//  Created by Mac admin on 04/10/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class ViewProfileMediaTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var profileMediaCollectionView: UICollectionView!
    
    @IBOutlet weak var viewMedia: UIView!
    
    weak var cellSelectedMyMediaDelegate: selectedMyMediaDelegate?
    
    var arrMediaImages  = NSMutableArray();
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        arrMediaImages = ["pic1","pic2","pic3", "pic4"]
        
        self.profileMediaCollectionView.delegate = self
        self.profileMediaCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnNext_Click(_ sender: UIButton)
    {
        cellSelectedMyMediaDelegate?.didSelectMyMedia_Click(sender.tag)
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
        let cell : ViewProfileMediaCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "idProfileMediaCollectionCell", for: indexPath) as! ViewProfileMediaCollectionViewCell
        
        let imageString : String  = String.init(format: "%@", arrMediaImages[indexPath.item] as! CVarArg);
        cell.imgMediaProfile.image = UIImage.init(named: "\(imageString)");
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let imageString : String  = String.init(format: "%@", arrMediaImages[indexPath.item] as! CVarArg);
        //        DefaultsValues.setStringValueToUserDefaults(imageString, forKey: "mediaImage")
        //        NotificationCenter.default.post(name: .pushViewController, object: nil)
        
        cellSelectedMyMediaDelegate?.didSelectedParticularMedia_Click(indexPath.item, _strImage: imageString)
    }
}

protocol selectedMyMediaDelegate : class {
    func didSelectedParticularMedia_Click(_ tag: Int, _strImage: String)
    func didSelectMyMedia_Click(_ tag: Int)
}
