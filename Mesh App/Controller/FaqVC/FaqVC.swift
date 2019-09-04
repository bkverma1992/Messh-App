//
//  FaqVC.swift
//  Mesh App
//
//  Created by Mac admin on 04/10/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class FaqVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
