//
//  SelectedImageVC.swift
//  Mesh App
//
//  Created by Mac admin on 27/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class SelectedImageVC: UIViewController
{
    @IBOutlet weak var imgSelectedMedia: UIImageView!
    var strSelectedImage : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("strSelectedImage: ", strSelectedImage!)
        self.imgSelectedMedia.image = UIImage.init(named: "\(strSelectedImage!)");

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack_Click(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
