//
//  GroupAdminSearchVC.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 24/06/2019.
//  Copyright © 2019 Swati. All rights reserved.
//

import UIKit
import  FirebaseAuth
import FirebaseDatabase
import FirebaseCore
import  CoreData

class GroupAdminSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomSearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate,groupActionViewDelegate {
  
    
    var viewGroupActionXib : GroupParticipantsActionView!
    var viewTransparent : UIView!

    @IBOutlet weak var viewTop: UIView!
    var arrSearchData = NSArray()
    var arrFilter = NSArray()
    @IBOutlet var tblSearchGroupAdmin: UITableView!
    
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    var newString = NSString()
    var isUserAdmin : Bool?

    var customSearchController: CustomSearchController!
    var userParticipantsDetail : UserDetailsModel?
    var userDetails : UserDetailsModel?
    var strGroupUniqueKey : String = ""
    var refDatabase: DatabaseReference!


    @IBOutlet var trpView: UIView!
    
    var dictGroupFullInfo = NSDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //idSearchChatListCell
        
        /*let scale : Bool = true
         self.viewTop.layer.masksToBounds = false
         self.viewTop.layer.shadowColor = UIColor.black.cgColor
         self.viewTop.layer.shadowOpacity = 0.5
         self.viewTop.layer.shadowOffset = CGSize(width: -1, height: 1)
         self.viewTop.layer.shadowRadius = 5
         
         // self.viewChatInfo.layer.shadowPath = UIBezierPath(rect: self.viewChatInfo.bounds).cgPath
         self.viewTop.layer.shouldRasterize = true
         self.viewTop.layer.rasterizationScale = scale ? UIScreen.main.scale : 1*/
        
        self.tblSearchGroupAdmin.estimatedRowHeight = 180.0
        self.tblSearchGroupAdmin.rowHeight = UITableViewAutomaticDimension
        self.tblSearchGroupAdmin.tableFooterView = UIView()
        self.tblSearchGroupAdmin.isHidden = false
        //self.tblSearchGroupAdmin.reloadData()
        
        //configureCustomSearchController()
        print("arrSearchData: ", arrSearchData)
        trpView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool)
    {
        configureSearchController()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
   
    override func viewDidDisappear(_ animated: Bool) {
        searchController.isActive = false
        searchController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCancel_Click(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        //searchController.searchBar.tintColor = Constant.MESH_BLUE
        UISearchBar.appearance().barTintColor = UIColor.white//Constant.MESH_BLUE
        //searchController.searchBar.backgroundColor = Constant.MESH_BLUE
        
        // Place the search bar view to the tableview headerview.
        tblSearchGroupAdmin.tableHeaderView = searchController.searchBar
        //self.viewTop.addSubview(searchController.searchBar)
    }
    
    func configureCustomSearchController()
    {
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: self.viewTop.frame.size.width-100, height: 50.0), searchBarFont: UIFont(name: "Titilium Web", size: 14.0)!, searchBarTextColor: UIColor.black, searchBarTintColor: UIColor.white)
        
        customSearchController.customSearchBar.placeholder = "Enter here to search"
        self.viewTop.addSubview(customSearchController.customSearchBar)
        //self.tblSearchGroupAdmin.tableHeaderView = customSearchController.customSearchBar
        customSearchController.customDelegate = self
    }
    
    // MARK: UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       // tblSearchGroupAdmin.tableHeaderView = nil

        shouldShowSearchResults = true
        self.tblSearchGroupAdmin.isHidden = false
        self.tblSearchGroupAdmin.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        self.tblSearchGroupAdmin.reloadData()
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popToRootViewController(animated: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.tblSearchGroupAdmin.reloadData()
        }

        searchController.searchBar.resignFirstResponder()
    }
    
    // MARK:-  UISearchResultsUpdating delegate function
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        let searchPredicate: NSPredicate
        searchPredicate = NSPredicate(format: "participant_name CONTAINS[C] %@", searchString)
        newString = searchString as NSString
        
        self.arrFilter = (self.arrSearchData as NSArray).filtered(using: searchPredicate) as NSArray
        
        print ("array = \(self.arrFilter)")
        self.tblSearchGroupAdmin.reloadData()
    }
    
    
    // MARK: CustomSearchControllerDelegate functions
    
    func didStartSearching() {
        shouldShowSearchResults = true
        self.tblSearchGroupAdmin.isHidden = false
        self.tblSearchGroupAdmin.reloadData()
    }
    
    
    
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.tblSearchGroupAdmin.isHidden = false
            self.tblSearchGroupAdmin.reloadData()
        }
    }
    
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        self.tblSearchGroupAdmin.isHidden = true
        //customSearchController.customSearchBar.text = ""
        //customSearchController.customSearchBar.placeholder = "Search in this awesome bar..."
        //self.tblSearchGroupAdmin.reloadData()
    }
    
    
    func didChangeSearchText(searchText: String) {
        // Filter the data array and get only those countries that match the search text.
        //        self.arrFilter = self.arrSearchData.filter({ (country) -> Bool in
        //            let countryText: NSString = country as! NSString
        //            print("countryText: ", countryText)
        //
        //            return false
        //            //return (countryText.rangeOfString(searchText, options: NSString.CompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        //        }) as NSArray
        
        //let searchPredicate = NSPredicate(format: "Name CONTAINS[C] %@", searchText)
        
        let searchPredicate: NSPredicate
        
        //let onlyDigits: CharacterSet = CharacterSet.decimalDigits.inverted
        
        searchPredicate = NSPredicate(format: "participant_name CONTAINS[C] %@", searchText)
        self.arrFilter = (self.arrSearchData as NSArray).filtered(using: searchPredicate) as NSArray
        
        print ("array = \(self.arrFilter)")
        
        // Reload the tableview.
        self.tblSearchGroupAdmin.reloadData()
    }
    
    @IBAction func btnBack_Click(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    // MARK: - Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if shouldShowSearchResults {
            return self.arrFilter.count
        }
        else {
            return self.arrSearchData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellReuseIdentifier = "idSearchGroupAdminCell"
        let cell:GroupAdminSearchTableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! GroupAdminSearchTableViewCell?)!
        cell.selectionStyle = .none
        self.tblSearchGroupAdmin.separatorStyle = .none
        let objAllMessages : AllMessages?
        if shouldShowSearchResults
        {
            if self.arrFilter.count == 0
            {
                cell.textLabel?.text = "No Results"
            }
            else
            {
                let objParticipants =   Participants.init(dictionary: (self.arrFilter[indexPath.row] as? NSDictionary)!)
                
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
                    cell.adminBTN.isHidden = false
                    cell.adminBTN.layer.cornerRadius = 3.0
                    cell.adminBTN.layer.borderWidth = 1.0
                    cell.adminBTN.layer.borderColor = Constant.MESH_BLUE.cgColor
                    cell.adminBTN.layer.masksToBounds = true
                }
                else
                {
                    cell.adminBTN.isHidden = true
                }
                if UserDefaults.standard.value(forKey: "ifUserName") != nil
                {
                    var selfUser = String()
                    selfUser = UserDefaults.standard.value(forKey: "ifUserName") as! String
                    if selfUser == objParticipants!.participantsName!
                    {
                        cell.lblParticipateName.text = "You"
                    }
                    else
                    {
                        cell.lblParticipateName.text = objParticipants!.participantsName!
                    }
                }
                else
                {
                    print("Nil")
                }
                
               // cell.lblParticipateName.text = objParticipants!.participantsName!
                print(cell.lblParticipateName.text as Any)
                cell.lblShortBio.text = objParticipants!.participantsShortBio!
                cell.imgParticipateImage.sd_setImage(with: URL(string: (objParticipants!.participantsImage!)), placeholderImage: UIImage(named: "account"))
                cell.imgParticipateImage.layer.cornerRadius = 4.0
                cell.imgParticipateImage.layer.masksToBounds = true

            }
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let objParticipants =   Participants.init(dictionary: (self.arrFilter[indexPath.row] as? NSDictionary)!)
        DefaultsValues.setUserValueToUserDefaults((self.arrFilter[indexPath.row] as? NSDictionary), forKey: "participants")
        
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
       // let strCreatedBy = self.dictGroupFullInfo.value(forKey: "created_By") as! String
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
        searchController.isActive = false
        searchController.searchBar .isHidden = true
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
        searchController.isActive = true
        searchController.searchBar .isHidden = false

        // handling code
    }
    
    func navigateToGroupActionController(index: Int) {
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
            
//            let alertController = UIAlertController(title: kAppName, message: String(format:"Removed from \"%@\" group",(self.dictGroupFullInfo.value(forKey: "group_name") as? String)!), preferredStyle: .alert)
//            
//            let okAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
//                self.removeTheParticipants()
//            }
//            
//            let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            
//            alertController.addAction(okAction)
//            alertController.addAction(CancelAction)
//            self.present(alertController, animated: true, completion: nil)
        }
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
                
                
                if msgGroupDict?.value(forKey: "participants") is NSMutableArray {
                    
                    childrens = msgGroupDict?.value(forKey: "participants") as! NSArray
                    
                    
                }else{
                    
                    let abc = msgGroupDict!.object(forKey: "participants") as! NSDictionary
                    
                    var abc2 = NSArray()
                    
                    abc2 = abc.allKeys as NSArray
                    
                    
                    let abc3 = NSMutableArray()
                    
                    
                    for indexx in abc2 {
                        
                        
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
    }
    
    /*func getGroupInfo(strGroupId: String) -> String
     {
     
     return strType
     }*/
}
