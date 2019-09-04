//
//  WelcomeScreenVC.swift
//  Mesh App
//
//  Created by Mac admin on 20/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit
import UserNotifications

class WelcomeScreenVC: UIViewController {

    @IBOutlet weak var btnContinue: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.btnContinue.layer.cornerRadius = 4.0
    }
    
    override func viewWillAppear(_ animated: Bool)
    {        
        // Check for Location Services
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnContinue_Click(_ sender: Any)
    {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        }
        else
        {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        let objSignUpScreenVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idSignUpScreenVC") as! SignUpScreenVC
        self.navigationController?.pushViewController(objSignUpScreenVC, animated: true)
    }
    
    @IBAction func btnTermsAndCondition_Click(_ sender: Any)
    {
        let objTermsAndPoliciesVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idTermsAndPoliciesVC") as! TermsAndPoliciesVC
        self.navigationController?.pushViewController(objTermsAndPoliciesVC, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /*static func showAlertMessage(vc: UIViewController, titleStr:String, messageStr:String) -> Void {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        vc.present(alert, animated: true, completion: nil)
    }*/
}
