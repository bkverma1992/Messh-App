//
//  EditProfileVC.swift
//  Mesh App
//
//  Created by Mac admin on 24/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit
import CropViewController
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import CoreData
import JGProgressHUD
import SwiftMessageBar

enum EditProfileSection : Int {
    case profilePicture = 0
    case name = 1
    case institute = 2
    case description = 3
    
    static var sectionCount: Int { return EditProfileSection.description.rawValue + 1}
}

enum profilePictureRows : Int {
    case addProfile = 0
    static var profileRowCount: Int { return profilePictureRows.addProfile.rawValue + 1}
}

enum nameRows : Int {
    case FullName = 0
    case QuickBio
    case Company
    case Designation
    case Industry
    static var nameRowsCount: Int { return nameRows.Industry.rawValue + 1}
}

enum descriptionRows : Int {
    case Business = 0
    case City
    case Country
    case Email
    case Mobile
    static var descriptionRowsCount: Int { return descriptionRows.Mobile.rawValue + 1}
}

enum instituteRows : Int {
    case Institute = 0
    static var instituteRowsCount: Int { return instituteRows.Institute.rawValue + 1}
}

//let kProfileCell                                            =  "profileCell"
//let ktextfieldCell                                          =  "textfieldCell"
//let ktextfieldWithDescCell                         =  "textfieldWithDescCell"
//let kinstituteSectionCell                             =  "InstituteSectionCell"
//let kinstituteCell                                          =  "InstituteCell"

class EditProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CropViewControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, ImageProfileDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var tblEditProfile: UITableView!
    @IBOutlet weak var btnUserProfile: UIButton!
    var appd = AppDelegate()
    
    
    var arrEditProfileTitle = NSArray()
    var arrTexfieldSubTitle = NSArray()
    var textDataArr = NSMutableArray()
    
    var hud = JGProgressHUD()
        
    var arrInstitute = [Int]()
    //var dictEditData = NSMutableDictionary()
    var arrInstituteData = NSMutableArray()
    
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    var userDetails : UserDetailsModel?
    //var userDetails : UserDetailCoreDataModel?
    var refDatabase: DatabaseReference!
    var index = Int()
    var dictEditData = NSMutableDictionary()    
    var strModifiedDateTime = String()
    var strImageUrl = String()
    var strName = String()
    var strShortBio = String()
    var strCompanyName = String()
    var strCityName = String()
    var strInterest = String()
    var strIndustry = String()
    var strInstitute = String()
    var strDesignation = String()
    var strEmail = String()
    var strContactNo = String()
    var strCountryName = String()
    var indexPathTableView: IndexPath? = nil
    var tableViewNewCell : UITableViewCell? = nil
    //var arrInstitute = NSMutableArray()
    
    typealias FileCompletionBlock = () -> Void
    var block: FileCompletionBlock?
    
    //var dictEditData = [String : String]()
    @IBOutlet var backBTN: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        appd = UIApplication.shared.delegate as! AppDelegate
        
       if appd.checkIfUserFirstTimeProfile == "userNotFirstTime"
        {
            backBTN .isHidden = false
        }
        else
        {
            backBTN .isHidden = true
        }
        
        
        // Do any additional setup after loading the view.
        
        //let appDelegate = UIApplication.shared.delegate as? AppDelegate
        //appDelegate?.CoreDataEntityIsEmpty(entityName: "LoginUserDetail")
        //CoreDataEntityIsEmpty
        
        // bhupi
        arrEditProfileTitle = ["Full Name*", "Quick Bio*", "Designation*", "Company*",  "Industry*","Institute / School*, Year Of Passing*","Business / Work Interests*", "City*", "Country*",  "Email*", "Mobile (Uneditable)"]

        arrTexfieldSubTitle = ["Name", "Add Bio here", "Designation at your current company", "Your current company",  "Industry your company operates in","Institute/ School","Add comma seperated #interests here", "Add your city here", "Your current country",  "Your work or personal email Id","Your mobile number"]
        
        //arrTexfieldSubTitle = ["Name", "Add Bio here \n *Write a short note about you & your company (360 chars)", "Designation at your current company", "Your current company",  "Industry your company operates in","Institute o School","*Use #tags to add interests. This is important to receive relevant messages. E.g. #Marketing, #E-Commerce, #ProductName", "Add your city here \n * Your current city. Mesh does not track location, hence it's important to add City so other chatInfo members know where you operate from.", "Your current country",  "Your work or personal email Id"];
                
       textDataArr = ["aaa", "aaa", "aaa", "aaa",  "aaa","aaa","aaa", "aaa", "aaa",  "aaa", "aaa"]
        
        self.refDatabase = Database.database(url: Constant.ServerFirebaseURL).reference()
        
        //self.refDatabase = Database.database().reference(fromURL: Constant.ServerFirebaseURL)
        self.userDetails = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kUserDetails) as? UserDetailsModel
        
        /*if DefaultsValues.getCustomObjFromUserDefaults_(forKey: kInstituteList) != nil
        {
            arrInstituteData = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kInstituteList) as! NSMutableArray
        }*/
                
        self.dictEditData.setValue(self.userDetails!.userId!, forKey: "user_id")
        self.dictEditData.setValue(self.userDetails!.userName!, forKey: "user_name")
        self.dictEditData.setValue(self.userDetails!.shortBio!, forKey: "short_bio")
        self.dictEditData.setValue(self.userDetails!.designation!, forKey: "designation")
        self.dictEditData.setValue(self.userDetails!.companyName!, forKey: "company")
        self.dictEditData.setValue(self.userDetails!.industry!, forKey: "industry")
        //self.dictEditData.setValue("", forKey: "institute")
        self.dictEditData.setValue(arrInstituteData, forKey: "institute")
        //self.dictEditData.setValue(self.strInstitute, forKey: "institute")
        self.dictEditData.setValue(self.userDetails!.interests!, forKey: "interests")
        self.dictEditData.setValue(self.userDetails!.cityName!, forKey: "city_name")
        self.dictEditData.setValue(self.userDetails!.countryName!, forKey: "country_name")
        self.dictEditData.setValue(self.userDetails!.userEmail!, forKey: "user_email")
        self.dictEditData.setValue(self.userDetails!.phone!, forKey: "contact_no")
        self.dictEditData.setValue(self.userDetails!.countryCode!, forKey: "country_code")
        self.dictEditData.setValue(self.userDetails!.userImage!, forKey: "image")
        
        if arrInstituteData.count == 0
        {
            arrInstitute.append(1) //remove this line if dont want any of the Institute textfield
        }
        /*else
         {
            for i in 0..<arrInstituteData.count
            {
                arrInstitute.append(i+1)
            }
         }*/
        
        /*self.strName = self.userDetails!.userId!
        self.strShortBio = self.userDetails!.shortBio!
        self.strDesignation = self.userDetails!.designation!
        self.strCompanyName = self.userDetails!.companyName!
        self.strIndustry = self.userDetails!.industry!
        //arrInstituteData
        self.strInterest = self.userDetails!.interests!
        self.strCityName = self.userDetails!.cityName!
        self.strCountryName = self.userDetails!.countryName!
        self.strEmail = self.userDetails!.userEmail!
        self.strContactNo = self.userDetails!.phone!*/
        
        //DefaultsValues.setBooleanValueToUserDefaults(true, forKey: kImportContactFirstTime)
        //DefaultsValues.setStringValueToUserDefaults("true", forKey: kImportContactFirstTime)
        //print("abcd: ", DefaultsValues.getStringValueFromUserDefaults_(forKey: kImportContactFirstTime)!)
        
        /*guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        var userNewDetail  = [UserDetailsModel]()
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LoginUserDetail")
        
        do {
            //people = try managedContext.fetch(fetchRequest)
            let myManagedObject : [NSManagedObject] = try managedContext.fetch(fetchRequest)
            var keys:NSArray = myManagedObject.entity.attributesByName.allKeys
            var dict:NSDictionary = myManagedObject.dictionaryWithValuesForKeys(keys)
            myManagedObject.setValuesForKeysWithDictionary(dict)
            /*userNewDetail = try managedContext.fetch(fetchRequest) as! [UserDetailsModel]
            for objUser in userNewDetail {
                print(objUser.userId!)
            }*/
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }*/
        
        //self.userDetails = SaveAndFetchCoreData.getUserDetailFromCoreData()
        //print("userDetails: ", userDetails!)
    
        //let deadlineTime = DispatchTime.now() + .seconds(2)
        //DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            //self.tblEditProfile.estimatedRowHeight = 190.0
            //self.tblEditProfile.estimatedRowHeight = 250.0
            self.tblEditProfile.rowHeight = UITableViewAutomaticDimension
            self.tblEditProfile.estimatedRowHeight = UITableViewAutomaticDimension
            self.tblEditProfile.tableFooterView = UIView()
            self.tblEditProfile.reloadData()
        //})
    }
    
    func forTrailingZero(temp: Double) -> String {
        var tempVar = String(format: "%g", temp)
        return tempVar
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        // Check for Location Services
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        /*let dictInstituteData = NSMutableDictionary()
        dictInstituteData.setValue("", forKey: "institute_name")
        dictInstituteData.setValue("", forKey: "institute_passing_year")
        arrInstituteData.add(dictInstituteData)*/
        
       
        //self.editUserProfileInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func getUserDetailFromCoreData()
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LoginUserDetail")
        fetchRequest.returnsDistinctResults = false
        do{
            let result = try context.fetch(fetchRequest)
            for data in result as! [NSManagedObject]
            {
                let userId = data.value(forKey: "user_id")
            }
        }catch
        {
            print("Failed to fetch the Data")
        }
    }*/
    
    /*func getUserDetailFromCoreData()
    {
        let appDelegate  : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ChatConstants.entityName.entityLoginUserDetail)
        fetchRequest.returnsDistinctResults = false
        do{
            let arrResults : NSArray = try context.fetch(fetchRequest) as NSArray
            if arrResults.count > 0
            {
                for newUser in arrResults
                {
                    self.userDetails = newUser as? UserDetailCoreDataModel
                    print("objUser.userId: ", self.userDetails!.userId!)
                }
                
                self.strName = userDetails!.userName!
                self.strShortBio = userDetails!.shortBio!
                self.strCityName = userDetails!.cityName!
                self.strCountryName = userDetails!.countryName!
                self.strEmail = userDetails!.userEmail!
                self.strContactNo = userDetails!.phone!
                self.strInterest = userDetails!.interests!
                self.strIndustry = userDetails!.industry!
                self.strDesignation = userDetails!.designation!
                self.strCompanyName = userDetails!.companyName!
                self.strInstitute = userDetails!.institute!
            }
            else
            {
                print("Failed to fetch User Detail")
            }
        }catch
        {
            print("Failed to fetch the Data")
        }
        /*let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: ChatConstants.entityName.entityLoginUserDetail)
        
        do {
            let fetchedEmployees = try context.fetch(employeesFetch) as! [UserDetailCoreDataModel]
            
            for newUser in fetchedEmployees
            {
                let objUser = newUser
                print("objUser.userId: ", objUser.userId!)
            }
            
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }*/
    }*/
    
    func editUserProfileInfo()
    {
        //self.strModifiedDateTime =  Utils.getCurrentDateAndTimeInFormatWithSeconds()
        
//       guard let strFcmToken = DefaultsValues.getStringValueFromUserDefaults_(forKey: kFCMPushDeviceToken)
//            else{
//                return
//        }
        
        /*self.dictEditData.setValue(self.userDetails?.countryCode!, forKey: "country_code")
        self.dictEditData.setValue("1", forKey: "is_login")
        self.dictEditData.setValue(self.userDetails?.isVerified!, forKey: "is_verified")
        self.dictEditData.setValue("iOS", forKey: "device_id")
        self.dictEditData.setValue(strFcmToken, forKey: "fcm_push_token")
        self.dictEditData.setValue("", forKey: "chats")
        
        */
        //arrInstituteData.add(dictInstituteData)
        
         /*self.dictEditData.setValue(self.userDetails!.userId!, forKey: "user_id")
         self.dictEditData.setValue(self.strName, forKey: "user_name")
         self.dictEditData.setValue(self.strShortBio, forKey: "short_bio")
         self.dictEditData.setValue(self.strDesignation, forKey: "designation")
         self.dictEditData.setValue(self.strCompanyName, forKey: "company")
         self.dictEditData.setValue(self.strIndustry, forKey: "industry")
         self.dictEditData.setValue(self.arrInstitute, forKey: "institute")
         //self.dictEditData.setValue(self.strInstitute, forKey: "institute")
         self.dictEditData.setValue(self.strInterest, forKey: "interests")
         self.dictEditData.setValue(self.strCityName, forKey: "city_name")
         self.dictEditData.setValue(self.strCountryName, forKey: "country_name")
         self.dictEditData.setValue(self.strEmail, forKey: "user_email")
         self.dictEditData.setValue(self.strContactNo, forKey: "contact_no")
        
        self.dictEditData.setValue(self.userDetails?.countryCode!, forKey: "country_code")*/
        
        self.dictEditData.setValue("1", forKey: "is_login")
        self.dictEditData.setValue(self.userDetails?.isVerified!, forKey: "is_verified")
        self.dictEditData.setValue("iOS", forKey: "device_id")
        self.dictEditData.setValue(kFCMPushDeviceToken, forKey: "fcm_push_token")
        //self.dictEditData.setValue("", forKey: "chats")
        
        if DefaultsValues.getCustomObjFromUserDefaults_(forKey: kChatKeyList) != nil
        {
            let arrChatKeyList = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kChatKeyList) as! NSArray
            let dictData = NSMutableDictionary()
            for i in 0..<arrChatKeyList.count
            {                
                let strKey = arrChatKeyList[i] as! String
                dictData.setValue("", forKey: strKey)
                self.dictEditData.setValue(dictData, forKey: "chats")
            }
            
             if arrChatKeyList.count == 0
             {
                self.dictEditData.setValue("", forKey: "chats")
                //self.dictEditData.setValue(arrChatKeyList, forKey: "chats")
             }
        }
        
        //self.dictEditData.setValue(self.strImageUrl, forKey: "image")
        
        if strImageUrl != ""
        {
            
            
            
            print(self.userDetails!.createdOn as Any)
            
            let indexpath = IndexPath.init(row: 0, section: 0) //self.index
            let cell = self.tblEditProfile.cellForRow(at: indexpath) as! profileCell
            cell.imgUserProfile.sd_setImage(with: URL(string: userDetails!.userImage!), placeholderImage: UIImage(named: "gallery"))
            //userDetails!.userImage! = self.strImageUrl
            //self.strImageUrl = userDetails!.userImage!
            self.dictEditData.setValue(self.strImageUrl, forKey: "image")
         //   self.dictEditData.setValue(self.userDetails!.createdOn!, forKey: "created_on")
            self.dictEditData.setValue(ServerValue.timestamp() as! [String: AnyObject], forKey: "modified_on")
        }
        else if strImageUrl == ""
        {
            
            //self.strImageUrl = ""
        }
    }
    
    func saveUserImageToFirebaseDB()
    {
        let chatUserId = Auth.auth().currentUser?.uid
        let arrGroupData = NSMutableArray()
        let arrParticipantsList = NSMutableArray()
        let dictData = NSMutableDictionary()
        let arrMessages = NSMutableArray()
        
        let refUserPath = ChatConstants.refs.databaseParticularUserInfo
        refUserPath.observe(.childAdded, with: {snapshot in

            let strUniqueKey = snapshot.key
            let refChatInfo = ChatConstants.refs.databaseChatInfo.child(strUniqueKey)
            
            refChatInfo.observe(.childAdded, with: {snapshot in
                let msgGroupDict = snapshot.value as? NSDictionary
                
                let strType = msgGroupDict!.value(forKey: "type") as! String
                let strGroupId = msgGroupDict!.value(forKey: "group_id") as! String
                
                arrGroupData.add(msgGroupDict!)
                
                if strType == "0"
                {
                    let childrens = msgGroupDict?.value(forKey: "participants") as! NSArray
                    for child in  childrens {
                        let msgParticipantsDict = child as? NSDictionary
                        let strCheckKey = msgParticipantsDict!.value(forKey: "participant_id") as! String
                        if strCheckKey != chatUserId
                        {
                            arrParticipantsList.add(msgParticipantsDict!)
                            dictData.setValue(msgParticipantsDict, forKey: strGroupId)
                        }
                    }
                }
            }, withCancel: nil)
            
            let refMsgInfo = ChatConstants.refs.databaseMessagesInfo.child(strUniqueKey)
            refMsgInfo.observe(.childAdded, with: {snapshot in
                let msgLastInfoDict = snapshot.value as? NSDictionary
                arrMessages.add(msgLastInfoDict!)
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    func updateProfilePicInGroupInfo()
    {
        let chatUserId = Auth.auth().currentUser?.uid
        let refUserPath = ChatConstants.refs.databaseParticularUserInfo//.child(strChatId)
        //kChatKeyList
        let arrNewParticipantsList = NSMutableArray()
     
        refUserPath.observe(.childAdded, with: {snapshot in
        let refChatInfo = ChatConstants.refs.databaseChatInfo.child(snapshot.key)
                
        refChatInfo.observe(.childAdded, with: {snapshot in
            let msgGroupDict = snapshot.value as? NSDictionary
            //let strType = msgGroupDict!.value(forKey: "type") as! String
            
             /*dictUpdatedValues.setValue(chatUserId, forKey: "created_By")
             dictUpdatedValues.setValue(self.dictGroupFullInfo.value(forKey: "created_on"), forKey: "created_on")
             dictUpdatedValues.setValue(self.dictGroupFullInfo.value(forKey: "group_id"), forKey: "group_id") //key
             dictUpdatedValues.setValue(self.dictGroupFullInfo.value(forKey: "group_name"), forKey: "group_name")
             dictUpdatedValues.setValue(self.dictGroupFullInfo.value(forKey: "group_icon"), forKey: "group_icon")
             dictUpdatedValues.setValue(self.dictGroupFullInfo.value(forKey: "group_description"), forKey: "group_description")
             dictUpdatedValues.setValue(String(arrNewParticipantsList.count), forKey: "participant_count")
             dictUpdatedValues.setValue(ServerValue.timestamp() as! [String: AnyObject], forKey: "modified_on")
             dictUpdatedValues.setValue(arrNewParticipantsList, forKey: "participants")
             dictUpdatedValues.setValue("1", forKey: "type")
             
             let childUpdates = ["\(String(describing: self.strGroupUniqueKey))/groupInfo/": self.dictGroupFullInfo] //key
             refChatInfo.updateChildValues(childUpdates)*/
            
//            if strType == "1"
//            {
                let childrens = msgGroupDict?.value(forKey: "participants") as! NSArray
                for child in  childrens {
                    let msgParticipantsDict = child as? NSDictionary
                    arrNewParticipantsList.add(msgParticipantsDict!)
                    let strCheckKey = msgParticipantsDict!.value(forKey: "participant_id") as! String
                    if strCheckKey != chatUserId!
                    {
                        arrNewParticipantsList.add(msgParticipantsDict!)
                        print(snapshot.key)
                    }
                }
            //}
            }, withCancel: nil)
        }, withCancel : nil)
    }
    
    func saveUserInfoToFirebaseDB()
    {
        let userId = Auth.auth().currentUser?.uid
        
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            
            self.editUserProfileInfo()
            //return
            
            self.refDatabase.child("UserInfo").child(userId!).setValue(self.dictEditData)
            self.hud.dismiss()
            let alertController = UIAlertController(title: kAppName, message: "Your profile detail updated successfully ", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                let userDetails  = UserDetailsModel.init(dictionary:self.dictEditData as NSDictionary)!
                DefaultsValues.setCustomObjToUserDefaults(self.dictEditData.value(forKey: "institute"), forKey: kInstituteList)
                DefaultsValues.setCustomObjToUserDefaults(userDetails, forKey: kUserDetails)
                //print("kChatKeyList Details: ", DefaultsValues.getCustomObjFromUserDefaults_(forKey: kChatKeyList)!)
                
                //SaveAndFetchCoreData.save(objUserDetail: userDetails)
                
//                let objViewProfileVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idViewProfileVC") as! ViewProfileVC
//                objViewProfileVC.isClickedChatInfoButtonVC = "false"
//                self.navigationController?.pushViewController(objViewProfileVC, animated: true)
                
                let objChatListVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idChatListVC") as! ChatListVC
                objChatListVC.strNewGroupCreated = "false"
                self.navigationController?.pushViewController(objChatListVC, animated: true)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    // MARK: - Button Action
    
    @IBAction func btnBack_Click(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDone_Click(_ sender: Any)
    {
        print(self.dictEditData)
        
        if self.dictEditData.value(forKey: "user_email") as! String != ""
        {
            let strEmail = self.dictEditData.value(forKey: "user_email") as! String
            if !strEmail.isValidEmail()
            {
                SwiftMessageBar.showMessage(withTitle: "Please enter valid email Id", type: .error)
            }
        }
        if self.dictEditData.value(forKey: "image") as! String == ""
        {
            SwiftMessageBar.showMessage(withTitle: "Please add your profile picture", type: .error)
        }
        else if self.dictEditData.value(forKey: "user_name") as! String == ""
        {
            SwiftMessageBar.showMessage(withTitle: "Please enter your name", type: .error)
        }
        else if self.dictEditData.value(forKey: "short_bio") as! String == ""
        {
            SwiftMessageBar.showMessage(withTitle: "Please enter quick bio", type: .error)
        }
//        else if self.dictEditData.value(forKey: "company") as! String == ""
//        {
//            SwiftMessageBar.showMessage(withTitle: "Please enter your company", type: .error)
//        }
//        else if self.dictEditData.value(forKey: "designation") as! String == ""
//        {
//            SwiftMessageBar.showMessage(withTitle: "Please enter your designation", type: .error)
//        }
//        else if self.dictEditData.value(forKey: "industry") as! String == ""
//        {
//            SwiftMessageBar.showMessage(withTitle: "Please enter your industry", type: .error)
//        }
        else if self.dictEditData.value(forKey: "interests") as! String == ""
        {
            SwiftMessageBar.showMessage(withTitle: "Please enter your interests", type: .error)
        }
//        else if self.dictEditData.value(forKey: "city_name") as! String == ""
//        {
//            SwiftMessageBar.showMessage(withTitle: "Please enter your city name", type: .error)
//        }
        else if self.dictEditData.value(forKey: "country_name") as! String == ""
        {
            SwiftMessageBar.showMessage(withTitle: "Please enter your country name", type: .error)
        }
//        else if self.dictEditData.value(forKey: "user_email") as! String == ""
//        {
//            SwiftMessageBar.showMessage(withTitle: "Please enter your email", type: .error)
//        }
//        else if self.dictEditData.value(forKey: "image") as! String == ""
//        {
//            SwiftMessageBar.showMessage(withTitle: "Please add your profile picture", type: .error)
//        }
        else
        {
            
            let userName = self.dictEditData.value(forKey: "user_name")
            print(userName as Any)
            UserDefaults.standard .setValue(userName, forKey: "ifUserName")
            print(UserDefaults.standard .value(forKey: "ifUserName") as Any)
            
            hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Updating Profile...."
            hud.show(in: self.view)
            
            let connectedRef = Database.database().reference(withPath: ".info/connected")
            connectedRef.observeSingleEvent(of:.value, with: { snapshot in
                if snapshot.value as? Bool ?? false {
                    self.saveUserInfoToFirebaseDB()// Unhide commnt
                }
            })
        }
        
        
        /*let indexPath = self.indexPathTableView
        
        switch indexPath?.section {
        case EditProfileSection.profilePicture.rawValue:
            break
        case EditProfileSection.name.rawValue:
            switch indexPath?.row
            {
            case nameRows.FullName.rawValue:
                let cell = self.tblEditProfile.cellForRow(at: indexPath!) as! textfieldCell
                if cell.txtfield.text == "" || cell.txtfield.text == nil{
                    SwiftMessageBar.showMessage(withTitle: "Please enter your name", type: .error)
                }               
                break
                
            case nameRows.QuickBio.rawValue:
                let cell = self.tblEditProfile.cellForRow(at: indexPath!) as! textfieldWithDescCell
                if cell.txtViewInDesc.text == "" || cell.txtFieldInDesc.text == ""{
                    SwiftMessageBar.showMessage(withTitle: "Please enter quick bio about you", type: .error)
                }
                break
           
            case nameRows.Company.rawValue:
                let cell = self.tblEditProfile.cellForRow(at: indexPath!) as! textfieldCell
                if cell.txtfield.text == "" || cell.txtfield.text == nil{
                    SwiftMessageBar.showMessage(withTitle: "Please enter your company name", type: .error)
                }
               
                break
            case nameRows.Designation.rawValue:
                let cell = self.tblEditProfile.cellForRow(at: indexPath!) as! textfieldCell
                if cell.txtfield.text == "" || cell.txtfield.text == nil{
                    SwiftMessageBar.showMessage(withTitle: "Please enter your designation", type: .error)
                }
                
                break
            case nameRows.Industry.rawValue:
                let cell = self.tblEditProfile.cellForRow(at: indexPath!) as! textfieldCell
                if cell.txtfield.text == "" || cell.txtfield.text == nil{
                    SwiftMessageBar.showMessage(withTitle: "Please enter your industry", type: .error)
                }
                
                break
            default:
                break
            }
            break
        case EditProfileSection.institute.rawValue:
            //let dictInstituteData = NSMutableDictionary()
            let cell = self.tblEditProfile.cellForRow(at: indexPath!) as! instituteCell
            if cell.txtInstitute.text == "" && cell.txtPassingYear.text == ""
            {
                SwiftMessageBar.showMessage(withTitle: "Please enter your institute description", type: .error)
            }
            
            
            break
        case EditProfileSection.description.rawValue:
            switch indexPath?.row
            {
            case descriptionRows.Business.rawValue:
               let cell = self.tblEditProfile.cellForRow(at: indexPath!) as! textfieldCell
               if cell.txtfield.text == "" || cell.txtfield.text == nil{
                SwiftMessageBar.showMessage(withTitle: "Please enter your business", type: .error)
               }
                break
            case descriptionRows.City.rawValue:
                let cell = self.tblEditProfile.cellForRow(at: indexPath!) as! textfieldCell
                if cell.txtfield.text == "" || cell.txtfield.text == nil{
                    SwiftMessageBar.showMessage(withTitle: "Please enter your city name", type: .error)
                }
                break
            case descriptionRows.Country.rawValue:
                let cell = self.tblEditProfile.cellForRow(at: indexPath!) as! textfieldCell
                if cell.txtfield.text == "" || cell.txtfield.text == nil{
                    SwiftMessageBar.showMessage(withTitle: "Please enter your country name", type: .error)
                }
               
                break
            case descriptionRows.Email.rawValue:
                let cell = self.tblEditProfile.cellForRow(at: indexPath!) as! textfieldCell
                if cell.txtfield.text == "" || cell.txtfield.text == nil{
                    SwiftMessageBar.showMessage(withTitle: "Please enter your valid email", type: .error)
                }
               
                break
            /*case descriptionRows.Mobile.rawValue:
               let cell = self.tblEditProfile.cellForRow(at: indexPath!) as! textfieldCell
               if cell.txtfield.text == "" || cell.txtfield.text == nil{
                SwiftMessageBar.showMessage(withTitle: "Please enter your name", type: .error)
               }
                break*/
            default:
                break
            }
            break
        default:
            break
        }*/
      //saurabh  return
        
        print("textDataArray: ", self.textDataArr)
        
        /*if strImageUrl == ""
        {
            SwiftMessageBar.showMessage(withTitle: "Please add your profile picture", type: .error)
            return
        }*/
        
     
    }
    @IBAction func btnChangeUserProfile_Click(_ sender: Any)
    {
        
    }
    
    //MARK:- Upload Image On The Firebase Database

    /*func startUploading(completion: @escaping FileCompletionBlock) {
        if images.count == 0 {
            completion()
            return;
        }
        
        block = completion
        uploadImage(forIndex: 0)
    }*/
    
    func uploadImage(forIndex index:Int, userImage : UIImage)
    {
        let indexpath = IndexPath.init(row: 0, section: 0) //self.index
        let cell = self.tblEditProfile.cellForRow(at: indexpath) as! EditUserImageTableViewCell
        cell.imgUserProfile.image = userImage
        
        /// Perform uploading
        let data = UIImagePNGRepresentation(userImage)!
        let fileName = String(format: "%@.png", "yourUniqueFileName")
            
        FirebaseFile.shared.upload(data: data, withName: fileName, block: { (url) in
            /// After successfully uploading call this method again by increment the **index = index + 1**
            print(url ?? "Couldn't not upload. You can either check the error or just skip this.")
            //self.uploadImage(forIndex: index + 1, userImage: <#UIImage#>)
        })
        if block != nil {
            block!()
        }
        return

    }
    
    //MARK:- Image Picker View
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        guard let image = (info[UIImagePickerControllerOriginalImage] as? UIImage) else { return }
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.aspectRatioLockEnabled = true
        cropController.aspectRatioPickerButtonHidden = true
        cropController.aspectRatioPreset = .presetSquare
        
        cropController.delegate = self
        
        let indexpath = IndexPath.init(row: 0, section: 0) //self.index
        let cell = self.tblEditProfile.cellForRow(at: indexpath) as! profileCell
        cell.imgUserProfile.image = image
        
        //self.imgUserProfile.image = image
        
        //If profile picture, push onto the same navigation stack
        if croppingStyle == .circular {
            picker.pushViewController(cropController, animated: true)
        }
        else { //otherwise dismiss, and then present from the main controller
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
                //self.navigationController!.pushViewController(cropController, animated: true)
            })
        }
    }
    
    //MARK:- CropViewController Delegate Methods
    /***
     * Crop View Controller
     * Used to crop the image select from the gallery and camera
     ***/
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController)
    {
        cropViewController.dismiss(animated: true, completion: nil)
        let indexpath = IndexPath.init(row: 0, section: 0) //self.index
        let cell = self.tblEditProfile.cellForRow(at: indexpath) as! profileCell
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        var imageNew = UIImage()
        imageNew = image
        
        //self.imgUserProfile.image = image
        // layoutImageView()
        /*let storageRef = Storage.storage().reference().child("userProfileImages").child("myProfileImage.png")
        if let uploadData = UIImagePNGRepresentation(cell.imgUserProfile.image!)
        {
            storageRef.putData(uploadData, metadata: nil, completion: {(metadata, error) in
                if error != nil
                {
                    print("Image Error: ", error!)
                    return
                }
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else
                    {
                        // Uh-oh, an error occurred!
                        return
                    }
                    //let profileImageURL = downloadURL.absoluteString
                    self.strImageUrl = downloadURL.absoluteString
                    DefaultsValues.setStringValueToUserDefaults(self.strImageUrl, forKey: "edit_profile")
                    print("profileImageURL: ",downloadURL.absoluteString)
                    self.dictEditData.setValue(downloadURL.absoluteString, forKey: "image")
                }
                print("metadata: ",metadata!)
            })
        }*/
        
        let currentUserId = Auth.auth().currentUser?.uid
        //let storageRef = Storage.storage().reference().child("userProfileImages/\(currentUserId!).jpg")
        let strId = String(format: "%@.jpg", currentUserId!)
        let storageRef = Constant.userProfileStoragePath.child(strId) //("\(currentUserId!).jpg")
        //let storageRef = Storage.storage(url: Constant.ServerFirebaseURL).reference().child("userProfileImages/\(currentUserId!).jpg")
        if let uploadData = UIImageJPEGRepresentation(imageNew, 0.5)//(cell.imgUserProfile.image!, 0.5)
        {
            storageRef.putData(uploadData, metadata: nil, completion:{ (metadata, error) in
                if error != nil
                {
                    print("Image Error: ", error!)
                    return
                }
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else
                    {
                        // Uh-oh, an error occurred!
                        return
                    }
                    //let profileImageURL = downloadURL.absoluteString
                    self.strImageUrl = downloadURL.absoluteString
                    DefaultsValues.setStringValueToUserDefaults(self.strImageUrl, forKey: "edit_profile")
                    print("profileImageURL: ",downloadURL.absoluteString)
                    cell.imgUserProfile.image = image
                    cell.activityIndicator.stopAnimating()
                    cell.activityIndicator.isHidden = true
                    self.dictEditData.setValue(downloadURL.absoluteString, forKey: "image")
                }
                print("metadata: ",metadata!)
            })
        }
        
        //self.uploadImage(forIndex: indexpath.row, userImage: cell.imgUserProfile.image!)
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        UserDefaults.standard.setCustomObject(UIImagePNGRepresentation(image), forKey: "profile_image")
    }
    
    // Utility Method : base 64 String
    func encode(toBase64String image: UIImage?) -> String? {
        return UIImagePNGRepresentation(image!)?.base64EncodedString(options: .lineLength64Characters)
    }
    
    // MARK: - Table View Delegate Methods
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 200
            //return UITableViewAutomaticDimension
        }
        else
        {
            if indexPath.row == 0
            {
                return 90
            }
            else if indexPath.row == 1
            {
                return 110
            }
            else if indexPath.row == 2
            {
                return 90
            }
            else if indexPath.row == 3
            {
                return 90
            }
            else if indexPath.row == 4
            {
                return 90
            }
            else if indexPath.row == 5
            {
                return 90
            }
            else if indexPath.row == 6
            {
                return 150
            }
            else if indexPath.row == 7
            {
                return 150
            }
            else if indexPath.row == 8
            {
                return 90
            }
            else
            {
                return 120
            }           
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //let indexPath = IndexPath.init(row: 0, section: 0)
        if section == 0
        {
            return 1
        }
        else
        {
            return self.arrEditProfileTitle.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            print("IndexPath.row : 0");
            let cell:EditUserImageTableViewCell = self.tblEditProfile.dequeueReusableCell(withIdentifier: "idEditImageCell") as! EditUserImageTableViewCell
            cell.cellProfileDelegate = self
            return cell
        }
        else
        {
            let cell:EditProfileTableViewCell = self.tblEditProfile.dequeueReusableCell(withIdentifier: "idEditCell") as! EditProfileTableViewCell
            //cell.imgSettings.image = arrSettingsImgList[indexPath.row] as? UIImage
            cell.lblTitle.text = arrEditProfileTitle[indexPath.row] as? String
            cell.txtSubTitle.placeholder = arrTexfieldSubTitle[indexPath.row] as? String
            cell.txtSubTitle.tag = 100 + indexPath.row
            cell.txtSubTitle.text = textDataArr[indexPath.row] as? String
            
            if cell.txtSubTitle.text == "aaa"
            {
                cell.txtSubTitle.text = ""
               if indexPath.row == 0
                {
                    //guard (userDetails?.userName) != nil else { return }

                    cell.txtSubTitle.text = userDetails!.userName!
                    cell.lblExtraInfo.isHidden = true
                }
                if indexPath.row == 1
                {
                    cell.txtSubTitle.text = userDetails!.shortBio!
                    cell.lblExtraInfo.isHidden = false
                    cell.lblExtraInfo.text = "*Write a short note about you & your company (360 chars)"
                }
                if indexPath.row == 2
                {
                    cell.txtSubTitle.text = userDetails!.designation!
                    cell.lblExtraInfo.isHidden = true
                }
                if indexPath.row == 3
                {
                    cell.txtSubTitle.text = userDetails!.companyName!
                    cell.lblExtraInfo.isHidden = true
                }
                if indexPath.row == 4
                {
                    cell.txtSubTitle.text = userDetails!.industry!
                    cell.lblExtraInfo.isHidden = true
                }
                if indexPath.row == 5
                {
                    //cell.txtSubTitle.text = userDetails!.institutes!
                    cell.lblExtraInfo.isHidden = true
                }
                if indexPath.row == 6
                {
                    cell.txtSubTitle.text = userDetails!.interests!
                    cell.lblExtraInfo.isHidden = false
                    cell.lblExtraInfo.text = "*Use #tags to add interests. This is important to receive relevant messages. E.g. #Marketing, #E-Commerce, #ProductName"
                }
                if indexPath.row == 7
                {
                    cell.txtSubTitle.text = userDetails!.cityName!
                    cell.lblExtraInfo.isHidden = false
                    cell.lblExtraInfo.text = "* Your current city. Mesh does not track location, hence it's important to add City so other chatInfo members know where you operate from."
                }
                if indexPath.row == 8
                {
                    cell.txtSubTitle.text = userDetails!.countryName!
                    cell.lblExtraInfo.isHidden = true
                }
                if indexPath.row == 9
                {
                    cell.txtSubTitle.text = userDetails!.userEmail!
                    cell.lblExtraInfo.isHidden = false
                    cell.lblExtraInfo.text = "Visible to all users you share a group with"
                }
                if indexPath.row == 10
                {
                    cell.txtSubTitle.text = userDetails!.phone!
                    cell.lblExtraInfo.isHidden = false
                    cell.lblExtraInfo.text = "Visible to you and your contacts. Not visible to other users in a groups"
                }
            }
            else
            {
                cell.txtSubTitle.text = textDataArr[indexPath.row] as? String
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }*/
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let appendNumber: Int = arrInstitute.count + 1
        arrInstitute.append(appendNumber)
        tblEditProfile.beginUpdates()
        tblEditProfile.insertRows(at: [IndexPath(row: appendNumber, section: EditProfileSection.institute.rawValue)], with: .automatic)
        tblEditProfile.endUpdates()
        // Your action
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return EditProfileSection.sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case EditProfileSection.profilePicture.rawValue:
            return profilePictureRows.profileRowCount
        case EditProfileSection.name.rawValue:
            return nameRows.nameRowsCount
        case EditProfileSection.institute.rawValue:
            return arrInstitute.count + 1
        case EditProfileSection.description.rawValue:
            return descriptionRows.descriptionRowsCount
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case EditProfileSection.profilePicture.rawValue:
            switch indexPath.row {
            case profilePictureRows.addProfile.rawValue:
                if let cell:profileCell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as? profileCell{
                    let strUserImage = userDetails?.userImage
                    if strUserImage != ""
                    {
                        cell.imgUserProfile.sd_setImage(with: URL(string: strUserImage!), placeholderImage: UIImage(named: "gallery1"))
                    }
                    cell.cellProfileDelegate = self
                    cell.activityIndicator.isHidden = true
                  
                    return cell
                }
                break
            default:
                break
            }
            
        case EditProfileSection.name.rawValue:
            switch indexPath.row {
            case nameRows.FullName.rawValue, nameRows.Company.rawValue, nameRows.Designation.rawValue, nameRows.Industry.rawValue:
                if let cell:textfieldCell = tableView.dequeueReusableCell(withIdentifier: "textfieldCell") as? textfieldCell{
                    switch indexPath.row
                    {
                    case nameRows.FullName.rawValue :
                        cell.lblTitle.text = "Full Name*"
                        cell.txtfield.placeholder = "Name"
                        cell.txtfield.text = dictEditData .value(forKey: "user_name") as? String
                        
                    case nameRows.Company.rawValue :
                        cell.lblTitle.text = "Company"//"Company*"
                        cell.txtfield.placeholder = "Your current company"
                        cell.txtfield.text = dictEditData .value(forKey: "company") as? String
                        
                    case nameRows.Designation.rawValue :
                        cell.lblTitle.text = "Designation"//"Designation*"
                        cell.txtfield.placeholder = "Designation at your current company"
                        cell.txtfield.text = dictEditData .value(forKey: "designation") as? String
                        
                    case nameRows.Industry.rawValue :
                        cell.lblTitle.text = "Industry"//"Industry*"
                        cell.txtfield.placeholder = "Industry your company operates in"
                        cell.txtfield.text = dictEditData .value(forKey: "industry") as? String
                        
                    default:
                        break
                    }
                    cell.txtfield.delegate = self
                    return cell
                }
                
            /*case nameRows.QuickBio.rawValue:
                if let cell:textfieldWithDescCell = tableView.dequeueReusableCell(withIdentifier: "textfieldWithDescCell") as? textfieldWithDescCell{
                    cell.lblTitleInDesc.text = "Quick Bio"
                    cell.txtFieldInDesc.placeholder = "Add bio here"
                    cell.lblInDesc.text = "*Write a short note about you & your company (360 chars)"
                    cell.txtFieldInDesc.delegate = self
                    cell.txtFieldInDesc.text = dictEditData.value(forKey: "short_bio") as? String
                    return cell
                }
                break*/
                
            case nameRows.QuickBio.rawValue:
                if let cell:textfieldWithDescCell = tableView.dequeueReusableCell(withIdentifier: "textfieldWithDescCell") as? textfieldWithDescCell{
                    cell.lblTitleInDesc.text = "Quick Bio*"
                    cell.txtViewInDesc.isHidden = false
                    cell.txtFieldInDesc.isHidden = true
                    
                    // cell.txtFieldInDesc.placeholder = "Add bio here"
                    cell.lblInDesc.text = "*Write a short note about you & your company (360 chars)"
                    cell.txtViewInDesc.delegate = self
                    let strBio = dictEditData .value(forKey: "short_bio") as? String
                    if strBio?.count ?? 0 > 0
                    {
                        cell.txtViewInDesc.text = strBio
                        cell.txtViewInDesc.textColor = UIColor.black
                    }
                    else
                    {
                        cell.txtViewInDesc.text = "Add bio here"
                        cell.txtViewInDesc.textColor = UIColor.lightGray
                    }
                    cell.txtViewInDesc.sizeToFit()
                    
                    return cell
                }
                break
                
            default:
                break
            }
            
        case EditProfileSection.institute.rawValue:
            switch indexPath.row {
            case instituteRows.Institute.rawValue:
                print("arrInstitute.count: ", arrInstitute.count)
                if let cell:instituteCell = tableView.dequeueReusableCell(withIdentifier: "InstituteSectionCell") as? instituteCell{
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))

                    cell.imgPlus.isUserInteractionEnabled = true
                    cell.imgPlus.addGestureRecognizer(tapGestureRecognizer)

                    return cell
                }
                break
                
            default:
                if let cell:instituteCell = tableView.dequeueReusableCell(withIdentifier: "InstituteCell") as? instituteCell{
                    cell.txtInstitute.delegate = self
                    cell.txtPassingYear.delegate = self // this we have kep userinteraction as disabled so no need for delegate
                    
//                    if DefaultsValues.getCustomObjFromUserDefaults_(forKey: kInstituteList) != nil
//                    {
//                        let arrData = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kInstituteList) as! NSArray
//                        //let dict = arrData[0] as! NSDictionary
//                        //print("dict: ", dict.value(forKey: "institute_name") as! String)
//                        //cell.txtInstitute.text = (dict.value(forKey: "institute_name") as! String)//(arrData[0] as AnyObject).value(forKey: "institute_name") as? String
//                        if arrData.count > 0 && arrData.count == arrInstitute.count //this condition is checked so that user can add empty textfield when user tap + button, if not done so app will crash becoz arrData will not contain data
//                        {
//                            let dict:NSMutableDictionary = arrData.object(at: indexPath.row - 1) as! NSMutableDictionary
//                            cell.txtInstitute.text = dict .value(forKey: "institute_name") as? String
//                            cell.txtPassingYear.text = dict .value(forKey: "institute_passing_year") as? String
//                        }
//                    }
                    /*let arrData:NSMutableArray = dictEditData.value(forKey: "institute") as! NSMutableArray
                    if dictEditData != nil
                    {
                        if arrData.count > 0 && arrData.count == arrInstitute.count //this condition is checked so that user can add empty textfield when user tap + button, if not done so app will crash becoz arrData will not contain data
                        {
                            let dict:NSMutableDictionary = arrData.object(at: indexPath.row - 1) as! NSMutableDictionary
                            cell.txtInstitute.text = dict .value(forKey: "institute_name") as? String
                            cell.txtPassingYear.text = dict .value(forKey: "institute_passing_year") as? String
                        }
                    }*/
                    return cell
                }
                break
            }
            
        case EditProfileSection.description.rawValue:
            switch indexPath.row {
            case descriptionRows.Business.rawValue, descriptionRows.City.rawValue, descriptionRows.Mobile.rawValue, descriptionRows.Email.rawValue:
                if let cell:textfieldWithDescCell = tableView.dequeueReusableCell(withIdentifier: "textfieldWithDescCell") as? textfieldWithDescCell{
                    cell.txtViewInDesc.isHidden = true
                    cell.txtFieldInDesc.isHidden = false
                    cell.txtFieldInDesc.isUserInteractionEnabled = true
                    switch indexPath.row
                    {
                    case descriptionRows.Business.rawValue:
                        cell.lblTitleInDesc.text = "Business Interests/ Expertise*"
                        cell.txtFieldInDesc.isUserInteractionEnabled = true
                        cell.txtFieldInDesc.placeholder = "Add comma seperated #interests here"
                        cell.lblInDesc.text = "*Use #tags to add interests. This is important to receive relevant messages. E.g. #Marketing, #E-Commerce, #ProductName"
                        cell.txtFieldInDesc.text = dictEditData .value(forKey: "interests") as? String
                        
                    case descriptionRows.City.rawValue:
                        cell.lblTitleInDesc.text = "City"//"City*"
                        cell.txtFieldInDesc.placeholder = "Add your city here"
                        cell.txtFieldInDesc.isUserInteractionEnabled = true
                        cell.lblInDesc.text = "* Your current city. Mesh does not track location, hence it's important to add City so other chatInfo members know where you operate from."
                        cell.txtFieldInDesc.text = dictEditData .value(forKey: "city_name") as? String
                        
                    case descriptionRows.Email.rawValue:
                        cell.txtFieldInDesc.isUserInteractionEnabled = true
                        cell.lblTitleInDesc.text = "Email"//"Email*"
                        cell.txtFieldInDesc.placeholder = "Your email id"
                        cell.lblInDesc.text = "Visible to all users you share a group with"
                        cell.txtFieldInDesc.text = dictEditData .value(forKey: "user_email") as? String
                        
                    case descriptionRows.Mobile.rawValue:
                        cell.txtFieldInDesc.isUserInteractionEnabled = false
                        cell.lblTitleInDesc.text = "Mobile (Uneditable)"
                        cell.txtFieldInDesc.placeholder = "Your mobile number"
                        cell.lblInDesc.text = "Visible to you and your contacts. Not visible to other users in a groups"
                        cell.txtFieldInDesc.text = dictEditData .value(forKey: "contact_no") as? String
                    default:
                        break
                    }
                    cell.txtFieldInDesc.delegate = self
                    return cell
                }
                break
                
            case descriptionRows.Country.rawValue:
                if let cell:textfieldCell = tableView.dequeueReusableCell(withIdentifier: "textfieldCell") as? textfieldCell{
                    cell.lblTitle.text = "Country"//"Country*"
                    cell.txtfield.placeholder = "You Country"
                    cell.txtfield.delegate = self
                    cell.txtfield.text = dictEditData .value(forKey: "country_name") as? String
                    return cell
                }
                
                break
                
            default:
                break
            }
            
        default:
            break
        }
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return ((tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath))?.contentView.frame.size.height)!
        }
        else
        {
            return tableView.estimatedRowHeight
        }
        
        //return ((tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath))?.contentView.frame.size.height)!
    }
    
    //MARK:- UItextView Delegate Methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        tblEditProfile.beginUpdates()
        let paddingForTextView:CGFloat = 40 //Padding varies depending on your cell design
        let rowHeight = textView.contentSize.height+paddingForTextView
        print("rowHeight", rowHeight)
        tblEditProfile.endUpdates()
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxLength = 360
        let currentString: NSString = textView.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: text) as NSString
        print("string length", newString.length)
        return newString.length < maxLength
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.isEmpty {
            textView.text = "Add bio here"
            textView.textColor = UIColor.lightGray
            dictEditData.setValue("", forKey: "short_bio");
        }
        else
        {
            var indexPath: IndexPath? = nil
            if (textView.superview?.superview is textfieldWithDescCell)
            {
                let cell = textView.superview?.superview as? textfieldWithDescCell
                
                if let aCell = cell {
                    indexPath = tblEditProfile.indexPath(for: aCell)
                    self.indexPathTableView = indexPath
                    dictEditData.setValue(textView.text, forKey: "short_bio")
                    print("section, row:", indexPath?.section ?? 123, indexPath?.row ?? 123)
                }
            }
        }
        return true
    }
    
    //MARK:- UITextfield Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField .resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        
        // for getting indexPath you can use any of these way
        /* //----->1
         if (textField.superview?.superview is textfieldCell) {
         let cell: textfieldCell = textField.superview?.superview as! textfieldCell
         let textFieldIndexPath = tblEditProfile.indexPath(for: cell)
         print("textFieldIndexPath section, row:", textFieldIndexPath?.section ?? 123, textFieldIndexPath?.row ?? 123)
         }
         else if (textField.superview?.superview is textfieldWithDescCell)
         {
         let cell: textfieldWithDescCell = textField.superview?.superview as! textfieldWithDescCell
         let textFieldIndexPath = tblEditProfile.indexPath(for: cell)
         print("textFieldIndexPath section, row:", textFieldIndexPath?.section ?? 123, textFieldIndexPath?.row ?? 123)
         }
         else
         {
         let cell: instituteCell = textField.superview?.superview as! instituteCell
         let textFieldIndexPath = tblEditProfile.indexPath(for: cell)
         print("textFieldIndexPath section, row:", textFieldIndexPath?.section ?? 123, textFieldIndexPath?.row ?? 123)
         }//<------*/  // This is just one way to get the indexpath
        
            var indexPath: IndexPath? = nil
            //----->2
            if (textField.superview?.superview is textfieldCell) {
                let cell = textField.superview?.superview as? textfieldCell
                self.tableViewNewCell = cell
                
                if let aCell = cell {
                    indexPath = tblEditProfile.indexPath(for: aCell)
                    self.indexPathTableView = indexPath
                    print("section, row:", indexPath?.section ?? 123, indexPath?.row ?? 123)
                }
            }
            else if (textField.superview?.superview is textfieldWithDescCell)
            {
                let cell = textField.superview?.superview as? textfieldWithDescCell
                self.tableViewNewCell = cell
                if let aCell = cell {
                        indexPath = tblEditProfile.indexPath(for: aCell)
                        self.indexPathTableView = indexPath
                        print("section, row:", indexPath?.section ?? 123, indexPath?.row ?? 123)
                    }
            }
            else
            {
                let cell = textField.superview?.superview as? instituteCell
                self.tableViewNewCell = cell
                if let aCell = cell {
                    indexPath = tblEditProfile.indexPath(for: aCell)
                    self.indexPathTableView = indexPath
                    print("section, row:", indexPath?.section ?? 123, indexPath?.row ?? 123)
                }
            }//<------
            
            
            switch indexPath?.section {
            case EditProfileSection.profilePicture.rawValue:
                    //dictEditData.setValue("", forKey: "company");
                    self.indexPathTableView = indexPath
                break
            case EditProfileSection.name.rawValue:
                switch indexPath?.row
                {
                case nameRows.FullName.rawValue:
                   if !(textField.text?.isEmpty)!
                    {
                           dictEditData.setValue(textField.text, forKey: "user_name");
                    }
                   else
                   {
                        dictEditData.setValue("", forKey: "user_name");
                   }
                   
                self.indexPathTableView = indexPath
                    break
                // case nameRows.QuickBio.rawValue: dictEditData.setValue(textField.text, forKey: "short_bio"); break //  since we have chaged it to textview and we have done all the coding in textview delegate
                case nameRows.Company.rawValue:
                    if !(textField.text?.isEmpty)!
                    {
                        dictEditData.setValue(textField.text, forKey: "company");
                    }
                    else
                    {
                        dictEditData.setValue("", forKey: "company");
                    }
                    self.indexPathTableView = indexPath
                    break
                case nameRows.Designation.rawValue:
                    if !(textField.text?.isEmpty)!
                    {
                        dictEditData.setValue(textField.text, forKey: "designation");
                    }
                    else
                    {
                        dictEditData.setValue("", forKey: "designation");
                    }
                    self.indexPathTableView = indexPath
                    break
                case nameRows.Industry.rawValue:
                    if !(textField.text?.isEmpty)!
                    {
                        dictEditData.setValue(textField.text, forKey: "industry");
                    }
                    else
                    {
                        dictEditData.setValue("", forKey: "industry");
                    }
                    self.indexPathTableView = indexPath
                    break
                default:
                    break
                }
                break
            case EditProfileSection.institute.rawValue:
                let dictInstituteData = NSMutableDictionary()
                //arrInstituteData = NSMutableArray.init()
                
                let cell = textField.superview?.superview as? instituteCell
                self.indexPathTableView = indexPath
                if !(textField.text?.isEmpty)!
                {
                    if textField == cell?.txtInstitute
                    {
                        DefaultsValues.setStringValueToUserDefaults(textField.text, forKey: "institute_name")
                    }
                    else if textField == cell?.txtPassingYear
                    {
                        let strInstituteName = DefaultsValues.getStringValueFromUserDefaults_(forKey: "institute_name")
                        if strInstituteName != "" || strInstituteName != nil
                        {
                            dictInstituteData.setValue(strInstituteName, forKey: "institute_name")
                            dictInstituteData.setValue(textField.text, forKey: "institute_passing_year")
                            arrInstituteData.add(dictInstituteData)
                            dictEditData.setValue(arrInstituteData, forKey: "institute")
                        }
                        DefaultsValues.setCustomObjToUserDefaults(arrInstituteData, forKey: "institute")
                    }
                }
                else
                {
                    arrInstituteData = NSMutableArray.init()
                    dictInstituteData.setValue("", forKey: "institute_name")
                    dictInstituteData.setValue("", forKey: "institute_passing_year")
                    arrInstituteData.add(dictInstituteData)
                    dictEditData.setValue(arrInstituteData, forKey: "institute")
                }
                break
            case EditProfileSection.description.rawValue:
                switch indexPath?.row
                {
                case descriptionRows.Business.rawValue:
                    if !(textField.text?.isEmpty)!
                    {
                        dictEditData.setValue(textField.text, forKey: "interests");
                    }
                    else
                    {
                        dictEditData.setValue("", forKey: "interests")
                    }
                    self.indexPathTableView = indexPath
                    break
                case descriptionRows.City.rawValue:
                    if !(textField.text?.isEmpty)!
                    {
                        dictEditData.setValue(textField.text, forKey: "city_name");
                    }
                    else
                    {
                        dictEditData.setValue("", forKey: "city_name")
                    }
                    self.indexPathTableView = indexPath
                    break
                case descriptionRows.Country.rawValue:
                    if !(textField.text?.isEmpty)!
                    {
                        dictEditData.setValue(textField.text, forKey: "country_name");
                    }
                    else
                    {
                        dictEditData.setValue("", forKey: "country_name")
                    }
                    self.indexPathTableView = indexPath
                    break
                case descriptionRows.Email.rawValue:
                    if !(textField.text?.isEmpty)!
                    {
                        dictEditData.setValue(textField.text, forKey: "user_email");
                    }
                    else
                    {
                        dictEditData.setValue("", forKey: "user_email")
                    }
                    self.indexPathTableView = indexPath
                    break
                case descriptionRows.Mobile.rawValue:
                    if !(textField.text?.isEmpty)!
                    {
                        dictEditData.setValue(textField.text, forKey: "contact_no");
                    }
                    else
                    {
                        dictEditData.setValue("", forKey: "contact_no")
                    }
                    self.indexPathTableView = indexPath
                    break
                default:
                    break
                }
                break
            default:
                break
            }
            print("dictEditData", dictEditData)
        return true
    }
    
    //MARK:- Choose Image
    
    func didChangeImage(_ tag: Int)
    {
        let actionSheet = UIAlertController(title: "Choose any option", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default , handler:{ (UIAlertAction)in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Gallery", style: .default , handler:{ (UIAlertAction)in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        self.present(actionSheet, animated: true, completion: {
            print("completion block")
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in
            
            //self.isCameraClicked = false
            self.dismiss(animated: true, completion: nil)
            //            dismiss(animated: true, completion: {
            //                isClickedCamera = false
            //            })
        }))
    }
}

