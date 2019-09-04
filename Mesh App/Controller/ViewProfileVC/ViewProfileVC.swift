//
//  ViewProfileVC.swift
//  Mesh App
//
//  Created by Mac admin on 26/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseDatabase
import FirebaseAuth

let SectionHeaderHeight: CGFloat = 65.0

class ViewProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, selectedMyMediaDelegate, menuViewDelegate, MyProfileImageCellDelegate, cellEditBioDelegate {

    @IBOutlet weak var tblViewProfile: UITableView!
    
    var viewMenuXib : MenuView!
    var viewTransparent : UIView!
    var appd = AppDelegate()
    
    var arrSettingsList = NSArray()
    var strIsFromGroupProfileList : String = ""
    var dictGroupInfo = NSDictionary()
    var dictParticipants = NSDictionary()
    var strReceiverKey : String = ""
    //var arrProfileImgList = NSArray()
    //var arrSettingsImgList = NSArray()
    
    @IBOutlet weak var btnNext: UIButton!
    var arrUserProfileDetails = NSMutableArray()
    
    var arrSectionData = NSArray()
    //var arrRowData = NSArray()
    
    var refDatabase: DatabaseReference!
    
    var userDetails : UserDetailsModel?
    var participantsDetails : Participants?
    var arrUserDetails = NSMutableArray()
    var isClickedChatInfoButtonVC : String = ""
    
    let arrRowData = [[""],[""],["Industry", "Institute/School", "Business Interests / Expertise"], ["City", "Country"], ["Email Id", "Mobile No."]]
    
    let arrProfileImgList = [[""],[""],["industry", "inst_school", "Interest"], ["city", "country"], ["email", "mobile_number"]]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        appd = UIApplication.shared.delegate as! AppDelegate
        // Do any additional setup after loading the view.
        
        arrSettingsList = ["Account", "Notifications", "Help & Legal",  "Tell a Friend"];
        //arrSettingsImgList = [UIImage(named: "industry")!, UIImage(named: "institute")!, UIImage(named: "Interest")!, UIImage(named: "city")!,UIImage(named: "country")!,UIImage(named: "email")!,UIImage(named: "mobile")!]
        
        arrSectionData = ["1", "2", "3", "4", "5"]
        
//        arrRowData = [["1"], ["Morden Marvel's", "Add your small description"], ["1"], ["1"], [["Latesh Kumar", "Urgent call only"], ["Ashish Bebni", "1234567890"], ["Diksha", "098765"], ["Mohit", "123456"]], ["Exir Group", ""]]
        
        print("USER DETAILS: ",userDetails as Any)

        self.tblViewProfile.delegate = self
        self.tblViewProfile.dataSource = self
        self.tblViewProfile.estimatedRowHeight = 100.0
        self.tblViewProfile.rowHeight = UITableViewAutomaticDimension
        self.tblViewProfile.tableFooterView = UIView()
        self.tblViewProfile.reloadData()
        
        if self.isClickedChatInfoButtonVC == "false"
        {
            self.btnNext.isHidden = true
            
            /*var dictPartcipantsDetail = NSMutableDictionary()
            let refParticipantsInfo = ChatConstants.refs.databaseUserInfo.child(self.participantsDetails!.participantsId!)
            refParticipantsInfo.observeSingleEvent(of: .childAdded, with: {snapshot in
                for child in snapshot.children
                {
                    let snap = child as! DataSnapshot
                    dictPartcipantsDetail = snapshot.value as! NSMutableDictionary
                }
                self.userDetails = UserDetailsModel.init(dictionary:dictPartcipantsDetail)!
            }, withCancel: nil)*/
        
        }
        else if self.isClickedChatInfoButtonVC == "true"
        {
            // bhipi
            //self.btnNext.isHidden = false
            self.btnNext.isHidden = true

            userDetails = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kParticipantDetail) as? UserDetailsModel
            print(userDetails)
            /*let connectedRef = Database.database().reference(withPath: ".info/connected")
            //let deadlineTime = DispatchTime.now() + .seconds(2)
            //DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            connectedRef.observe(.value, with: { snapshot in
                if snapshot.value as? Bool ?? false {
                    self.arrUserProfileDetails.add(self.userDetails!)
                    print("self.arrUserProfileDetails: ", self.arrUserProfileDetails)
                    self.removeTheCustomView()
                    
                    self.refDatabase = Database.database().reference()
                    let allUserList = self.refDatabase.child("UserInfo")
                    print("allUserList: ", allUserList)
                    allUserList.observeSingleEvent(of: .value, with: { snapshot in
                        
                        for child in snapshot.children {
                            let snap = child as! DataSnapshot
                            print("snap.value: ", snap.value!)
                            let userDict = snap.value as? [String: AnyObject]
                            self.arrUserDetails.add(userDict!)
                        }
                        print("arrUserDetails: ",self.arrUserDetails)
                    })
                    print("Connected")
                }
                else
                {
                    let otherAlert = UIAlertController(title: "Network Issue", message: "Please check you internet connection", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                    otherAlert.addAction(okAction)
                    otherAlert.addAction(cancelAction)
                    self.present(otherAlert, animated: true, completion: nil)
                }
            })*/
            //})
        }   
        else
        {
            // bhupi
            //self.btnNext.isHidden = false
            self.btnNext.isHidden = true

            userDetails = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kUserDetails) as? UserDetailsModel
            print("userDetails: ", userDetails!)
        }
 }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func btnNext_Click(_ sender: Any)
    {
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            let objChatListVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idChatListVC") as! ChatListVC
            self.refDatabase = Database.database().reference()
            self.navigationController?.pushViewController(objChatListVC, animated: true)
        })        
    }
    
    @IBAction func btnBack_Click(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            //return UITableViewAutomaticDimension
            return 250
        }
        else
        {
            return ((tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath))?.contentView.frame.size.height)!
        }
        
        /*if indexPath.row == 0
        {
            //return UITableViewAutomaticDimension
            return 200
        }
        else
        {
            return ((tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath))?.contentView.frame.size.height)!
        }*/
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //return 9
        if section == 0
        {
            return 1
        }
        else
        {
            return  (self.arrRowData[section] as AnyObject).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            let cell:ViewProfileImageTableViewCell = self.tblViewProfile.dequeueReusableCell(withIdentifier: "idProfileImageCell") as! ViewProfileImageTableViewCell
            cell.cellMyImageDelegate = self
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            //DispatchQueue.async(group: DispatchQueue.main(),execute: {
            let strImage =  userDetails?.userImage
            
            if strImage == nil
            {
                cell.imgUserImage.image = UIImage(named: "gallery")
            }
            else
            {
                cell.imgUserImage.sd_setImage(with: URL(string: userDetails!.userImage!), placeholderImage: UIImage(named: "gallery"))
            }
            //})
            return cell
        }
        if indexPath.section == 1
        {
            let cell:ViewProfileNameBioTableViewCell = self.tblViewProfile.dequeueReusableCell(withIdentifier: "idProfileNameBioCell") as! ViewProfileNameBioTableViewCell
            
            /*if self.isClickedChatInfoButtonVC == "true"
            {
                cell.btnEditInfo.isHidden = true
            }
            else if self.isClickedChatInfoButtonVC == "false"
            {
                cell.btnEditInfo.isHidden = false
            }*/
            
            print(self.strIsFromGroupProfileList)
            if self.strIsFromGroupProfileList == "true"
            {
                self.btnNext.isHidden = true
                cell.btnEditInfo.setImage(UIImage(named: "messages"), for: UIControlState.normal)
            }
            else
            {
                // bhupi
                //self.btnNext.isHidden = false
                self.btnNext.isHidden = true
                cell.btnEditInfo.setImage(UIImage(named: "edit_profile"), for: UIControlState.normal)

            }
            
            /*if self.strIsFromGroupProfileList == "true"
            {
                 cell.btnEditInfo.isHidden = false
                cell.btnEditInfo.setBackgroundImage(UIImage(named: "chat_selected"), for: UIControlState.normal)
            }
            else if self.strIsFromGroupProfileList == "false"
            {
                cell.btnEditInfo.isHidden = false
                cell.btnEditInfo.setBackgroundImage(UIImage(named: "edit"), for: UIControlState.normal)
            }*/
            
            print(userDetails as Any)
            cell.lblName.text! = userDetails!.userName!
            cell.lblDesignation.text! = userDetails!.designation!
            cell.lblShortBio.text! = userDetails!.shortBio!
            cell.cellBioDelegate = self
            cell.tag = indexPath.row
            return cell
        }
        if indexPath.section == 2
        {
            let cell:ViewProfileTableViewCell = self.tblViewProfile.dequeueReusableCell(withIdentifier: "idViewProfileCell") as! ViewProfileTableViewCell
            cell.lblProfileTitle.text = arrRowData[indexPath.section][indexPath.row]
            let strImage = arrProfileImgList[indexPath.section][indexPath.row]
            cell.imgProfileDetails.image = UIImage(named: strImage)
            
            if indexPath.row == 0
            {
                cell.lblProfileDescription.text = userDetails!.industry!
            }
            if indexPath.row == 1
            {
                var arrInstituteList = NSArray()
                var strInstituteData : String = ""
                 if self.isClickedChatInfoButtonVC == "false"
                {
                     //arrInstituteList = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kParticipantsInstituteList) as! NSArray
                    if DefaultsValues.getCustomObjFromUserDefaults_(forKey: kParticipantsInstituteList) != nil
                    {
                        arrInstituteList = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kParticipantsInstituteList) as! NSArray
                        strInstituteData = String(format: "%@ - %@", (arrInstituteList[0] as AnyObject).value(forKey: "institute_name") as! CVarArg, (arrInstituteList[0] as AnyObject).value(forKey: "institute_passing_year") as! CVarArg)
                    }
                    else
                    {
                        strInstituteData = ""
                    }
                }
                else if self.isClickedChatInfoButtonVC == "true"
                {
                    if DefaultsValues.getCustomObjFromUserDefaults_(forKey: kParticipantsInstituteList) != nil
                    {
                        arrInstituteList = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kParticipantsInstituteList) as! NSArray
                        strInstituteData = String(format: "%@ - %@", (arrInstituteList[0] as AnyObject).value(forKey: "institute_name") as! CVarArg, (arrInstituteList[0] as AnyObject).value(forKey: "institute_passing_year") as! CVarArg)
                    }
                    else
                    {
                        strInstituteData = ""
                    }
                }
                else
                {
                    if DefaultsValues.getCustomObjFromUserDefaults_(forKey: kInstituteList) != nil
                    {
                        print(DefaultsValues.getCustomObjFromUserDefaults_(forKey: kInstituteList) as Any)
                        
                        //bk 19 june
                        
                      arrInstituteList = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kInstituteList) as! NSArray
//                        strInstituteData = String(format: "%@ - %@", (arrInstituteList[0] as AnyObject).value(forKey: "institute_name") as! CVarArg, (arrInstituteList[0] as AnyObject).value(forKey: "institute_passing_year") as! CVarArg)
                    }
                    else
                    {
                        strInstituteData = ""
                    }
                }
                cell.lblProfileDescription.text = strInstituteData
                
                //cell.lblProfileDescription.text = String(format: "%@ - %@", (arrInstituteList[0] as AnyObject).value(forKey: "institute_name") as! CVarArg, (arrInstituteList[0] as AnyObject).value(forKey: "institute_passing_year") as! CVarArg)                
            }
            if indexPath.row == 2
            {
                cell.lblProfileDescription.text = userDetails!.interests!
            }
            return cell
        }
        if indexPath.section == 3
        {
            let cell:ViewProfileTableViewCell = self.tblViewProfile.dequeueReusableCell(withIdentifier: "idViewProfileCell") as! ViewProfileTableViewCell
            cell.lblProfileTitle.text = arrRowData[indexPath.section][indexPath.row]
            let strImage = arrProfileImgList[indexPath.section][indexPath.row]
            cell.imgProfileDetails.image = UIImage(named: strImage)
            
            if indexPath.row == 0
            {
                cell.lblProfileDescription.text = userDetails!.cityName!
            }
            if indexPath.row == 1
            {
                cell.lblProfileDescription.text = userDetails!.countryName!
            }
            return cell
        }
        else
        {
            let cell:ViewProfileTableViewCell = self.tblViewProfile.dequeueReusableCell(withIdentifier: "idViewProfileCell") as! ViewProfileTableViewCell
            cell.lblProfileTitle.text = arrRowData[indexPath.section][indexPath.row]
            let strImage = arrProfileImgList[indexPath.section][indexPath.row]
            cell.imgProfileDetails.image = UIImage(named: strImage)
            
            if indexPath.row == 0
            {
                cell.lblProfileDescription.text = userDetails!.userEmail!
            }
            if indexPath.row == 1
            {
                cell.lblProfileDescription.text = userDetails!.phone!
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 1
        {
            if indexPath.row == 0
            {
//                let objAccountVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idAccountVC") as! AccountVC
//                self.navigationController?.pushViewController(objAccountVC, animated: true)
            }
            else if indexPath.row == 1
            {
//                let objNotificationsVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idNotificationsVC") as! NotificationsVC
//                self.navigationController?.pushViewController(objNotificationsVC, animated: true)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.arrSectionData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0 || section == 1 || section == 2
        {
            return 0.0
        }
        else
        {
            return 20.0 //SectionHeaderHeight
        }
    }
    
    func removeTheCustomView()
    {
        if (viewMenuXib != nil)
        {
            viewMenuXib.removeFromSuperview()
            viewMenuXib = nil
            viewTransparent.removeFromSuperview()
            viewTransparent = nil
        }
    }
    
    //MARK:- Custom Delegate Methods
    
    func didSelectedParticularMedia_Click(_ tag: Int, _strImage: String)
    {
        print("I have pressed a button with a tag: \(tag)")
        let objSelectedImageVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idSelectedImageVC") as! SelectedImageVC
        objSelectedImageVC.strSelectedImage = _strImage
        self.navigationController?.pushViewController(objSelectedImageVC, animated: true)
    }
    
    func didSelectMyMedia_Click(_ tag: Int)
    {
        let objMediaVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idMediaVC") as! MediaVC
        self.navigationController?.pushViewController(objMediaVC, animated: true)
    }
    
    func didMyProfileMenuButton(_ tag: Int)
    {
        let indexpath = IndexPath.init(row: 0, section: 0) //self.index
        let cell = self.tblViewProfile.cellForRow(at: indexpath) as! ViewProfileImageTableViewCell
        viewMenuXib = MenuView(frame: CGRect(x: cell.lblProfileText.frame.size.width - 10, y: cell.frame.origin.y + 10, width: 150, height: 200))
        viewTransparent = UIView(frame: CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.size.width, height: cell.frame.size.height))
        viewTransparent.backgroundColor = UIColor.black
        viewTransparent.alpha = 0.6
        cell.addSubview(viewTransparent)
        cell.addSubview(viewMenuXib)
        viewMenuXib.layer.cornerRadius = 5
        viewMenuXib.layer.masksToBounds = true
        viewMenuXib.backgroundColor = UIColor.white
        viewMenuXib.menuDelegate = self
        viewMenuXib.dropShadow()
    }
    
   func navigateToController(index: Int)
    {
        if index == 0
        {
            let objTermsAndPoliciesVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idTermsAndPoliciesVC") as! TermsAndPoliciesVC
            self.navigationController?.pushViewController(objTermsAndPoliciesVC, animated: true)
        }
        else if index == 1
        {
            let objEditProfileVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idEditProfileVC") as! EditProfileVC
            self.navigationController?.pushViewController(objEditProfileVC, animated: true)
        }
        else if index == 2
        {
            let objCreateGroupVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idCreateGroupVC") as! CreateGroupVC
            self.navigationController?.pushViewController(objCreateGroupVC, animated: true)
        }
        else if index == 3
        {
            let objFaqVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idFaqVC") as! FaqVC
            self.navigationController?.pushViewController(objFaqVC, animated: true)
        }
    }
    
    /*func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String?
    {
        return self.arrSectionData[section] as? String
        /*switch(section)
        {
        case 1:return "Hang Trinh"
            
        default :return ""
            
        }*/
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            return 0.0
        }
        else
        {
            return SectionHeaderHeight
        }
    }*/
    
    /*func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 20))
        view.backgroundColor = UIColor.lightGray //UIColor(red: 253.0/255.0, green: 240.0/255.0, blue: 196.0/255.0, alpha: 1)
        let label = UILabel(frame: CGRect(x: 30, y: 20, width: tableView.bounds.width - 30, height: 30))
        let imgEdit = UIImageView(frame: CGRect(x: tableView.bounds.width - 50, y: 25, width: 20, height: 20))
        imgEdit.image = UIImage(named: "edit")
        label.font = UIFont(name: "TitilliumWeb-SemiBold", size: 20.0)      //UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.text = "Hang Trinh"
        if section == 1
        {
            view.addSubview(imgEdit)
            view.addSubview(label)
        }
        return view
    }*/
    
    /*func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }*/    
    
    func didEditButton_Click(_ tag: Int)
    {
        appd.checkIfUserFirstTimeProfile = "userNotFirstTime"
        if self.strIsFromGroupProfileList == "true"
        {
            if appd.ifFromChatVC == "yes"
            {
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                let objChatVC = Constant.chatStoryboard.instantiateViewController(withIdentifier: "idChatVC") as! ChatVC
                print(participantsDetails as Any)
                objChatVC.objParticipants = participantsDetails
                objChatVC.isClickedContactVC = "true"
                if self.strReceiverKey != "" || self.strReceiverKey != nil
                {
                    objChatVC.strReceiverKey = self.strReceiverKey
                }
                else
                {
                    objChatVC.strReceiverKey = ""
                }
                self.navigationController?.pushViewController(objChatVC, animated: false)
            }
        }
        else
        {
            let objEditProfileVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idEditProfileVC") as! EditProfileVC
            self.navigationController?.pushViewController(objEditProfileVC, animated: false)
        }
    }
}
