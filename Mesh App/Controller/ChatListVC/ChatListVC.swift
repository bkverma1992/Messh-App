//
//  ChatListVC.swift
//  Mesh App
//
//  Created by Mac admin on 24/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit
import Contacts
import CoreTelephony
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import JGProgressHUD
import CoreData
import SwiftMessageBar

class ChatListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, menuViewDelegate
{
    var refDatabase: DatabaseReference!
    var userLoginDetails : UserDetailsModel?
    var appd = AppDelegate()
    
    //var arrUsersList = NSMutableArray()
    var arrUsersList = NSArray()  //[AllChatMessagesListEntity]()
    var arrSingleUserFullChat = NSMutableArray()
    var strLoginUserName : String = ""
    var arrParticipantsList = NSMutableArray()
    var arrPartList = NSMutableArray()
    var arrGroupList = NSArray()
    var arrLatestGroupList = NSMutableArray()
    var arrChatKeyList =  NSMutableArray()
    var strNewGroupCreated :  String = ""
    var index12 : Int = 0
    //var arrCoreDataChatList = NSArray()
    
    
    
    var viewMenuXib : MenuView!
    @IBOutlet weak var btnMenu: UIButton!
    var viewTransparent : UIView!
    
    var coverView = UIView()
    var viewInviteLink = ViewInviteViaLink()
    var dictNewGroupData = NSMutableDictionary()
    
    @IBOutlet weak var btnContact: UIButton!
    var arrSearchData = NSMutableArray()
    var arrCoreDataSearchList = NSArray()
    
    var objAllChatUserList = [AllChatUserListEntity]()
    
    var dictData =  NSMutableDictionary()
    var dictPartData =  NSMutableDictionary()
    
    var contactStore = CNContactStore()
    var contactsArray = NSMutableArray()

    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var viewRelevant: UIView!
    @IBOutlet weak var viewBuzz: UIView!
    
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnRelevant: UIButton!
    @IBOutlet weak var btnBuzz: UIButton!
    @IBOutlet weak var lblNetworkGroup: UILabel!
    @IBOutlet weak var tblChatList: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        appd = UIApplication.shared.delegate as! AppDelegate

        appd.checkIfUserFirstTimeProfile = "userNotFirstTime"
        
//                        self.resetAllRecords(in: ChatConstants.entityName.entityAllChatInfoListEntity)
//                        self.resetAllRecords(in: ChatConstants.entityName.entityAllChatMessagesList)
//                        self.resetAllRecords(in: ChatConstants.entityName.entityParticipantsListEntity)

        if self.arrUsersList.count == 0
        {
            self.tblChatList.isHidden = true
            self.lblNetworkGroup.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    func resetAllRecords(in entity : String) // entity = Your_Entity_Name
    {
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print ("There was an error")
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
    
    //Mark :- Menu Action
    
    func navigateToController(index: Int)
    {
        if index == 0
        {
            let objChatListVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idChatListVC") as! ChatListVC
            self.navigationController?.pushViewController(objChatListVC, animated: false)
        }
        else if index == 1
        {
            let objViewProfileVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idViewProfileVC") as! ViewProfileVC
            self.navigationController?.pushViewController(objViewProfileVC, animated: true)
        }
        else if index == 2
        {
//            let objCreateGroupVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idCreateGroupVC") as! CreateGroupVC
//            self.navigationController?.pushViewController(objCreateGroupVC, animated: true)
            let objAddGroupSubjectVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idAddGroupSubjectVC") as! AddGroupSubjectVC
            //
            
            
           // objAddGroupSubjectVC.arrParticipantsData = self.arrSelectedData.mutableCopy() as! NSMutableArray
            //
            
            self.navigationController?.pushViewController(objAddGroupSubjectVC, animated: true)
        }
        else if index == 3
        {
            let objTermsAndPoliciesVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idTermsAndPoliciesVC") as! TermsAndPoliciesVC
            self.navigationController?.pushViewController(objTermsAndPoliciesVC, animated: true)
        }
    }
    
    @IBAction func btnMenu_Click(_ sender: Any)
    {
        
        viewMenuXib = MenuView(frame: CGRect(x: self.btnContact.frame.origin.x - 80, y: self.btnMenu.frame.origin.y + 10, width: 150, height: 200))
        viewTransparent = UIView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height))
        viewTransparent.backgroundColor = UIColor.black
        viewTransparent.alpha = 0.6
        //self.view.addSubview(viewTransparent)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.delegate = self as? UIGestureRecognizerDelegate // This is not required
        viewTransparent.addGestureRecognizer(tap)
        self.view.addSubview(viewTransparent)
        
        self.view.addSubview(viewMenuXib)
        viewMenuXib.layer.cornerRadius = 5
        viewMenuXib.layer.masksToBounds = true
        viewMenuXib.backgroundColor = UIColor.white
        viewMenuXib.menuDelegate = self
        viewMenuXib.dropShadow()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        viewTransparent.removeFromSuperview()
        viewMenuXib.removeFromSuperview()
        // handling code
    }
    
    func createAViewToShareLink()
    {
        let loadXibView = Bundle.main.loadNibNamed("ViewInviteViaLink", owner: self, options: nil)
        
        //If you only have one view in the xib and you set it's class to MyView class
        viewInviteLink = loadXibView!.first as! ViewInviteViaLink
        
        //Set wanted position and size (frame)
        //myView.frame = self.view.bounds
        //        myView.frame = CGRect(x:  (self.view.frame.size.width / 2), y: (self.view.frame.size.height / 2), width: self.view.frame.size.width - 20, height: 270)
        
        viewInviteLink.center = CGPoint(x: self.view.frame.size.width  / 2,
                                        y: self.view.frame.size.height / 2)
        //myView.backgroundColor = UIColor.red
        viewInviteLink.btnShareLink.layer.cornerRadius = 4.0
        viewInviteLink.layer.cornerRadius = 4.0
        viewInviteLink.lblGroupName.text = self.dictNewGroupData.value(forKey: "group_name") as? String
        let strGroupId = self.dictNewGroupData.value(forKey: "group_id") as! String
        viewInviteLink.lblGroupInviteLink.text = String(format: "Invite Link: https://mesh.page.link/GroupInvites?group_id=%@", strGroupId)
        viewInviteLink.imgGroupIcon.layer.cornerRadius = 4.0
        viewInviteLink.imgGroupIcon.layer.masksToBounds = true
        viewInviteLink.imgGroupIcon.sd_setImage(with: URL(string: self.dictNewGroupData.value(forKey: "group_icon") as! String), placeholderImage: UIImage(named: "gallery1"))
        viewInviteLink.btnShareLink.addTarget(self, action: #selector(btnShareLink_Click(sender:)), for: .touchUpInside)
        
        let screenRect = UIScreen.main.bounds
        coverView = UIView(frame: screenRect)
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.86)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleShareTap(_:)))
        tap.delegate = self as? UIGestureRecognizerDelegate // This is not required
        coverView.addGestureRecognizer(tap)
        self.view.addSubview(coverView)
        
        self.view.addSubview(viewInviteLink)
    }
    
    @objc func handleShareTap(_ sender: UITapGestureRecognizer) {
      //  coverView.removeFromSuperview()
        coverView .isHidden = true
        viewInviteLink.removeFromSuperview()
    }
    
    @objc func btnShareLink_Click(sender: UIButton)
    {
        let text1 = String(format: "Follow this link to join my networking group on Mesh App \n")
        let strGroupId = self.dictNewGroupData.value(forKey: "group_id") as! String
        let strInviteUrl = String(format: "https://mesh.page.link/GroupInvites?group_id=%@", strGroupId)
        let myWebsite = URL(string: strInviteUrl )
        let shareAll = [text1, myWebsite!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        coverView.removeFromSuperview()
        viewInviteLink.removeFromSuperview()
    }
    
    func getLocalDBData()
    {
        
        let arrCoreDataChatList = SaveAndFetchCoreData.getChatInfoList()
        self.arrGroupList = arrCoreDataChatList//.mutableCopy() as! NSMutableArray
        self.arrGroupList = self.arrGroupList.descendingArrayWithKeyValue(key: "messageTime") as NSArray //modified_on
        print("self.arrGroupList: ", self.arrGroupList.count)
        
        let arrCoreDataParticipants = SaveAndFetchCoreData.getParticipantsData()
        self.arrParticipantsList = arrCoreDataParticipants.mutableCopy() as! NSMutableArray
        
        for i in 0..<self.arrParticipantsList.count
        {
            let objParticipants = self.arrParticipantsList[i] as! ParticipantsListEntity
            let strKeyId = objParticipants.chatUniqueKey
            self.dictData.setValue(objParticipants, forKey: strKeyId!)
        }
        let arrCoreDataMessageList = SaveAndFetchCoreData.getAllChatMessagesData()
        self.arrUsersList = arrCoreDataMessageList//.mutableCopy() as! NSMutableArray
        self.arrUsersList = self.arrUsersList.descendingArrayWithKeyValue(key: "messageTime") as NSArray
        print("self.arrUsersList: ", self.arrUsersList.count)
        
        if self.arrGroupList.count > 0
        {
            self.lblNetworkGroup.isHidden = true
            self.tblChatList.estimatedRowHeight = 180.0
            self.tblChatList.rowHeight = UITableViewAutomaticDimension
            self.tblChatList.tableFooterView = UIView()
            self.tblChatList.isHidden = false
            self.tblChatList.reloadData()
        }
        else
        {
            self.lblNetworkGroup.isHidden = false
            self.tblChatList.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if (viewMenuXib != nil)
        {
            viewTransparent.removeFromSuperview()
            viewMenuXib.removeFromSuperview()
        }
        
        self.viewAll.isHidden = false
        self.viewRelevant.isHidden = true
        self.viewBuzz.isHidden = true
        
        self.btnAll.setTitleColor(Constant.MESH_BLUE, for: .normal)
        self.btnRelevant.setTitleColor(Constant.BUTTON_COLOR, for: .normal)
        self.btnBuzz.setTitleColor(Constant.BUTTON_COLOR, for: .normal)
        
        self.getLocalDBData()
        
        if self.strNewGroupCreated == "true"
        {
            self.strNewGroupCreated = "false"
            self.createAViewToShareLink()
        }
        
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        //let deadlineTime = DispatchTime.now() + .seconds(2)
       // DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            connectedRef.observe(.value, with: { snapshot in
                if snapshot.value as? Bool ?? false {
                    print("value: ", snapshot.value!)

                        self.chatListInfo()
                        /*DispatchQueue.global(qos: .background).async {
                            print("This is run on the background queue")                            
                            
                            
                            DispatchQueue.main.async {
                                
                                print("This is run on the main queue, after the previous code in outer block")
                            }
                        }*/
                }
            })
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Chat List Info Firebase Method
    
    func chatListInfo()
    {
        let chatUserId = Auth.auth().currentUser?.uid
        //let string = DefaultsValues.getStringValueFromUserDefaults_(forKey: kReceiverChatKey)
        //var strMsgKey = String()
      //  self.arrUsersList = NSArray.init()
        self.arrChatKeyList = NSMutableArray.init()
     //   self.arrGroupList = NSArray.init()
        self.arrParticipantsList = NSMutableArray.init()
        self.arrLatestGroupList = NSMutableArray.init()
        
        let arrGroupData = NSMutableArray()
        let arrPart = NSMutableArray()
        let arrMessages = NSMutableArray()
        arrSearchData = NSMutableArray()
        let refUserPath = ChatConstants.refs.databaseParticularUserInfo
        
        refUserPath.observe(.childAdded, with: {snapshot in
//                self.resetAllRecords(in: ChatConstants.entityName.entityAllChatInfoListEntity)
//                self.resetAllRecords(in: ChatConstants.entityName.entityAllChatMessagesList)
//                self.resetAllRecords(in: ChatConstants.entityName.entityParticipantsListEntity)
            
            self.arrChatKeyList.add(snapshot.key)
            DefaultsValues.setCustomObjToUserDefaults(self.arrChatKeyList, forKey: kChatKeyList)
            //}
            let strUniqueKey = snapshot.key
            //ALL MESSAGES INFORMATION
            let refMsgInfo = ChatConstants.refs.databaseMessagesInfo.child(strUniqueKey).queryLimited(toLast: 1)
            refMsgInfo.observe(.childAdded, with: {snapshot in
                let msgLastInfoDict = snapshot.value as? NSDictionary
                
                arrMessages.add(msgLastInfoDict!)
                SaveAndFetchCoreData.saveAllMessages(strUniqueKey: strUniqueKey, arrAllMessagesList: arrMessages )
                //SaveAndFetchCoreData.saveAllMessages(strUniqueKey: strUniqueKey, dictAllMessages: msgLastInfoDict! )
                let arrCoreDataMessageList = SaveAndFetchCoreData.getAllChatMessagesData()
                self.arrUsersList = arrCoreDataMessageList //.mutableCopy() as! NSMutableArray
                self.arrUsersList = self.arrUsersList.descendingArrayWithKeyValue(key: "messageTime") as NSArray
                print("self.arrUsersList: ", self.arrUsersList.count)
                
                //ALL GROUP AND PARTICIAPNTS INFORMATION
                let refChatInfo = ChatConstants.refs.databaseChatInfo.child(strUniqueKey)
                //print("strUniqueKey: ", strUniqueKey)
                refChatInfo.observe(.childAdded, with: {snapshot in
                    let msgGroupDict = snapshot.value as? NSMutableDictionary
                    let strType = msgGroupDict!.value(forKey: "type") as! String
                    let strGroupId = msgGroupDict!.value(forKey: "group_id") as! String
                    msgGroupDict!.setValue(msgLastInfoDict?.value(forKey: "message_time"), forKey: "message_time")
                    msgGroupDict!.setValue(msgLastInfoDict?.value(forKey: "text_msg"), forKey: "text_msg")
                    
                    arrGroupData.add(msgGroupDict!)
                    self.arrLatestGroupList.add(msgGroupDict!)
                    
                    //SaveAndFetchCoreData.saveChatInfo(strGroupId: strGroupId, dictGroupData: msgGroupDict!)
                    SaveAndFetchCoreData.saveChatInfo(strGroupId: strGroupId, arrGroupData: arrGroupData)
                    var arrCoreDataChatList = NSArray.init()
                    arrCoreDataChatList = SaveAndFetchCoreData.getChatInfoList()
                    self.arrGroupList = arrCoreDataChatList//.mutableCopy() as! NSMutableArray
                    self.arrGroupList = self.arrGroupList.descendingArrayWithKeyValue(key: "messageTime") as NSArray //modified_on
                    print("self.arrGroupList: ", self.arrGroupList.count)
                    
                    let filteredLatestGroupList = NSArray.init(array: self.arrLatestGroupList)
                    let filArray = filteredLatestGroupList.descendingArrayWithKeyValue(key: "message_time") as NSArray //modified_on
                    //print("filArray.count: ", filArray.count)
                    self.arrLatestGroupList = filArray.mutableCopy() as! NSMutableArray
                 //    self.arrGroupList = filArray
                    // Participants Information
                    if strType == "0"
                    {
                        let childrens = msgGroupDict?.value(forKey: "participants") as! NSArray
                        for child in  childrens {
                            let msgParticipantsDict = child as? NSDictionary
                            let strCheckKey = msgParticipantsDict!.value(forKey: "participant_id") as! String
                            if strCheckKey != chatUserId
                            {
                                arrPart.add(msgParticipantsDict!)
                                self.arrPartList.add(msgParticipantsDict!)
                                self.dictPartData.setValue(msgParticipantsDict!, forKey: strGroupId)
                                //self.arrParticipantsList.add(msgParticipantsDict!)
                                //self.dictData.setValue(msgParticipantsDict, forKey: strGroupId)
                                SaveAndFetchCoreData.saveParticipantsInfo(strGroupId: strGroupId, arrParticipantsInfo: arrPart)
                                let arrCoreDataParticipantsList = SaveAndFetchCoreData.getParticipantsData()
                                self.arrParticipantsList = arrCoreDataParticipantsList.mutableCopy() as! NSMutableArray
                            }
                        }
                    }
                    for i in 0..<self.arrParticipantsList.count
                    {
                        //let objParticipants = ParticipantsListEntity.init(context: self.arrParticipantsList[i] as! NSManagedObjectContext)
                        let objParticipants = self.arrParticipantsList[i] as! ParticipantsListEntity
                        let strKeyId = objParticipants.chatUniqueKey
                        print(strKeyId as Any)
                        self.dictData.setValue(objParticipants, forKey: strKeyId!)
                    }
                    self.index12 = 0
                    self.tblChatList.estimatedRowHeight = 180.0
                    self.tblChatList.rowHeight = UITableViewAutomaticDimension
                    self.tblChatList.tableFooterView = UIView()
                    self.tblChatList.isHidden = false
                    self.lblNetworkGroup.isHidden = true
                    
                    self.tblChatList.reloadData()
                }, withCancel: nil)
            }, withCancel: nil)
            
                //let arrNewSearchData = NSMutableArray()
                let refAllMsgInfo = ChatConstants.refs.databaseMessagesInfo.child(strUniqueKey)
                refAllMsgInfo.observe(.childAdded, with: {snapshot in
                    //for child in snapshot.children {
                       // let snap = child as! DataSnapshot
                        let msgLastInfoDict = snapshot.value as? NSMutableDictionary
                        msgLastInfoDict! .setValue(strUniqueKey, forKey: "group_id")
                        self.arrSearchData.add(msgLastInfoDict!)
                        //arrNewSearchData.add(msgLastInfoDict!)
                    let deadlineTime = DispatchTime.now() + .seconds(2)
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                        //SaveAndFetchCoreData.saveAllChatUserList(arrChatList: self.arrLatestGroupList, arrChatKeyInfo: self.arrChatKeyList, arrLastMessages: arrNewSearchData, dictParticipantsData: self.dictPartCoreData)
                        //self.arrSearchData = SaveAndFetchCoreData.getChatListData() as! NSMutableArray
                        //print("arrSearchData: ", self.arrSearchData)
                    })
                }, withCancel: nil)
        }, withCancel: nil)
    }
    
    //MARK: - Display Phone Contacts
    
    func displayAlContacts()
    {
        var contacts = [CNContact]()
        //        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
        //        let request = CNContactFetchRequest(keysToFetch: keys)
        
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        do {
            try self.contactStore.enumerateContacts(with: request) {
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
                
                let infoDict = NSMutableDictionary()
                
                let phoneNumber = contact.phoneNumbers.first?.value.stringValue
                
                let components =
                    phoneNumber!.components(separatedBy: CharacterSet.decimalDigits.inverted)
                let phone = components.joined()
                print("phone: ", phone)
                
                
                /*let charsetDash = CharacterSet(charactersIn: "-")
                let charsetWhiteSpace = CharacterSet(charactersIn: " ")
                if contact.phoneNumbers.first?.value.stringValue.rangeOfCharacter(from: charsetDash) != nil
                {
                    let strFormatContactNo = contact.phoneNumbers.first?.value.stringValue.replacingOccurrences(of: "-", with: "")
                    infoDict.setValue(strFormatContactNo, forKey: "Number")
                }
                else if contact.phoneNumbers.first?.value.stringValue.rangeOfCharacter(from: charsetWhiteSpace) != nil
                {
                    let strFormatContactNo = contact.phoneNumbers.first?.value.stringValue.replacingOccurrences(of: " ", with: "")
                    infoDict.setValue(strFormatContactNo, forKey: "Number")
                }
                else
                {
                    infoDict.setValue(contact.phoneNumbers.first?.value.stringValue, forKey: "Number")
                }*/
                
                infoDict.setValue(String(format: "%@", phone), forKey: "Number")
                infoDict.setValue(contact.givenName, forKey: "Name")
                infoDict.setValue("No", forKey: "isExist")
                
                let valueeee = infoDict.value(forKey: "Number")
                if (valueeee != nil)
                {
                    self.contactsArray.add(infoDict)
                }
            }
        }
        catch
        {
            print("unable to fetch contacts")
        }
        print(self.contactsArray)
        if self.contactsArray.count != 0
        {
            let defaults = UserDefaults.standard
            defaults.set(self.contactsArray, forKey: "phone_contacts")
            defaults.synchronize()
        }
    }
    
    //MARK: Button Action
    
    @IBAction func btnSearch_Click(_ sender: Any)
    {
        if self.arrSearchData.count > 0
        {
            let objSearchFromChatListVC = Constant.chatStoryboard.instantiateViewController(withIdentifier: "idSearchFromChatListVC") as! SearchFromChatListVC
            objSearchFromChatListVC.arrSearchData = self.arrSearchData
            //self.navigationController?.present(objSearchFromChatListVC, animated: true, completion: nil)
            self.navigationController?.pushViewController(objSearchFromChatListVC, animated: false)
        }
        else
        {
             SwiftMessageBar.showMessage(withTitle: "No data is available to search", type: .error)
        }
    }
    
    @IBAction func btnAll_Click(_ sender: Any)
    {
        self.tblChatList.isHidden = false
        self.lblNetworkGroup.isHidden = true
        self.viewAll.isHidden = false
        self.viewRelevant.isHidden = true
        self.viewBuzz.isHidden = true

        self.btnAll.setTitleColor(UIColor.black, for: .selected)
        self.btnRelevant.setTitleColor(Constant.BUTTON_COLOR, for: .normal)
        self.btnBuzz.setTitleColor(Constant.BUTTON_COLOR, for: .normal)
    }
    
    @IBAction func btnRelevant_Click(_ sender: Any) {
        self.tblChatList.isHidden = true
        //self.lblNetworkGroup.isHidden = false
        //self.lblNetworkGroup.text = "Coming Soon"
        self.viewAll.isHidden = true
        self.viewRelevant.isHidden = false
        self.viewBuzz.isHidden = true
        
        self.btnRelevant.setTitleColor(UIColor.black, for: .selected)
        self.btnAll.setTitleColor(Constant.BUTTON_COLOR, for: .normal)
        self.btnBuzz.setTitleColor(Constant.BUTTON_COLOR, for: .normal)
        
        let objSearchRelevantVC = Constant.chatStoryboard.instantiateViewController(withIdentifier: "idSearchRelevantVC") as! SearchRelevantVC
        objSearchRelevantVC.arrSearchData = self.arrSearchData
        self.navigationController?.pushViewController(objSearchRelevantVC, animated: false)
    }
    
    @IBAction func btnBuzz_Click(_ sender: Any)
    {
        self.tblChatList.isHidden = true
        self.lblNetworkGroup.isHidden = true
        //self.lblNetworkGroup.text = "Coming Soon"
        self.viewAll.isHidden = true
        self.viewRelevant.isHidden = true
        self.viewBuzz.isHidden = true
        
        self.btnBuzz.setTitleColor(UIColor.black, for: .selected)
        self.btnRelevant.setTitleColor(Constant.BUTTON_COLOR, for: .normal)
        self.btnAll.setTitleColor(Constant.BUTTON_COLOR, for: .normal)
        
        let objBuzzPostsVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idBuzzPostsVC") as! BuzzPostsVC
        objBuzzPostsVC.arrSearchData = self.arrSearchData
        self.navigationController?.pushViewController(objBuzzPostsVC, animated: false)
    }
    
    @IBAction func btnAdd_Click(_ sender: Any)
    {
        DefaultsValues.setStringValueToUserDefaults("YES", forKey: "plus_clicked")
        //let importContacts = DefaultsValues.getStringValueFromUserDefaults_(forKey: kImportContactFirstTime)
        /*if self.arrGroupList.count > 0
        {
            let objImportContactVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idImportContactVC") as! ImportContactVC
            self.navigationController?.pushViewController(objImportContactVC, animated: true)
        }
        else
        {*/
            
            let objAddGroupSubjectVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idAddGroupSubjectVC") as! AddGroupSubjectVC
            self.navigationController?.pushViewController(objAddGroupSubjectVC, animated: true)
        //}
    }
    
    @IBAction func btnContactList_Click(_ sender: Any)
    {
        let importContacts = DefaultsValues.getStringValueFromUserDefaults_(forKey: kImportContactFirstTime)
        if importContacts == "true"
        {
            let objImportContactVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idImportContactVC") as! ImportContactVC
            self.navigationController?.pushViewController(objImportContactVC, animated: true)
        }
        else
        {
//            let objImportContactVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idImportContactVC") as! ImportContactVC
//            self.navigationController?.pushViewController(objImportContactVC, animated: true)
            
            let objContactListVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idContactListVC") as! ContactListVC
            self.navigationController?.pushViewController(objContactListVC, animated: true)
        }
    }
    func indexPathsForRowsInSection(_ section: Int, numberOfRows: Int) -> [NSIndexPath] {
        return (0..<numberOfRows).map{NSIndexPath(row: $0, section: section)}
    }
    
    func getIndexPathFor(view: UIView, tableView: UITableView) -> IndexPath? {
        
        let point = tableView.convert(view.bounds.origin, from: view)
        let indexPath = tableView.indexPathForRow(at: point)
        return indexPath
    }
    
    // MARK: - Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //let indexpath = self.getIndexPathFor(view: self.view, tableView: self.tblChatList)
        //let rows: Int = tableView.numberOfRows(inSection: section)
        //let strType = ((self.arrGroupList[(indexpath?.row)!] as AnyObject).value(forKey: "type")) as! String
        //let filteredArray = arrGroupList.filter() { $0["type"] == "0" }
        //let filteredArray = arrGroupList.filter { $0["type"] == "0" }
    
        //let newArray = arrGroupList.filter { $0.keys.contains("type") }.flatMap { $0 }
        
        //let results = arrGroupList.filter { $0.type == 0 }
        //if self.arrCoreDataChatList.count > 0
        //{
            //return self.arrCoreDataChatList.count
        //}
        //else
        //{
        
            return self.arrGroupList.count
        //}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellReuseIdentifier = "idChatListCell"
        let cell:ChatListTableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ChatListTableViewCell?)!
        cell.selectionStyle = .none
        
        let strType = ((self.arrGroupList[indexPath.row] as AnyObject).value(forKey: "type")) as! String
        let strCellGroupId = ((self.arrGroupList[indexPath.row] as AnyObject).value(forKey: "group_id")) as! String
            
        if strType == "0"
        {
            //let objParticipants =   Participants.init(dictionary: self.dictData.value(forKey: strCellGroupId) as! NSDictionary)!
            let arrNewData = NSMutableArray.init()
            arrNewData.add(self.dictData.value(forKey: strCellGroupId) as Any)
          
            //bk
            if arrNewData[0] is NSNull
            {
                print("Nulll")
            }
            else
            {
                // bk 19June19
                
//                let objParticipants = arrNewData[0] as! ParticipantsListEntity
//                cell.lblName.text = objParticipants.participantsName!
//                cell.imgProfile.sd_setImage(with: URL(string: (objParticipants.participantsImage!)), placeholderImage: UIImage(named: "gallery1"))
            }

                
            //let objAllMessages = AllMessages.init(dictionary: self.arrUsersList[indexPath.row] as! NSDictionary)!
                
            let objAllMessages = self.arrUsersList[indexPath.row] as! AllChatMessagesListEntity
            /*let strTimestamp = Utils.convertTimestampForChatHome(serverTimestamp: objAllMessages.messageTime)
            var strLastSentMsg = strTimestamp.components(separatedBy: " ")
            let strFullTime = String(format: "%@", strLastSentMsg[1])
            //strFullTime.removeLast(3)
            let strNewTime = String(format: "%@ %@", strFullTime, strLastSentMsg[2])
            cell.lblMsgTime.text = strNewTime //String(format: "%@ %@", strLastSentMsg[1], strLastSentMsg[2])*/
            let strTimestamp = Utils.convertTimestampForChatHome(serverTimestamp: objAllMessages.messageTime)
            cell.lblMsgTime.text = strTimestamp
                
            cell.lblDescription.text = objAllMessages.textMessage!
            index12 = index12 + 1
        }
        else if strType == "1"
        {
            //let objParticipants = Participants.init(dictionary: self.arrParticipantsList[indexPath.row] as! NSDictionary)!
            
            print(self.arrGroupList)
            print(self.arrGroupList.count)

            cell.lblName.text = ((self.arrGroupList[indexPath.row] as AnyObject).value(forKey: "group_name")) as? String
            let strImage = ((self.arrGroupList[indexPath.row] as AnyObject).value(forKey: "group_icon")) as? String
                
            cell.imgProfile.sd_setImage(with: URL(string: strImage!), placeholderImage: UIImage(named: "gallery1"))
                
            if arrUsersList.count > indexPath.row{
                
                let objAllMessages = self.arrUsersList[indexPath.row] as! AllChatMessagesListEntity
                
                
                let strTimestamp = Utils.convertTimestampForChatHome(serverTimestamp: objAllMessages.messageTime)
                cell.lblMsgTime.text = strTimestamp
                
                let userId = Auth.auth().currentUser?.uid
                if userId == objAllMessages.senderId!
                {
                    cell.lblDescription.text = String(format: "You: %@ ", objAllMessages.textMessage!)
                }
                else
                {
                    cell.lblDescription.text = String(format: "%@: %@ ", objAllMessages.senderName!, objAllMessages.textMessage!)
                }
            }
        }
        return cell
    }
    
    func dayDifference(from interval : Double) -> String
    {
        let x = interval / 1000
        let calendar = Calendar.current
        let date = Date(timeIntervalSince1970: x)
        if calendar.isDateInYesterday(date)
        {
            return "Yesterday"
        }
        else if calendar.isDateInToday(date)
        {
            return "Today"
            
        }
        else if calendar.isDateInTomorrow(date)
        {
            return "Tomorrow"
            
        }
        else
        {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .medium
            formatter.timeZone = NSTimeZone.local
            formatter.dateFormat = "yyyy-MM-dd hh:mm a"
            let time = formatter.string(from: date as Date)
            return time
            /*let startOfNow = calendar.startOfDay(for: Date())
            let startOfTimeStamp = calendar.startOfDay(for: date)
            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
            let day = components.day!
            if day < 1 { return "\(-day) days ago" }
            else { return "In \(day) days" }*/
        }
    }
    /*func showTodayYesterday(from interval : TimeInterval) -> String{
        let today = Date()
        let yesterday = today.addingTimeInterval(-86400.0)
        let thisWeek = today.addingTimeInterval(-604800.0)
        let lastWeek = today.addingTimeInterval(-1209600.0)
        
        let thisMonth = today.addingTimeInterval(-2629743.83)
        let lastMonth = today.addingTimeInterval(-5259487.66)
        return yesterday
    }*/
    
    /*
     
     
     
     {
     if self.arrLatestGroupList.count == 0 {
     return
     }
     let strType = ((self.arrLatestGroupList[indexPath.row] as AnyObject).value(forKey: "type")) as! String
     let strCellGroupId = ((self.arrLatestGroupList[indexPath.row] as AnyObject).value(forKey: "group_id")) as! String
     print("indexPath.row: ", indexPath.row)
     
     
     let objChatVC = Constant.chatStoryboard.instantiateViewController(withIdentifier: "idChatVC") as! ChatVC
     print(strType)
     objChatVC.strReceiverType = strType
     objChatVC.isClickedContactVC = "false"
     objChatVC.isDataFromLocalDB = "false"
     
     if strType == "0"
     {
     //                let arrNewList = NSMutableArray.init()
     //                arrNewList.add(self.dictData.value(forKey: strCellGroupId) as Any)
     //                let objParticipantsChat = arrNewList[0] as! ParticipantsListEntity
     
     let objParticipantsChat = Participants.init(dictionary: self.dictPartData.value(forKey: strCellGroupId)  as! NSDictionary)!
     //let objParticipantsChat = Participants.init(dictionary: self.arrPartList[indexPath.row] as! NSDictionary)!
     // let arrNewData = ((self.arrLatestGroupList[indexPath.row] as AnyObject).value(forKey: "group_id")) as! String
     objChatVC.strReceiverKey = strCellGroupId//self.arrChatKeyList[indexPath.row] as! String
     objChatVC.objParticipants = objParticipantsChat
     
     self.navigationController?.pushViewController(objChatVC, animated: true)
     }
     if strType == "1"
     {
     let objChatGroupVC = Constant.chatStoryboard.instantiateViewController(withIdentifier: "idChatGroupVC") as! ChatGroupVC
     
     objChatGroupVC.strGroupName = ((self.arrLatestGroupList[indexPath.row] as AnyObject).value(forKey: "group_name")) as! String
     //let strImage = ((self.arrGroupList[indexPath.row] as AnyObject).value(forKey: "group_icon")) as? String
     objChatGroupVC.strGroupImage = ((self.arrLatestGroupList[indexPath.row] as AnyObject).value(forKey: "group_icon")) as! String
     
     objChatGroupVC.strGroupUniqueKey = self.arrChatKeyList[indexPath.row] as! String
     // objChatGroupVC.strGroupUniqueKey = ((self.arrLatestGroupList[indexPath.row] as AnyObject).value(forKey: "group_id")) as! String//strCellGroupId
     
     print(self.arrChatKeyList[indexPath.row])
     
     objChatGroupVC.isFromChatListVC = "true"
     
     print((self.arrLatestGroupList[indexPath.row] as AnyObject))
     
     
     objChatGroupVC.dictGroupInfo = ((self.arrLatestGroupList[indexPath.row] as AnyObject) as! NSDictionary)
     
     //let deadlineTime = DispatchTime.now() + .seconds(2)
     //DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
     self.navigationController?.pushViewController(objChatGroupVC, animated: true)
     //})
     }
     }
 */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if self.arrLatestGroupList.count == 0 {
            return
        }
        let strType = ((self.arrLatestGroupList[indexPath.row] as AnyObject).value(forKey: "type")) as! String
        let strCellGroupId = ((self.arrLatestGroupList[indexPath.row] as AnyObject).value(forKey: "group_id")) as! String
        print("indexPath.row: ", indexPath.row)
        
        let objChatVC = Constant.chatStoryboard.instantiateViewController(withIdentifier: "idChatVC") as! ChatVC
        objChatVC.strReceiverType = strType
        objChatVC.isClickedContactVC = "false"
        objChatVC.isDataFromLocalDB = "false"
        
        if strType == "0"
        {
            //                let arrNewList = NSMutableArray.init()
            //                arrNewList.add(self.dictData.value(forKey: strCellGroupId) as Any)
            //                let objParticipantsChat = arrNewList[0] as! ParticipantsListEntity
            
            let objParticipantsChat = Participants.init(dictionary: self.dictPartData.value(forKey: strCellGroupId)  as! NSDictionary)!
            //let objParticipantsChat = Participants.init(dictionary: self.arrPartList[indexPath.row] as! NSDictionary)!
            // let arrNewData = ((self.arrLatestGroupList[indexPath.row] as AnyObject).value(forKey: "group_id")) as! String
            objChatVC.strReceiverKey = strCellGroupId//self.arrChatKeyList[indexPath.row] as! String
            objChatVC.objParticipants = objParticipantsChat
            
            self.navigationController?.pushViewController(objChatVC, animated: true)
        }
        if strType == "1"
        {
            let objChatGroupVC = Constant.chatStoryboard.instantiateViewController(withIdentifier: "idChatGroupVC") as! ChatGroupVC
            
            objChatGroupVC.strGroupName = ((self.arrLatestGroupList[indexPath.row] as AnyObject).value(forKey: "group_name")) as! String
            //let strImage = ((self.arrGroupList[indexPath.row] as AnyObject).value(forKey: "group_icon")) as? String
            objChatGroupVC.strGroupImage = ((self.arrLatestGroupList[indexPath.row] as AnyObject).value(forKey: "group_icon")) as! String
            
            objChatGroupVC.strGroupUniqueKey = self.arrChatKeyList[indexPath.row] as! String
            objChatGroupVC.strGroupUniqueKey = ((self.arrLatestGroupList[indexPath.row] as AnyObject).value(forKey: "group_id")) as! String//strCellGroupId
            
            objChatGroupVC.isFromChatListVC = "true"
            
            print((self.arrLatestGroupList[indexPath.row] as AnyObject))
            
            
            objChatGroupVC.dictGroupInfo = ((self.arrLatestGroupList[indexPath.row] as AnyObject) as! NSDictionary)
            
            //let deadlineTime = DispatchTime.now() + .seconds(2)
            //DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.navigationController?.pushViewController(objChatGroupVC, animated: true)
            //})
        }
    }
}

extension NSArray
{
    //sorting- ascending
    func ascendingArrayWithKeyValue(key:String) -> NSArray
    {
        let ns = NSSortDescriptor.init(key: key, ascending: true)
        let aa = NSArray(object: ns)
        let arrResult = self.sortedArray(using: aa as! [NSSortDescriptor])
        return arrResult as NSArray
    }
    
    func descendingArrayWithKeyValue(key:String) -> NSArray
    {
        let ns = NSSortDescriptor.init(key: key, ascending: false)
        let aa = NSArray(object: ns)
        let arrResult = self.sortedArray(using: aa as! [NSSortDescriptor])
        return arrResult as NSArray
    }
}
