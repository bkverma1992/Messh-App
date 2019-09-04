//
//  SignUpScreenVC.swift
//  Mesh App
//
//  Created by Mac admin on 20/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit
import Alamofire
import SwiftMessageBar
import Firebase
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD

class SignUpScreenVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var txtCountryName: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    var viewMobileNoTerms = UseOfMobileNoView()
    var coverView = UIView()
    var hud = JGProgressHUD()

    var arrCountryCode = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.btnSubmit.layer.cornerRadius = 4.0
        self.txtCountryName.addPaddingLeft(8.0)
        self.txtCountryName.text! = DefaultsValues.getStringValueFromUserDefaults_(forKey: kCurrentCountryName)!
        print("self.txtCountryName.text!: ", self.txtCountryName.text!)
        
        self.txtPhoneNo.delegate = self
        //ref = Database.database().reference()
        
        if let path = Bundle.main.path(forResource: "CallingCodes", ofType: "plist") {
            arrCountryCode = NSArray(contentsOfFile: path)!
            print("array: ", arrCountryCode)
        }
        
        //countryCode
        if let countryCode = (Locale.current as NSLocale).object(forKey: .languageCode) as? String {
            print(countryCode)
        }
        
        let regionCode = Locale.current.regionCode
        print(regionCode!)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        // Check for Location Services
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Text Field Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == self.txtPhoneNo
        {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else
        {
            return true;
        }
    }
    
    func createAViewToShowTerms()
    {
        let loadXibView = Bundle.main.loadNibNamed("UseOfMobileNoView", owner: self, options: nil)
        
        //If you only have one view in the xib and you set it's class to MyView class
        viewMobileNoTerms = loadXibView!.first as! UseOfMobileNoView
        
        //Set wanted position and size (frame)
        //myView.frame = self.view.bounds
        //        myView.frame = CGRect(x:  (self.view.frame.size.width / 2), y: (self.view.frame.size.height / 2), width: self.view.frame.size.width - 20, height: 270)
        
        viewMobileNoTerms.center = CGPoint(x: self.view.frame.size.width  / 2,
                                        y: self.view.frame.size.height / 2)
        //myView.backgroundColor = UIColor.red
       
        viewMobileNoTerms.btnClose.addTarget(self, action: #selector(btnClose_Click(sender:)), for: .touchUpInside)
        
        let screenRect = UIScreen.main.bounds
        coverView = UIView(frame: screenRect)
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.86)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.delegate = self as? UIGestureRecognizerDelegate // This is not required
        coverView.addGestureRecognizer(tap)
        self.view.addSubview(coverView)
        
        self.view.addSubview(viewMobileNoTerms)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        coverView.removeFromSuperview()
        viewMobileNoTerms.removeFromSuperview()
        // handling code
    }
    
    @IBAction func btnUseOfMobileNo_Click(_ sender: Any) {
        self.createAViewToShowTerms()
    }
    
    @objc func btnClose_Click(sender: UIButton)
    {
        coverView.removeFromSuperview()
        viewMobileNoTerms.removeFromSuperview()
    }
    
    @IBAction func btnSubmit_Click(_ sender: Any)
    {
        
//        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
//            AnalyticsParameterItemID: "id-\(userData.UserId!)",
//            AnalyticsParameterItemName: userData.phone!,
//            AnalyticsParameterContentType: "cont"
//            ])
        
        
//        let objEditProfileVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idEditProfileVC") as! EditProfileVC
//        self.navigationController?.pushViewController(objEditProfileVC, animated: true)
        
        if self.txtPhoneNo.text == ""
        {
            SwiftMessageBar.showMessage(withTitle: "Please enter the contact number", type: .error)
        }
        else if !Utils.validateContact(self.txtPhoneNo.text!)
        {
             SwiftMessageBar.showMessage(withTitle: "Please enter valid 10 digit contact number", type: .error)
        }
        else if self.txtCountryName.text == ""
        {
            SwiftMessageBar.showMessage(withTitle: "Please select any of the country", type: .error)
        }
        else
        {
            guard let countryName = self.txtCountryName.text, let userPhoneNo = self.txtPhoneNo.text
                else
            {
                return
            }
            hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Loading"
            hud.show(in: self.view)
            
            // Firebase Phone Verification Integration
            Auth.auth().languageCode = "en"
            let strFinalPhoneNo = String(format: "%@%@", self.lblCountryCode.text!, userPhoneNo)
            print("strPhoneNo: ", strFinalPhoneNo)
            
            PhoneAuthProvider.provider().verifyPhoneNumber(strFinalPhoneNo, uiDelegate: nil) { (verificationID, error) in
                if let error = error
                {
                    SwiftMessageBar.showMessage(withTitle: error.localizedDescription, type: .error)
                    //self.showMessagePrompt(error.localizedDescription)
                    return
                }

                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
                print("verificationID: ", verificationID!)
            
            //"authVerificationID" : verificationID!
            
            //let verificationID = "qwertyuioplkjhgfdsazxcvbnmmnbvcxz"
            
                let dict : NSDictionary = [
                    "country_name" : countryName,
                    "country_code" : self.lblCountryCode.text!,
                    "phone_no" : userPhoneNo,
                    "authVerificationID" : verificationID!
                ]
                
                let objPhoneVerificationVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idPhoneVerificationVC") as! PhoneVerificationVC
                objPhoneVerificationVC.dictUserDetails = dict
                objPhoneVerificationVC.strVerificationID = verificationID
                self.hud.dismiss()
                self.navigationController?.pushViewController(objPhoneVerificationVC, animated: true)
            }
        }
    }    

    @IBAction func btnBack_Click(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCountryList_Click(_ sender: Any)
    {
        let picker = MyCountryPicker { (name, dial_code) -> () in
            print(dial_code)
        }
        // Optional: To pick from custom countries list
        //picker.customCountriesCode = ["EG", "US", "AF", "AQ", "AX"]
        
        // delegate
        picker.delegate = self
        
        // Display calling codes
        picker.showCallingCodes = true
        
        // or closure
        //        picker.didSelectCountryClosure = { name, code in
        //            print(code)
        //        }
        picker.didSelectCountryWithCallingCodeClosure = {name, code, dialCode in
            print(dialCode)
        }
        navigationController?.pushViewController(picker, animated: true)
    }
    
    
    
//    deinit {
//        if let refHandle = _refHandle {
//            self.ref.child("messages").removeObserver(withHandle: refHandle)
//        }
//    }
//
//    func configureDatabase()
//    {
//        ref = Database.database().reference()
//        // Listen for new messages in the Firebase database
//        _refHandle = self.ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
//            guard let strongSelf = self else { return }
//            strongSelf.messages.append(snapshot)
//            strongSelf.clientTable.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
//        })
//    }
}

extension SignUpScreenVC: MyCountryPickerDelegate {
    //    func countryPicker(_ picker: MyCountryPicker, didSelectCountryWithName name: String, code: String) {
    //        //picker.navigationController?.popToRootViewController(animated: true)
    //        picker.navigationController?.popViewController(animated: true)
    //        btnCountryCode.setTitle(code, for: UIControlState.normal)
    //    }
    
    func countryPicker(_ picker: MyCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String)
    {
        picker.navigationController?.popViewController(animated: true)
        lblCountryCode.text = dialCode
        self.txtCountryName.text = name
        DefaultsValues.setStringValueToUserDefaults(self.txtCountryName.text, forKey: kCurrentCountryName)
        //txtCountryName.setTitle(dialCode, for: UIControlState.normal)
    }
}
