//
//  GroupViewProfileVC.swift
//  Mesh App
//
//  Created by Mac admin on 26/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore
import  CoreData

class GroupViewProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, GroupProfileImageCellDelegate, SelectedGroupMediaCellDelegate, GroupEditDelegate, groupActionViewDelegate {

    @IBOutlet weak var tblGroupProfile: UITableView!
    
    var viewGroupAction : GroupParticipantsActionCell!
    var viewGroupActionXib : GroupParticipantsActionView!
    var viewTransparent : UIView!
    var appd = AppDelegate()
    
    var strIsClickedSkipAndInvite : String = ""
    var isClickedEditButton = Bool()
    var coverView = UIView()
    var viewInviteLink = InviteView()
    var strGroupIconUrl : String = ""
    var strGroupUniqueKey : String = ""
    var isExitGroupByAdmin = Bool()
    
    var arrSettingsList = NSArray()
    var arrProfileImgList = NSArray()
    var arrSettingsImgList = NSArray()
    var userDetails : UserDetailsModel?
    var userParticipantsDetail : UserDetailsModel?
    var arrAllParticipantsInfo = NSMutableArray()
    var dictGroupFullInfo = NSDictionary()
    var refDatabase: DatabaseReference!
    var loginUserIsAdmin :  Bool?
    
    var isUserAdmin : Bool?
    
    var arrSectionData = NSArray()
    let arrRowData = [[""],[""],[""],["Industry", "Institute/School"], [""]]
    //let arrRowData = [[""],[""],[""],["Industry", "Institute/School"], ["City", "Country"], [""]]
    override func viewDidLoad() {
        super.viewDidLoad()

        appd = UIApplication.shared.delegate as! AppDelegate
        appd.ifFromChatVC = "no"
//        let objParticipants =   Participants.init(dictionary: (self.arrAllParticipantsInfo[0] as? NSDictionary)!)
//
//        let isAdmin = objParticipants!.isAdmin
//
//        if isAdmin == true
//        {
//            isUserAdmin = true
//        }else
//        {
//            isUserAdmin = false
//
//        }
        
        print(dictGroupFullInfo)
        
        // Do any additional setup after loading the view.
        arrSectionData = ["1", "2", "3", "4", "5"]
        //arrSectionData = ["1", "2", "3", "4", "5", "6"]
       // self.arrAllParticipantsInfo = NSMutableArray(object: dictGroupFullInfo.value(forKey: "participants") as! NSDictionary)
        
//
//        let jsonData = try! JSONSerialization.data(withJSONObject: dictGroupFullInfo.value(forKey: "participants") ??  AnyClass.self, options: JSONSerialization.WritingOptions.prettyPrinted)
//
//        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//
//        let jsonArray = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! NSMutableArray

      //  print(jsonString)
//        print(jsonArray)
//
//
        

        if dictGroupFullInfo.value(forKey: "participants") is NSMutableArray {

              self.arrAllParticipantsInfo = dictGroupFullInfo.value(forKey: "participants") as! NSMutableArray

        }else{

            let abc = dictGroupFullInfo.object(forKey: "participants") as! NSDictionary

            var abc2 = NSArray()
            
            abc2 = abc.allKeys as NSArray
            
            
            var abc3 = NSMutableArray()
            
            
            for indexx in abc2 {
                
                
               // abc3.add(abc.object(forKey: abc[index as! Int]) as! [Any])
                
                
                
                abc3.add(abc[indexx])
                
            }
            
            self.arrAllParticipantsInfo = abc3
          // self.arrAllParticipantsInfo = dictGroupFullInfo.object(forKey: "participants") as! NSMutableArray
            print(abc3)
        }
    
//self.arrAllParticipantsInfo = dictGroupFullInfo.value(forKey: "participants") as! NSMutableArray
      //  self.arrAllParticipantsInfo = (dictGroupFullInfo.value(forKey: "participants"))

        //list = list.filter { $0 != nil }
        
        print("Group Profile: ", self.arrAllParticipantsInfo)
        let arrNew = self.arrAllParticipantsInfo.mutableCopy() as! NSMutableArray
        for i in 0..<arrNew.count
        {
            let dict = arrNew[i] as? NSDictionary
            //print("dict: ", dict!)
            //let keyExists = dict[key]
            if dict == nil
            {
                self.arrAllParticipantsInfo.removeObject(at: i)
            }
        }
        //self.arrAllParticipantsInfo = self.arrAllParticipantsInfo.compactMap{ $0 } as! NSMutableArray
        print("Group Profile: ", self.arrAllParticipantsInfo)
        //print("Group Id: ", self.dictGroupFullInfo.value(forKey: "group_id")!)
        
        arrProfileImgList = [UIImage(named: "account")!, UIImage(named: "notification")!, UIImage(named: "help")!, UIImage(named: "tell_a_friend")!]
        
//        arrSectionData = ["Profile", "", "Media","Enable Notification", "10 Participants", "6"]
//
//        arrRowData = [["1"], ["Morden Marvel's", "Add your small description"], ["1"], ["1"],[["Add Participants", "Invite via link"]], [["Latesh Kumar", "Urgent call only"], ["Ashish Bebni", "1234567890"], ["Diksha", "098765"], ["Mohit", "123456"]], ["Exit Group", ""]]
//        print("arrRowData: ", arrRowData)
        
        self.tblGroupProfile.estimatedRowHeight = 100.0
        self.tblGroupProfile.rowHeight = UITableViewAutomaticDimension
        
        self.tblGroupProfile.tableFooterView = UIView()
        userDetails = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kUserDetails) as? UserDetailsModel
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        /*if self.viewGroupActionXib != nil
        {
            self.viewGroupAction.removeFromSuperview()
            self.viewTransparent.removeFromSuperview()
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createGroupActionView(index: Int, participants: Participants, isAdminnnn: Bool)
    {
       if isAdminnnn == true
       {
           // viewGroupActionXib = GroupParticipantsActionView(frame: CGRect(x: 20, y: 20, width: 300, height: 160))
            viewGroupActionXib = GroupParticipantsActionView(frame: CGRect(x: 20, y: 20, width: 300, height: 100))
        }
        else if isAdminnnn == false
        {
            viewGroupActionXib = GroupParticipantsActionView(frame: CGRect(x: 20, y: 20, width: 300, height: 150))
        }
        //100
        viewGroupActionXib.center = CGPoint(x: self.view.frame.size.width  / 2,
                                        y: self.view.frame.size.height / 2)
        viewGroupActionXib.objParticipants = participants
        let screenRect = UIScreen.main.bounds
        viewTransparent = UIView(frame: screenRect)
        viewTransparent.backgroundColor = UIColor.black.withAlphaComponent(0.86)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleGroupActionTap(_:)))
        tap.delegate = self as? UIGestureRecognizerDelegate // This is not required
        viewTransparent.addGestureRecognizer(tap)
        self.view.addSubview(viewTransparent)
        
        self.view.addSubview(viewGroupActionXib)
        viewGroupActionXib.layer.cornerRadius = 5
        viewGroupActionXib.layer.masksToBounds = true
        viewGroupActionXib.backgroundColor = UIColor.white
        viewGroupActionXib.groupActionDelegate = self
        viewGroupActionXib.dropShadow()
    }
    
    @objc func handleGroupActionTap(_ sender: UITapGestureRecognizer) {
        viewTransparent.removeFromSuperview()
        viewGroupActionXib.removeFromSuperview()
        // handling code
    }
    
    // MARK: - Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0 || section == 1
        {
            return 0.0
        }
        else
        {
            return 20.0 //SectionHeaderHeight
        }
        //return 0.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.arrSectionData.count
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
        if section == 0 || section == 1
        {
            return 0
        }
        else if section == 2
        {
            return 20
        }
        else if section == 3
        {
            return 20
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        if section == 0 || section == 1
        {
            return 0
        }
        else if section == 2
        {
            return 20
        }
        else if section == 3
        {
            return 20
        }
        else
        {
            return 0
        }
    }*/
    
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 1
        }
        else if section == 2 //3
        {
            let strCreatedBy = self.dictGroupFullInfo.value(forKey: "created_By") as! String
            let userId = Auth.auth().currentUser!.uid
            if userId == strCreatedBy
            {
                return 1
            }
            else
            {
                return 1
            }
        }
        else if section == 3 //4
        {
            return self.arrAllParticipantsInfo.count
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
            let cell:GroupProfileImageTableViewCell = self.tblGroupProfile.dequeueReusableCell(withIdentifier: "idGroupProfileImageCell") as! GroupProfileImageTableViewCell
            cell.cellDelegate = self
            cell.tag = indexPath.row
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            let strImage = self.dictGroupFullInfo.value(forKey: "group_icon") as! String
            
            cell.imgGroupProfile.sd_setImage(with: URL(string: strImage), placeholderImage: UIImage(named: "Group 9"))
            
//            let dict = DefaultsValues.getCustomObjFromUserDefaults_(forKey:"profile_image")
//            print("dict: ", dict!)
//            
//            var imgNew = UIImage()
//            let data = Data(base64Encoded: dict!, options: Data.Base64DecodingOptions(rawValue: 0))
    
//            let data = NSData(base64Encoded: dict!, options: NSData.Base64DecodingOptions(rawValue: 0))
//
//            if let decodedData = Data(base64Encoded: dict!, options: .ignoreUnknownCharacters) {
//                let image = UIImage(data: decodedData)
//            }
            
//            userDetails = userInfo.init(dictionary:(DefaultsValues.getUserValueFromUserDefaults_(forKey: kUserInfo))!)
//            print("strImage: ", userDetails!.image!)
//            self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height/2
//            self.imgProfile.layer.masksToBounds = true
//            self.imgProfile.sd_setImage(with: URL(string: userDetails!.image!), placeholderImage: UIImage(named: "icon_profile"))
            
            return cell
        }
        if indexPath.section == 1
        {
            let cell:GroupProfileNameBioTableViewCell = self.tblGroupProfile.dequeueReusableCell(withIdentifier: "idGroupNameBioCell") as! GroupProfileNameBioTableViewCell
            
            
            let objParticipants =   Participants.init(dictionary: (self.arrAllParticipantsInfo[indexPath.row] as? NSDictionary)!)
            
            
            if indexPath.row == 0{
                
                let isAdmin = objParticipants!.isAdmin
                
                if isAdmin == true
                {
                    isUserAdmin = true
                }else
                {
                    isUserAdmin = false
                    
                }
            }
            
            
            cell.lblGroupTitle.text = self.dictGroupFullInfo.value(forKey: "group_name") as? String
            
            cell.lblGroupSubject.text = self.dictGroupFullInfo.value(forKey: "group_description") as? String
            
            cell.cellEditDelegate = self
            cell.tag = indexPath.row
            
            if isUserAdmin == false{
              cell.btnEdit.isHidden = true
            }else{
                cell.btnEdit.isHidden = false

            }
            
            
            return cell
        }
        /*if indexPath.section == 2
         {
         let cell:GroupEnableNotificationTableViewCell = self.tblGroupProfile.dequeueReusableCell(withIdentifier: "idGroupEnableNotificationCell") as! GroupEnableNotificationTableViewCell
         //cell.cellSelectedGroupMediaDelegate = self
         //cell.tag = indexPath.row
         return cell
         }*/
        /*if indexPath.section == 2
        {
            let cell:GroupProfileMediaTableViewCell = self.tblGroupProfile.dequeueReusableCell(withIdentifier: "idGroupMediaCell") as! GroupProfileMediaTableViewCell
            cell.cellSelectedGroupMediaDelegate = self
            cell.tag = indexPath.row
            return cell
        }*/
        if indexPath.section == 2
        {
            let cell:GroupProfileAddUserTableViewCell = self.tblGroupProfile.dequeueReusableCell(withIdentifier: "idGroupAddUserCell") as! GroupProfileAddUserTableViewCell
            
            cell.lblTotalParticipants.text = String(format: "%d Participants ", self.arrAllParticipantsInfo.count)
            
            /*if indexPath.row == 0
            {
                cell.btnSearch.isHidden = false
                cell.lblTotalParticipants.isHidden = false
                cell.imgInviteLink.image = UIImage(named: "participants")
                cell.btnAddParticipants.setTitle("Add Participants", for: UIControlState.normal)
                cell.btnAddParticipants.tag = 201
                cell.btnAddParticipants.addTarget(self, action: #selector(btnAddParticipants_Click), for: .touchUpInside)
            }
            else
            {*/
                cell.btnSearch.isHidden = false
                cell.btnSearch.addTarget(self, action: #selector(btnSearch_Clcik), for: .touchUpInside)
            
            
                cell.lblTotalParticipants.isHidden = false
                cell.imgInviteLink.image = UIImage(named: "link")
                cell.btnAddParticipants.setTitle("Invite via link", for: UIControlState.normal)
                cell.btnAddParticipants.tag = 202
                cell.btnAddParticipants.addTarget(self, action: #selector(btnInvite_Click), for: .touchUpInside)
            //}
            return cell
        }
        if indexPath.section == 3
        {
            let cell:GroupFullProfileTableViewCell = self.tblGroupProfile.dequeueReusableCell(withIdentifier: "idGroupProfileCell") as! GroupFullProfileTableViewCell
            
            let objParticipants =   Participants.init(dictionary: (self.arrAllParticipantsInfo[indexPath.row] as? NSDictionary)!)
            
            if indexPath.row == 0{
            
            let isAdmin = objParticipants!.isAdmin
            
            if isAdmin == true
            {
                isUserAdmin = true
            }else
            {
                isUserAdmin = false
            }
            }
            
            if objParticipants?.isAdmin == true
            {
                cell.btnIsAdmin.isHidden = false
                cell.btnIsAdmin.layer.cornerRadius = 3.0
                cell.btnIsAdmin.layer.borderWidth = 1.0
                cell.btnIsAdmin.layer.borderColor = Constant.MESH_BLUE.cgColor
                cell.btnIsAdmin.layer.masksToBounds = true
            }
            else
            {
                cell.btnIsAdmin.isHidden = true
            }
      
            if UserDefaults.standard.value(forKey: "ifUserName") != nil
            {
                var selfUser = String()
                selfUser = UserDefaults.standard.value(forKey: "ifUserName") as! String
                if selfUser == objParticipants!.participantsName!
                {
                    cell.lblParticipantsName.text = "You"
                }
                else
                {
                    cell.lblParticipantsName.text = objParticipants!.participantsName!
                }
            }
            else
            {
                print("Nil")
            }
            
          //  cell.lblParticipantsName.text = objParticipants!.participantsName!
            cell.lblParticipantsShortBio.text = objParticipants!.participantsShortBio!
            cell.imgParticipantsProfile.sd_setImage(with: URL(string: (objParticipants!.participantsImage!)), placeholderImage: UIImage(named: "account"))
            cell.imgParticipantsProfile.layer.cornerRadius = 4.0
            cell.imgParticipantsProfile.layer.masksToBounds = true
            return cell
        }
        /*if indexPath.section == 5
        {
            let cell:GroupFullProfileTableViewCell = self.tblGroupProfile.dequeueReusableCell(withIdentifier: "idGroupProfileCell") as! GroupFullProfileTableViewCell
            return cell
        }*/
        else
        {
            let cell:GroupProfileExitTableViewCell = self.tblGroupProfile.dequeueReusableCell(withIdentifier: "idGroupExitCell") as! GroupProfileExitTableViewCell
//            let tap = UITapGestureRecognizer(target: self, action: #selector(handleExitTap(_:)))
//            tap.delegate = self as? UIGestureRecognizerDelegate // This is not required
//            tap.view?.backgroundColor = UIColor.red
//            cell.lblExitGroup.addGestureRecognizer(tap)
            
            
            let objParticipants =   Participants.init(dictionary: (self.arrAllParticipantsInfo[indexPath.row] as? NSDictionary)!)
            
            
            if indexPath.row == 0{
                
                let isAdmin = objParticipants!.isAdmin
                
                if isAdmin == true
                {
                    isUserAdmin = true
                }else
                {
                    isUserAdmin = false
                    
                }
            }
            
            if isUserAdmin == false{
                cell.btnExitGroup.isHidden = false
                cell.isHidden = false
            }else{
                cell.btnExitGroup.isHidden = true
                cell.isHidden = true

            }
            
            cell.btnExitGroup.tag = 220
            cell.btnExitGroup.addTarget(self, action: #selector(btnExitGroup_Click), for: .touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //print("indexPath.section: ", indexPath.section)
        if indexPath.section == 3
        {
            let objParticipants =   Participants.init(dictionary: (self.arrAllParticipantsInfo[indexPath.row] as? NSDictionary)!)
            DefaultsValues.setUserValueToUserDefaults((self.arrAllParticipantsInfo[indexPath.row] as? NSDictionary), forKey: "participants")
            print("%@: ", DefaultsValues.getUserValueFromUserDefaults_(forKey: "participants")!)
            //print("%@ ", DefaultsValues.getCustomObjFromUserDefaults_(forKey: "participants") as? Participants!)
            
            var dictParticipantsDetail = NSDictionary()
            let refParticipantsInfo = ChatConstants.refs.databaseUserInfo.child(objParticipants!.participantsId!)
            refParticipantsInfo.observeSingleEvent(of: .value, with: {snapshot in
                for child in snapshot.children
                {
                    let snap = child as! DataSnapshot
                    dictParticipantsDetail = snapshot.value as! NSDictionary
                }
                self.userParticipantsDetail = UserDetailsModel.init(dictionary:dictParticipantsDetail)!
                DefaultsValues.setCustomObjToUserDefaults(dictParticipantsDetail.value(forKey: "institute"), forKey: kParticipantsInstituteList)
            }, withCancel: nil)
            let userId = Auth.auth().currentUser?.uid
            let isAdmin = objParticipants!.isAdmin
            let strCreatedBy = self.dictGroupFullInfo.value(forKey: "created_By") as! String
            /*if strCreatedBy == userId
            {
                //if userId! == objParticipants!.participantsId!
                self.createGroupActionView(index: indexPath.row, participants: objParticipants!, isAdminnnn: true)
            }
            else
            {
                
            }*/
            
            if userId! == objParticipants!.participantsId!
            {
                return
            }
            else
            {
                if isAdmin == false
                {
                    self.createGroupActionView(index: indexPath.row, participants: objParticipants!, isAdminnnn: false)
                }
                else if isAdmin == true
                {
                    self.createGroupActionView(index: indexPath.row, participants: objParticipants!, isAdminnnn: true)
                }
            }
        }
    }
    
    //MARK:- Button Action
    
    @IBAction func btnBack_Click(_ sender: Any)
    {
         self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnAddParticipants_Click(sender: UIButton!)
    {
        //if sender.tag == 201
        //{
            print("Add Participants tapped")
        //}
        
        let objAddParticipantsVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idAddParticipantsVC") as! AddParticipantsVC
        objAddParticipantsVC.dictGroupData = self.dictGroupFullInfo as! NSMutableDictionary
        objAddParticipantsVC.strGroupId = self.dictGroupFullInfo.value(forKey: "group_id")! as! String
        self.navigationController?.present(objAddParticipantsVC, animated: true, completion: nil)
        //self.navigationController?.pushViewController(objCreateGroupVC, animated: true)
    }
   
    //btnSearch_Clcik
    @objc func btnSearch_Clcik(sender: UIButton!)
    {

        print("Button Search tapped")
        //self.createAViewToShareLink()
      
//            if self.arrSearchData.count > 0
//            {
                let objSearchFromChatListVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "GroupAdminSearchVC") as! GroupAdminSearchVC
                objSearchFromChatListVC.arrSearchData = self.arrAllParticipantsInfo
                //self.navigationController?.present(objSearchFromChatListVC, animated: true, completion: nil)
                self.navigationController?.pushViewController(objSearchFromChatListVC, animated: false)
//            }
//            else
//            {
//                SwiftMessageBar.showMessage(withTitle: "No data is available to search", type: .error)
//            }
      // }
    }
    
    @objc func btnInvite_Click(sender: UIButton!)
    {
        print("Button tapped")
        self.createAViewToShareLink()
    }
    
    @objc func btnExitGroup_Click(sender: UIButton!)
    {
        let alertController = UIAlertController(title: kAppName, message: String(format:"Exit \"%@\" ",(self.dictGroupFullInfo.value(forKey: "group_name") as? String)!), preferredStyle: .alert)
        
        let ExitAction = UIAlertAction(title: "Exit", style: .default) { (action:UIAlertAction) in
            self.removeTheParticipants()
        }
        
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(ExitAction)
        alertController.addAction(CancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func removeTheParticipants()
    {
        let strChatId = (self.dictGroupFullInfo.value(forKey: "group_id") as? String)!
        let chatUserId = Auth.auth().currentUser?.uid
        //let refUserPath = ChatConstants.refs.databaseParticularUserInfo//.child(strChatId)
        //kChatKeyList
        let dictUpdatedValues = NSMutableDictionary()
        let dictLeftMsgValues = NSMutableDictionary()
        let arrNewParticipantsList = NSMutableArray()

        //refUserPath.observe(.childAdded, with: {snapshot in
            //print("snapshot: ", snapshot.key)
            
            //if snapshot.key == strChatId
            //{
                //refUserPath.removeValue()
                self.refDatabase = Database.database().reference()
                let refChatInfo = ChatConstants.refs.databaseChatInfo.child(strChatId)
                refChatInfo.observeSingleEvent(of:.childAdded, with: {snapshot in
                    let msgGroupDict = snapshot.value as? NSDictionary
                    let strType = msgGroupDict!.value(forKey: "type") as! String
                    
                    if strType == "1"
                    {
                       // let childrens = msgGroupDict?.value(forKey: "participants") as! NSArray
                        var childrens = NSArray()
                        if msgGroupDict?.value(forKey: "participants") is NSMutableArray
                        {
                            childrens = msgGroupDict?.value(forKey: "participants") as! NSArray
                        }
                        else
                        {
                            let abc = msgGroupDict!.object(forKey: "participants") as! NSDictionary
                            
                            var abc2 = NSArray()
                            
                            abc2 = abc.allKeys as NSArray
                            
                            let abc3 = NSMutableArray()
                            
                            for indexx in abc2
                            {
                                // abc3.add(abc.object(forKey: abc[index as! Int]) as! [Any])
                                abc3.add(abc[indexx])
                            }
                            
                            childrens = abc3
                        }
                        
                        for child in  childrens {
                            let msgParticipantsDict = child as? NSDictionary
                            let strCheckKey = msgParticipantsDict!.value(forKey: "participant_id") as! String
                            //let isAdmin = msgParticipantsDict!.value(forKey: "is_Admin")
                            //if strCheckKey != chatUserId!
                            //{
                                arrNewParticipantsList.add(msgParticipantsDict!)
                                print(snapshot.key)
                            //}
                        }
                    }
                    
                    dictUpdatedValues.setValue(chatUserId, forKey: "created_By")
                    dictUpdatedValues.setValue(self.dictGroupFullInfo.value(forKey: "created_on"), forKey: "created_on")
                    dictUpdatedValues.setValue(self.dictGroupFullInfo.value(forKey: "group_id"), forKey: "group_id") //key
                    dictUpdatedValues.setValue(self.dictGroupFullInfo.value(forKey: "group_name"), forKey: "group_name")
                    dictUpdatedValues.setValue(self.dictGroupFullInfo.value(forKey: "group_icon"), forKey: "group_icon")
                    dictUpdatedValues.setValue(self.dictGroupFullInfo.value(forKey: "group_description"), forKey: "group_description")
                    dictUpdatedValues.setValue(String(arrNewParticipantsList.count), forKey: "participant_count")
                    dictUpdatedValues.setValue(ServerValue.timestamp() as! [String: AnyObject], forKey: "modified_on")
                    dictUpdatedValues.setValue(arrNewParticipantsList, forKey: "participants")
                    dictUpdatedValues.setValue("1", forKey: "type")
                        
                    let childUpdates = ["\(String(describing: self.strGroupUniqueKey))/groupInfo/": dictUpdatedValues] //key
                    refChatInfo.updateChildValues(childUpdates)
                    
                    let keyAutoId = self.refDatabase.childByAutoId().key //self.refDatabase.childByAutoId().key
                    
                    dictLeftMsgValues.setValue("false", forKey: "is_reply")
                    dictLeftMsgValues.setValue(keyAutoId, forKey: "message_id")
                    dictLeftMsgValues.setValue(ServerValue.timestamp() as! [String: AnyObject], forKey: "message_time")
                    
                    dictLeftMsgValues.setValue("You left", forKey: "text_msg")
                    
                    dictLeftMsgValues.setValue(self.userDetails!.userId!, forKey: "sender_id")
                    dictLeftMsgValues.setValue(self.userDetails!.userImage!, forKey: "sender_image")
                    dictLeftMsgValues.setValue(self.userDetails!.userName!, forKey: "sender_name")
                    dictLeftMsgValues.setValue(self.userDetails!.cityName!, forKey: "sender_location")
                    dictLeftMsgValues.setValue(self.userDetails!.fcmPushToken!, forKey: "sender_fcm_push_token")
                    dictLeftMsgValues.setValue(self.userDetails!.companyName!, forKey: "sender_company")
                    dictLeftMsgValues.setValue(self.userDetails!.designation!, forKey: "sender_designation")
                    
                    let refChildMessagePath = ChatConstants.refs.databaseMessagesInfo
                    
                    let childUpdateMsgValues = ["\(String(describing: self.strGroupUniqueKey))/\(String(describing: keyAutoId!))": dictLeftMsgValues]
                    refChildMessagePath.updateChildValues(childUpdateMsgValues)
                }, withCancel: nil)
        
//        self.arrAllParticipantsInfo = dictGroupFullInfo.value(forKey: "participants") as! NSMutableArray
//        print(arrAllParticipantsInfo)
//
//        tblGroupProfile .reloadData()
    }
    
    func createAViewToShareLink()
    {
        let loadXibView = Bundle.main.loadNibNamed("InviteView", owner: self, options: nil)
        
        //If you only have one view in the xib and you set it's class to MyView class
        viewInviteLink = loadXibView!.first as! InviteView
        
        //Set wanted position and size (frame)
        //myView.frame = self.view.bounds
        //        myView.frame = CGRect(x:  (self.view.frame.size.width / 2), y: (self.view.frame.size.height / 2), width: self.view.frame.size.width - 20, height: 270)
        
        viewInviteLink.center = CGPoint(x: self.view.frame.size.width  / 2,
                                        y: self.view.frame.size.height / 2)
        //myView.backgroundColor = UIColor.red
        viewInviteLink.btnShareLink.layer.cornerRadius = 4.0
        viewInviteLink.layer.cornerRadius = 4.0
        viewInviteLink.lblGroupName.text = self.dictGroupFullInfo.value(forKey: "group_name") as? String
        self.strGroupUniqueKey = (self.dictGroupFullInfo.value(forKey: "group_id") as? String)!
        viewInviteLink.lblGroupInviteLink.text = String(format: "Invite Link: https://mesh.page.link/GroupInvites?group_id=%@", self.strGroupUniqueKey)
        self.strGroupIconUrl = (self.dictGroupFullInfo.value(forKey: "group_icon") as? String)!
        viewInviteLink.imgGroupIcon.sd_setImage(with: URL(string: strGroupIconUrl), placeholderImage: UIImage(named: "gallery1"))
        viewInviteLink.btnShareLink.addTarget(self, action: #selector(btnShareLink_Click(sender:)), for: .touchUpInside)
        
        let screenRect = UIScreen.main.bounds
        coverView = UIView(frame: screenRect)
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.86)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.delegate = self as? UIGestureRecognizerDelegate // This is not required
        coverView.addGestureRecognizer(tap)
        self.view.addSubview(coverView)
        
        self.view.addSubview(viewInviteLink)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        coverView.removeFromSuperview()
        viewInviteLink.removeFromSuperview()
        // handling code
    }
    
    @objc func btnShareLink_Click(sender: UIButton)
    {
        let text1 = String(format: "Follow this link to join my networking group on Mesh App:- \n")
        
        let strInviteUrl = String(format: "https://mesh.page.link/GroupInvites?group_id=%@", self.strGroupUniqueKey)
    
        //let strInviteUrl = String(format: "http://chat.meshapp.com/%@", self.strGroupUniqueKey)
        let myWebsite = URL(string: strInviteUrl )
        let shareAll = [text1, myWebsite!] as [Any]
        //let shareAll = [myWebsite!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        coverView.removeFromSuperview()
        viewInviteLink.removeFromSuperview()
    }
    
    //MARK:- Custom Delegate Methods
    
    func didPressButton(_ tag: Int)
    {
        print("I have pressed a button with a tag: \(tag)")
        let objImportContactVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idImportContactVC") as! ImportContactVC
        self.navigationController?.pushViewController(objImportContactVC, animated: true)
    }
    
    func didSelectGroupMedia_Click(_ tag: Int, _strImage: String)
    {
        print("I have pressed a button with a tag: \(tag)")
        let objSelectedImageVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idSelectedImageVC") as! SelectedImageVC
        objSelectedImageVC.strSelectedImage = _strImage
        self.navigationController?.pushViewController(objSelectedImageVC, animated: true)
    }
    
    func didPressMediaButton(_ tag: Int)
    {
        let objMediaVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idMediaVC") as! MediaVC
        self.navigationController?.pushViewController(objMediaVC, animated: true)
    }
    
     func didPressEditButton(_ tag: Int)
     {
        let objAddGroupSubjectVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idAddGroupSubjectVC") as! AddGroupSubjectVC
        objAddGroupSubjectVC.isClickedEditGroupProfile = true
        objAddGroupSubjectVC.dictGroupInfo = self.dictGroupFullInfo
        self.navigationController?.pushViewController(objAddGroupSubjectVC, animated: true)
     }
    
    func navigateToGroupActionController(index: Int)
    {
        if self.viewGroupActionXib != nil
        {
            self.viewGroupActionXib.removeFromSuperview()
            self.viewTransparent.removeFromSuperview()
        }
        if index == 0
        {
            let objViewProfileVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idViewProfileVC") as! ViewProfileVC
            objViewProfileVC.strIsFromGroupProfileList = "true"
            objViewProfileVC.isClickedChatInfoButtonVC = "false"
            objViewProfileVC.dictGroupInfo = self.dictGroupFullInfo
            objViewProfileVC.userDetails =  self.userParticipantsDetail
            objViewProfileVC.participantsDetails = viewGroupActionXib.objParticipants
            let objCoreParticipants = SaveAndFetchCoreData.getParticipantsUniqueKey(objViewProfileVC.participantsDetails!.participantsId!)
            if objCoreParticipants ==  nil
            {
                objViewProfileVC.strReceiverKey = ""
            }
            else
            {
                objViewProfileVC.strReceiverKey = (objCoreParticipants?.chatUniqueKey)!
            }
            appd.ifFromChatVC = "no"
            self.navigationController?.pushViewController(objViewProfileVC, animated: true)
        }
        else if index == 1
        {         
            let objChatVC = Constant.chatStoryboard.instantiateViewController(withIdentifier: "idChatVC") as! ChatVC
            objChatVC.isClickedContactVC = "true"
            objChatVC.objParticipants = viewGroupActionXib.objParticipants
            let objCoreParticipants = SaveAndFetchCoreData.getParticipantsUniqueKey(objChatVC.objParticipants!.participantsId!)
            print(objCoreParticipants as Any)
      
            if objCoreParticipants ==  nil
            {
                objChatVC.strReceiverKey = ""
            }
            else
            {
                objChatVC.strReceiverKey = (objCoreParticipants?.chatUniqueKey)!
            }
            
            self.navigationController?.pushViewController(objChatVC, animated: false)
        }
        else if index == 2
        {
            //let strTitle = String(format: "Remove %@ from %@ group", )
            let alertController = UIAlertController(title: kAppName, message: String(format:"Removed from \"%@\" group",(self.dictGroupFullInfo.value(forKey: "group_name") as? String)!), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                self.removeTheParticipants()
            }
            
            let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(okAction)
            alertController.addAction(CancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
   
    
    //MARK:- Notification Center

    /*@objc func onPushViewController(_ notification:Notification)
    {
        // Do something now
        
        
        let storyboard : UIStoryboard = UIStoryboard.init(name: "Home", bundle: nil);
        let viewController : PlaceListViewController = storyboard.instantiateViewController(withIdentifier: "PlaceListViewController") as! PlaceListViewController;
        viewController.CategoryName = DefaultsValues.getStringValueFromUserDefaults_(forKey: "kItemString");
        self.navigationController?.pushViewController(viewController, animated: true);
        
        print("Moved To PlaceListViewController");
    }*/    
}
