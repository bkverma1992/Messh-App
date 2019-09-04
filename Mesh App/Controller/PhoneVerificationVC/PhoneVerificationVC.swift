//
//  PhoneVerificationVC.swift
//  Mesh App
//
//  Created by Mac admin on 05/10/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit
import SwiftMessageBar
import Firebase
import FirebaseAuth
import FirebaseDatabase
import CoreData
import JGProgressHUD

class PhoneVerificationVC: UIViewController, UITextFieldDelegate {
    
    var userFullDetail: [NSManagedObject] = []

    @IBOutlet weak var lblPhoneNo: UILabel!
    @IBOutlet weak var txtCode1: UITextField!
    @IBOutlet weak var txtCode2: UITextField!
    @IBOutlet weak var txtCode3: UITextField!
    @IBOutlet weak var txtCode4: UITextField!
    @IBOutlet weak var txtCode5: UITextField!
    @IBOutlet weak var txtCode6: UITextField!
    var strVerificationID : String?
    var strUserPhoneNo : String?
    var userDetails : UserDetailsModel?
    var strCurrentDateTime = String()
    var strMutableString = NSMutableAttributedString()
    var hud = JGProgressHUD()
    
     var refDatabase: DatabaseReference!
    
   var dictUserDetails : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.txtCode1.layer.borderColor = UIColor.lightGray.cgColor
        self.txtCode1.layer.borderWidth = 1.0
        self.txtCode1.layer.cornerRadius = 2.0
        
        self.txtCode2.layer.borderColor = UIColor.lightGray.cgColor
        self.txtCode2.layer.borderWidth = 1.0
        self.txtCode2.layer.cornerRadius = 2.0
        
        self.txtCode3.layer.borderColor = UIColor.lightGray.cgColor
        self.txtCode3.layer.borderWidth = 1.0
        self.txtCode3.layer.cornerRadius = 2.0
        
        self.txtCode4.layer.borderColor = UIColor.lightGray.cgColor
        self.txtCode4.layer.borderWidth = 1.0
        self.txtCode4.layer.cornerRadius = 2.0
        
        self.txtCode5.layer.borderColor = UIColor.lightGray.cgColor
        self.txtCode5.layer.borderWidth = 1.0
        self.txtCode5.layer.cornerRadius = 2.0
        
        self.txtCode6.layer.borderColor = UIColor.lightGray.cgColor
        self.txtCode6.layer.borderWidth = 1.0
        self.txtCode6.layer.cornerRadius = 2.0
        
        self.refDatabase = Database.database(url: Constant.ServerFirebaseURL).reference()
        
         //self.refDatabase = Database.database().reference(fromURL: Constant.ServerFirebaseURL)
        
        //print("dict Data: ", self.dictUserDetails!)
        //print("strUserPhoneNo phone: ", strVerificationID!)
        //userDetails = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kUserDetails)! as? UserDetailsModel
        
        strUserPhoneNo = String(format: "%@ %@. ", self.dictUserDetails.value(forKey: "country_code") as! CVarArg, self.dictUserDetails.value(forKey: "phone_no") as! CVarArg)
        
        //strUserPhoneNo = "9033711682"
        
//        self.strMutableString = NSMutableAttributedString(string: strUserPhoneNo!, attributes: [NSAttributedStringKey.font:UIFont(name: "TitilliumWeb-Regular", size: 14.0)!])
//        self.strMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.green, range: NSRange(location:10,length:5))
//        self.lblPhoneNo.attributedText = self.strMutableString
        
        let attrs1 = [NSAttributedStringKey.font : UIFont(name: "TitilliumWeb-Regular", size: 15.0)!, NSAttributedStringKey.foregroundColor : UIColor.black]
        let attrs2 = [NSAttributedStringKey.font : UIFont(name: "TitilliumWeb-Regular", size: 15.0)!, NSAttributedStringKey.foregroundColor : Constant.MESH_BLUE]
        
        let attributedString1 = NSMutableAttributedString(string:strUserPhoneNo!, attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:"Wrong Number?", attributes:attrs2)
        
        attributedString1.append(attributedString2)
        self.lblPhoneNo.attributedText = attributedString1
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PhoneVerificationVC.tapWrongNumber))
        self.lblPhoneNo.isUserInteractionEnabled = true
        self.lblPhoneNo.addGestureRecognizer(tap)
    }
   
    @objc func tapWrongNumber(sender:UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
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
    
    // MARK: - Text Field Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if Int(range.length) == 1
        {
            textField.text = ""
            textField.layer.borderColor = UIColor.lightGray.cgColor
            if textField == txtCode1
            {
                txtCode1.backgroundColor = UIColor.white
            }
            else if textField == txtCode2
            {
                //txtCode2.resignFirstResponder()
                txtCode1.becomeFirstResponder()
                txtCode2.backgroundColor = UIColor.white
            }
            else if textField == txtCode3
            {
                //txtCode3.resignFirstResponder()
                txtCode2.becomeFirstResponder()
                txtCode3.backgroundColor = UIColor.white
            }
            else if textField == txtCode4
            {
                //txtCode4.resignFirstResponder()
                txtCode3.becomeFirstResponder()
                txtCode4.backgroundColor = UIColor.white
            }
            else if textField == txtCode5
            {
                //txtCode5.resignFirstResponder()
                txtCode4.becomeFirstResponder()
                txtCode5.backgroundColor = UIColor.white
            }
            else if textField == txtCode6
            {
                //txtCode6.resignFirstResponder()
                txtCode5.becomeFirstResponder()
                txtCode6.backgroundColor = UIColor.white
            }
        }
        else
        {
            textField.text = string
            textField.layer.borderColor = Constant.MESH_BLUE.cgColor
            textField.isUserInteractionEnabled = true
            if textField == txtCode1
            {
                //txtCode1.resignFirstResponder()
                txtCode2.becomeFirstResponder()
            }
            else if textField == txtCode2
            {
                //txtCode2.resignFirstResponder()
                txtCode3.becomeFirstResponder()
            }
            else if textField == txtCode3
            {
                //txtCode3.resignFirstResponder()
                txtCode4.becomeFirstResponder()
            }
            else if textField == txtCode4
            {
                //txtCode4.resignFirstResponder()
                txtCode5.becomeFirstResponder()
            }
            else if textField == txtCode5
            {
                //txtCode5.resignFirstResponder()
                txtCode6.becomeFirstResponder()
            }
            else if textField == txtCode6
            {
                txtCode6.resignFirstResponder()
            }
        }
        return false
    }

    @IBAction func btnResendOTP_Click(_ sender: Any)
    {
        // Firebase Phone Verification Integration
        Auth.auth().languageCode = "en"
        hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Resending OTP...."
        hud.show(in: self.view)
        
        PhoneAuthProvider.provider().verifyPhoneNumber(self.strUserPhoneNo!, uiDelegate: nil) { (verificationID, error) in
            if let error = error
            {
                SwiftMessageBar.showMessage(withTitle: error.localizedDescription, type: .error)
                //self.showMessagePrompt(error.localizedDescription)
                return
            }
           self.hud.dismiss()
           UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            //let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        
            /*let dict : NSDictionary = [
                "country_name" : countryName,
                "country_code" : self.lblCountryCode.text!,
                "phone_no" : userPhoneNo,
                "authVerificationID" : verificationID!
            ]*/
        }
        //self.insertUserInfo()        
    }
    
    @IBAction func btnVerify_Click(_ sender: Any)
    {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        
        hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Verifying...."
        hud.show(in: self.view)
        
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            connectedRef.observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.value as? Bool ?? false {
                    let verificationCode = String(format: "%@%@%@%@%@%@", self.txtCode1.text!, self.txtCode2.text!, self.txtCode3.text!, self.txtCode4.text!, self.txtCode5.text!, self.txtCode6.text!)
                    
                    let credential = PhoneAuthProvider.provider().credential(
                        withVerificationID: self.strVerificationID!,
                        verificationCode: verificationCode)
                    print("credential: ", credential)
//                    Auth.auth().signIn(with: credential) { (authResult, error) in
//
//                    }
                    Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                        if error != nil
                        {
                            self.hud.dismiss()
                            SwiftMessageBar.showMessage(withTitle: error!.localizedDescription, type: .error)
                            /*print("error:", String(describing: error.localizedDescription))
                            let alertController = UIAlertController(title:kAppName, message: String(describing: error.localizedDescription), preferredStyle: .alert)
                            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(OKAction)
                            self.present(alertController, animated: true, completion: nil)*/
                            return
                        }
                        else
                        {
                            //hud.dismiss()
                            self.insertUserInfo()
                        }
                    }
                    print("Connected")
                }
                else
                {
                    self.hud.dismiss()
                    /*let otherAlert = UIAlertController(title: "Network Issue", message: "Please check you internet connection", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                    otherAlert.addAction(okAction)
                    otherAlert.addAction(cancelAction)
                    self.present(otherAlert, animated: true, completion: nil)*/
                }
            })
        })
    }
    
    func insertUserInfo()
    {
        let userId = Auth.auth().currentUser?.uid
        Database.database().reference().child("UserInfo").child(userId!).observeSingleEvent(of: .value, with: {(DataSnapshot) in
            if DataSnapshot.exists()
            {
                if let dictUserInfo = DataSnapshot.value as? NSDictionary//[String: AnyObject]
                {

                    print(dictUserInfo)


                    let userDetails  = UserDetailsModel.init(dictionary:dictUserInfo as NSDictionary)!
                    DefaultsValues.setCustomObjToUserDefaults(userDetails, forKey: kUserDetails)
                    print("User Details: ", DefaultsValues.getCustomObjFromUserDefaults_(forKey: kUserDetails)!)
                    DefaultsValues.setCustomObjToUserDefaults(dictUserInfo.value(forKey: "institute"), forKey: kInstituteList)
                    self.hud.dismiss()

                    print(userDetails)

                    if userDetails.isLogin == "0"
                    {
                        let objEditProfileVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idEditProfileVC") as! EditProfileVC
                        self.navigationController?.pushViewController(objEditProfileVC, animated: true)
                    }
                    else if userDetails.isLogin == "1"
                    {
                        let objChatListVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idChatListVC") as! ChatListVC
                        self.navigationController?.pushViewController(objChatListVC, animated: true)
                    }
                }
                
//                self.refDatabase = Database.database().reference()
//                self.strCurrentDateTime =  Utils.getCurrentDateAndTimeInFormatWithSeconds()
//                DefaultsValues.setStringValueToUserDefaults(self.strCurrentDateTime, forKey: kCreatedDate)
//
//                //                guard let strFcmToken =  DefaultsValues.getStringValueFromUserDefaults_(forKey: kFCMPushDeviceToken)
//                //                    else
//                //                {
//                //                    return
//                //                }
//
//                let deadlineTime = DispatchTime.now() + .seconds(2)
//                DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
//                    let post = ["user_id" : userId,
//                                "user_name" : "",
//                                "user_email" : "",
//                                "short_bio" : "",
//                                "designation" : "",
//                                "company" : "",
//                                "industry" : "",
//                                "institute" : "",
//                                "interests" : "",
//                                "chats": "",
//                                "country_name" : self.dictUserDetails["country_name"],//self.userDetails?.countryName,
//                        "country_code" : self.dictUserDetails["country_code"],
//                        "contact_no" : self.dictUserDetails["phone_no"],
//                        "fcm_push_token" : kFCMPushDeviceToken,
//                        "image": "",
//                        "city_name" : "",//self.dictUserDetails["country_name"],
//                        "is_verified" : "1",
//                        "is_login" : "0", // here i m checking is_login for edit profile if profile edit then 1 else 0
//                        "device_id" : "iOS",
//                        "created_on" : ServerValue.timestamp() as! [String: AnyObject],
//                        "modified_on" : ServerValue.timestamp() as! [String: AnyObject]] //[".sv": "timestamp"]
//
//                    //let dict = post as NSDictionary
//
//
//                    //             let childUpdates = ["/users/\(String(describing: key))": post,
//                    //             "/user-posts/\(countryName)/\(String(describing: key))/": post]
//                    //self.refDatabase
//                    let childUpdates = ["/UserInfo/\(String(describing: userId!))": post]
//                    self.refDatabase.updateChildValues(childUpdates)
//
//                    self.checkUserIsLoggedIn()
//                })
            }
            else
            {
                self.refDatabase = Database.database().reference()
                self.strCurrentDateTime =  Utils.getCurrentDateAndTimeInFormatWithSeconds()
                DefaultsValues.setStringValueToUserDefaults(self.strCurrentDateTime, forKey: kCreatedDate)
                
//                guard let strFcmToken =  DefaultsValues.getStringValueFromUserDefaults_(forKey: kFCMPushDeviceToken)
//                    else
//                {
//                    return
//                }
                
                let deadlineTime = DispatchTime.now() + .seconds(2)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                    let post = ["user_id" : userId,
                                "user_name" : "",
                                "user_email" : "",
                                "short_bio" : "",
                                "designation" : "",
                                "company" : "",
                                "industry" : "",
                                "institute" : "",
                                "interests" : "",
                                "chats": "",
                                "country_name" : self.dictUserDetails["country_name"],//self.userDetails?.countryName,
                        "country_code" : self.dictUserDetails["country_code"],
                        "contact_no" : self.dictUserDetails["phone_no"],
                        "fcm_push_token" : kFCMPushDeviceToken,
                        "image": "",
                        "city_name" : "",//self.dictUserDetails["country_name"],
                        "is_verified" : "1",
                        "is_login" : "0", // here i m checking is_login for edit profile if profile edit then 1 else 0
                        "device_id" : "iOS",
                        "created_on" : ServerValue.timestamp() as! [String: AnyObject], 
                        "modified_on" : ServerValue.timestamp() as! [String: AnyObject]] //[".sv": "timestamp"]
                        print(post)
                    //let dict = post as NSDictionary
                    
                   
                    //             let childUpdates = ["/users/\(String(describing: key))": post,
                    //             "/user-posts/\(countryName)/\(String(describing: key))/": post]
                    //self.refDatabase
                     let childUpdates = ["/UserInfo/\(String(describing: userId!))": post]
                    self.refDatabase.updateChildValues(childUpdates)
                    
                    self.checkUserIsLoggedIn()
                })
            }
        }, withCancel: nil)        
    }
    
    /*func getCurrentDateAndTime()
    {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: now)
        self.strCurrentDateTime = dateString
        DefaultsValues.setStringValueToUserDefaults(self.strCurrentDateTime, forKey: kCreatedDate)
    }*/
    
    func checkUserIsLoggedIn()
    {
        if Auth.auth().currentUser?.uid == nil
        {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else
        {
            let userId = Auth.auth().currentUser?.uid
            Database.database().reference().child("UserInfo").child(userId!).observeSingleEvent(of: .value, with: {(DataSnapshot) in
                print(DataSnapshot.value!)
                //if DataSnapshot.hasChild("UserDetails")
                
                if let dictUserInfo = DataSnapshot.value as? NSDictionary//[String: AnyObject]
                {
                    //let dictData = dictUserInfo as NSDictionary
                    let userDetails  = UserDetailsModel.init(dictionary:dictUserInfo as NSDictionary)!
                    print("User Info Model Class: ", userDetails)
                    DefaultsValues.setCustomObjToUserDefaults(userDetails, forKey: kUserDetails)
                    DefaultsValues.setCustomObjToUserDefaults(dictUserInfo.value(forKey: "institute"), forKey: kInstituteList)
                    //DefaultsValues.setCustomObjToUserDefaults(dictUserInfo.value(forKey: "institute"), forKey: kInstituteList)
                    //DefaultsValues.setCustomObjToUserDefaults(userDetails, forKey: kUserDetailsRegister)
                    print("User Details: ", DefaultsValues.getCustomObjFromUserDefaults_(forKey: kUserDetails)!)
                    self.save(objUserDetail: userDetails)
                    
                    let objEditProfileVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idEditProfileVC") as! EditProfileVC
                    self.navigationController?.pushViewController(objEditProfileVC, animated: true)
                    DefaultsValues.setBooleanValueToUserDefaults(true, forKey: kImportContactFirstTime)
                }
            }, withCancel: nil)
        }
    }
    
    @objc func handleLogout()
    {
        print("Logout User")
    }
    
    // MARK: - Save Data To Core Data Entity (LoginUserDetail)
    func save(objUserDetail : UserDetailsModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
   
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: ChatConstants.entityName.entityLoginUserDetail, in: managedContext)!
        let loginUserDetail = NSManagedObject(entity: entity, insertInto: managedContext)
        loginUserDetail.setValue(objUserDetail.userId, forKey: "userId")
        loginUserDetail.setValue(objUserDetail.userName, forKey: "userName")
        loginUserDetail.setValue(objUserDetail.cityName, forKey: "cityName")
        loginUserDetail.setValue(objUserDetail.countryCode, forKey: "countryCode")
        loginUserDetail.setValue(objUserDetail.countryName, forKey: "countryName")
        loginUserDetail.setValue(objUserDetail.shortBio, forKey: "shortBio")
        loginUserDetail.setValue(objUserDetail.userImage, forKey: "userImage")
        loginUserDetail.setValue(objUserDetail.companyName, forKey: "companyName")
        loginUserDetail.setValue(objUserDetail.interests, forKey: "interests")
        loginUserDetail.setValue(objUserDetail.industry, forKey: "industry")
        loginUserDetail.setValue(objUserDetail.designation, forKey: "designation")
        loginUserDetail.setValue(objUserDetail.userEmail, forKey: "userEmail")
        loginUserDetail.setValue(objUserDetail.institutes, forKey: "institute")
        loginUserDetail.setValue(objUserDetail.phone, forKey: "phone")
        loginUserDetail.setValue(objUserDetail.fcmPushToken, forKey: "fcmPushToken")
        loginUserDetail.setValue(objUserDetail.isVerified, forKey: "isVerified")
        loginUserDetail.setValue(objUserDetail.isLogin, forKey: "isLogin")
        loginUserDetail.setValue(objUserDetail.deviceId, forKey: "deviceId")

        print(objUserDetail.createdOn as Any)
        var getCreateValue = String()
        getCreateValue = String(format: "%.0f", objUserDetail.createdOn!)
        print(getCreateValue)
        print(objUserDetail.modifiedOn as Any)
        var getModifyValue = String()
        getModifyValue = String(format: "%.0f", objUserDetail.modifiedOn!)
        print(getModifyValue)
        
      //  loginUserDetail.setValue(objUserDetail.createdOn, forKey: "createdOn")
        loginUserDetail.setValue(getCreateValue, forKey: "createdOn")
        //loginUserDetail.setValue(objUserDetail.modifiedOn, forKey: "modifiedOn")
        loginUserDetail.setValue(getModifyValue, forKey: "modifiedOn")

        print("Core Data Saved User:",  loginUserDetail.value(forKeyPath: "userId") as! String)
        
        //loginUserDetail.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            userFullDetail.append(loginUserDetail)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    /*func updateUserDetails()
    {
        let userId = Auth.auth().currentUser?.uid
        //let key = self.ref.child("UserInfo").childByAutoId().key
        //print("key: ", key!)
        let post = ["user_id" : userDetails,
                    "country_name": countryName,
                    "contact_no": userPhoneNo,
                    "country_code": self.lblCountryCode.text!,
                    "is_verified": "0",
                    "is_login" : "1",
                    "device_type" : "iOS"]
        
        let childUpdates = ["/UserInfo/\(String(describing: userId!))": post]
        //             let childUpdates = ["/users/\(String(describing: key))": post,
        //             "/user-posts/\(countryName)/\(String(describing: key))/": post]
        self.ref.updateChildValues(childUpdates)
        self.checkUserIsLoggedIn()
    }*/
}
