//
//  MediaTableViewCell.swift
//  Mesh App
//
//  Created by Mac admin on 27/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class MediaTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
    
    weak var cellSelectedMediaDelegate: SelectedMediaCellDelegate?

    @IBOutlet weak var mediaNewCollection: UICollectionView!
    
    var arrMediaImages  = NSMutableArray();
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        arrMediaImages = ["pic1","pic2","pic3"]
        
        self.mediaNewCollection.delegate = self
        self.mediaNewCollection.dataSource = self
        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
//        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//        self.mediaNewCollection!.collectionViewLayout = layout        
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
        let cell : MediaCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "idMediaCollectionCell", for: indexPath) as! MediaCollectionViewCell
        
        let imageString : String  = String.init(format: "%@", arrMediaImages[indexPath.item] as! CVarArg);
        
//        cell.frame.size.width = screenWidth / 3
//        cell.frame.size.height = screenWidth / 3
//        
//        cell.backgroundColor = UIColor.red
        
        //cell.button .setImage(UIImage.init(named: imageString), for: .normal);
        cell.imgMedia.image = UIImage.init(named: "\(imageString)");
        
//        let templateImage = cell.imageView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate) //UIImageRenderingModeAlwaysTemplate
//        cell.imageView.image = templateImage
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let imageString : String  = String.init(format: "%@", arrMediaImages[indexPath.item] as! CVarArg);
//        DefaultsValues.setStringValueToUserDefaults(imageString, forKey: "mediaImage")
//        NotificationCenter.default.post(name: .pushViewController, object: nil)
        
        cellSelectedMediaDelegate?.didSelectMedia_Click(indexPath.item, _strImage: imageString)
    }
}

protocol SelectedMediaCellDelegate : class {
    func didSelectMedia_Click(_ tag: Int, _strImage: String)
}
