//
//  TermsAndPoliciesVC.swift
//  Mesh App
//
//  Created by Mac admin on 20/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class TermsAndPoliciesVC: UIViewController {

    @IBOutlet weak var txtViewTerms: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.automaticallyAdjustsScrollViewInsets = false
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        self.txtViewTerms.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack_Click(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
