//
//  PageControlVC.swift
//  Locatem
//
//  Created by Mac admin on 03/05/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class PageControlVC: UIViewController {
    
    var strImgName: String?
    var pageIndex: NSInteger?
    var strTitle : String?
    var image = UIImage()
    var strSubTitle : String?

    @IBOutlet weak var lblNewSubTitle: UILabel!
    @IBOutlet weak var imgWalkThroughPages: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        image = UIImage(named: strImgName!)!
//        self.imgWalkThroughPages?.image = image
        //imgWalkThroughPages?.image = UIImage.init(named: strImgName! as String)
        
        self.imgWalkThroughPages.image = UIImage(named: strImgName!)!
        self.lblTitle.text! = strTitle!
        self.lblNewSubTitle.text! = strSubTitle!

        //self.imgPages.sd_setImage(with: URL(string: strImgName!), placeholderImage: #imageLiteral(resourceName: "banner3"));
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
