//
//  SkipInviteLinkVC.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 31/10/2018.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit
import SwiftMessageBar

class SkipInviteLinkVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack_Click(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSearch_Click(_ sender: Any) {
    }
    
    @IBAction func btnSkipInviteLink_Click(_ sender: Any)
    {
        let objAddGroupSubjectVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idAddGroupSubjectVC") as! AddGroupSubjectVC
        //objAddGroupSubjectVC.arrParticipantsData = self.arrSelectedData.mutableCopy() as! NSMutableArray
        self.navigationController?.pushViewController(objAddGroupSubjectVC, animated: true)
    }
    
    @IBAction func btnNext_Click(_ sender: Any)
    {
        SwiftMessageBar.showMessage(withTitle: "Please select atleast one participant as a group member", type: .error)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
