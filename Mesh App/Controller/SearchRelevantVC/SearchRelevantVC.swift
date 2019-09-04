//
//  SearchRelevantVC.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 15/01/2019.
//  Copyright © 2019 Swati. All rights reserved.
//

import UIKit
import SwiftMessageBar
import Firebase
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD

class SearchRelevantVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomSearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, menuViewDelegate
{
    @IBOutlet weak var btnContact: UIButton!
    @IBOutlet weak var btnSync: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    var viewMenuXib : MenuView!
    @IBOutlet weak var btnMenu: UIButton!
    var viewTransparent : UIView!
    
    @IBOutlet weak var btnBuzz: UIButton!
    @IBOutlet weak var lblNoMessages: UILabel!
    @IBOutlet weak var btnRelevant: UIButton!
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var viewTop: UIView!
    var arrSearchData = NSMutableArray()
    var arrFilter = NSMutableArray()
    @IBOutlet weak var tblSearchRelevantList: UITableView!
    
    var shouldShowSearchResults = false
    var meshUserDetails : UserDetailsModel?
    
    var searchController: UISearchController!
    
    var customSearchController: CustomSearchController!
    
    var hud = JGProgressHUD()

    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //idSearchRelevantCell
        
        //print("Mesh User: ", DefaultsValues.getCustomObjFromUserDefaults_(forKey: kMeshContactList)!)
        //arrSearchData = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kMeshContactList) as! NSArray
        let image = UIImage(named: "name") as UIImage?

     //   btnSync.setImage(image, for: .normal)

       // btnSync.setBackgroundImage(UIImage(named: "refreshBT"), for: .normal)
//"r"//refresh22
        
        print("arrSearchData: ", self.arrSearchData)
        if self.arrSearchData.count == 0
        {
            self.tblSearchRelevantList.isHidden = true
            self.lblNoMessages.isHidden = false
            return
        }
        self.getRelevantData()
        //configureSearchController()
        //configureCustomSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if (viewMenuXib != nil)
        {
            viewTransparent.removeFromSuperview()
            viewMenuXib.removeFromSuperview()
        }
    }
    
    //MARK:- Get All Filter Data
    
    func getRelevantData()
    {
        meshUserDetails = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kUserDetails) as? UserDetailsModel
        self.arrFilter = NSMutableArray.init()
        
        for i in 0..<self.arrSearchData.count
        {
            var searchString = meshUserDetails!.interests!
            if searchString.contains("#") {
                //print("exists")
                searchString.remove(at: searchString.startIndex)
            }
            let dict = self.arrSearchData[i]
            let arrMutable = NSMutableArray()
            arrMutable.add(dict)
            
            var arrSeparatedText = searchString.components(separatedBy: ",")
            var arrPredicate = [NSPredicate]()
            for i in 0 ..< arrSeparatedText.count
            {
                //   let i = NSPredicate(format: "name contains[c] %@",arrInterest[i])
                arrPredicate.append(NSPredicate(format: "SELF.text_msg contains[c] %@",arrSeparatedText[i]))
            }
            
            let compoundPredicate = NSCompoundPredicate.init(orPredicateWithSubpredicates: arrPredicate)
            print(compoundPredicate)
            
            let arr1 = arrMutable as NSArray
            let temparr = arr1.filtered(using: compoundPredicate)
            let arr=(temparr as NSArray).mutableCopy() as! NSMutableArray
            //self.arrFilter = (temparr as NSArray).mutableCopy() as! NSMutableArray
            //let arr=(arrData as NSArray).filtered(using: predicate) as! NSMutableArray
            
            if arr.count > 0
            {
                //self.arrFilter.removeAllObjects()
                //self.arrFilter = arr.mutableCopy() as! NSArray
                
//                if self.arrFilter.contains(arr){
//
//                    
//                }else{
//                    self.arrFilter.add(arr)
//
//                }
                
                
//                var dataArray: NSMutableArray = NSMutableArray()
//
//                let indexes = arrFilter.enumerated().filter({ ($0 as! NSArray)[0]["group_id"] == ($1 as! NSArray)[0]["group_id"]} )
                
//                let items: [String] = ["A", "B", "A", "C", "A", "D"]
//                print(items.enumerated().filter({ $0.element == "A" }).map({ $0.offset }))
                
                
//                print(arr)
//                
//                if arrFilter.count != 0 {
//                    let pass = arrFilter.enumerated().filter { (index, element) -> Bool in
//
//                        if (((element as! NSMutableArray)[0] as! NSDictionary)["group_id"] as? String == ((arr )[0] as! NSDictionary)["group_id"] as? String) && (((element as! NSMutableArray)[0] as! NSDictionary)["sender_id"] as? String == ((arr )[0] as! NSDictionary)["sender_id"] as? String) && (((element as! NSMutableArray)[0] as! NSDictionary)["text_msg"] as? String == ((arr )[0] as! NSDictionary)["text_msg"] as? String) {
//                            return false
//                        }
//                        self.arrFilter.add(arr)
//                        return false
//                    }
//
//                } else {
//                    self.arrFilter.add(arr)
//                }
                
                
                var isExist: Bool = false
                for data in arrFilter {
                    if (((data as! NSMutableArray)[0] as! NSDictionary)["group_id"] as? String == ((arr )[0] as! NSDictionary)["group_id"] as? String) && (((data as! NSMutableArray)[0] as! NSDictionary)["sender_id"] as? String == ((arr )[0] as! NSDictionary)["sender_id"] as? String) && (((data as! NSMutableArray)[0] as! NSDictionary)["text_msg"] as? String == ((arr )[0] as! NSDictionary)["text_msg"] as? String) {
                        
                        isExist = true
                        break
                    }
                }
                
                if !isExist {
                    self.arrFilter.add(arr)
                }
                
                
                
//                self.arrFilter.add(arr)

                
            }
            
            /*var strSearch1 = String(format: "%@", strSeparatedText[0])
             strSearch1.remove(at: strSearch1.startIndex)
             let searchPredicate1 = NSPredicate(format: "SELF.text_msg CONTAINS[c] %@", strSearch1)
             //self.arrFilter = self.arrSearchData.filter {  $0.searchString.contains(strTextMsg)}
             
             let strSearch2 = String(format: "%@", strSeparatedText[1])
             var trimmedString = strSearch2.trimmingCharacters(in: .whitespaces)
             trimmedString.remove(at: trimmedString.startIndex)
             
             let searchPredicate2=NSPredicate(format: "SELF.text_msg CONTAINS[c] %@",  strSearch2)
             let predicateOr = NSCompoundPredicate.init(type: .or, subpredicates: [searchPredicate1, searchPredicate2])*/
        }
        
        print ("array = \(self.arrFilter)")

        
        
        if self.arrFilter.count > 0
        {
            //if hud != nil
            //{
                hud.dismiss()
            //}
            shouldShowSearchResults = true
            self.tblSearchRelevantList.estimatedRowHeight = 180.0
            self.tblSearchRelevantList.rowHeight = UITableViewAutomaticDimension
            self.tblSearchRelevantList.tableFooterView = UIView()
            self.tblSearchRelevantList.isHidden = false
            self.lblNoMessages.isHidden = true
            self.tblSearchRelevantList.reloadData()
        }
        else if self.arrFilter.count == 0
        {
             hud.dismiss()
            
            self.tblSearchRelevantList.isHidden = true
            self.lblNoMessages.isHidden = false
            return
        }
    }
    
    func getFilteredData()
    {
        hud = JGProgressHUD(style: .dark)
        hud.indicatorView?.tintColor = Constant.MESH_BLUE
        hud.textLabel.text = "Loading Data...."
        hud.show(in: self.view)
        
        arrSearchData = NSMutableArray()
        //let chatUserId = Auth.auth().currentUser?.uid
    
        let refUserPath = ChatConstants.refs.databaseParticularUserInfo
        refUserPath.observe(.childAdded, with: {snapshot in
           let strUniqueKey = snapshot.key
            
            let refAllMsgInfo = ChatConstants.refs.databaseMessagesInfo.child(strUniqueKey)
            refAllMsgInfo.observe(.childAdded, with: {snapshot in
                //for child in snapshot.children {
                // let snap = child as! DataSnapshot
                let msgLastInfoDict = snapshot.value as? NSDictionary
                self.arrSearchData.add(msgLastInfoDict!)
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    @IBAction func btnCancel_Click(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureSearchController()
    {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        //searchController.searchBar.tintColor = Constant.MESH_BLUE
        
        // Place the search bar view to the tableview headerview.
        //tblSearchRelevantList.tableHeaderView = searchController.searchBar
        self.viewTop.addSubview(searchController.searchBar)
    }
    
    func configureCustomSearchController()
    {
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: self.tblSearchRelevantList.frame.size.width-100, height: 50.0), searchBarFont: UIFont(name: "Titilium Web", size: 14.0)!, searchBarTextColor: UIColor.black, searchBarTintColor: UIColor.white)
        
        customSearchController.customSearchBar.placeholder = "Enter here to search"
        self.viewTop.addSubview(customSearchController.customSearchBar)
        //self.tblSearchChatList.tableHeaderView = customSearchController.customSearchBar
        customSearchController.customDelegate = self
    }
    
    // MARK: UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        shouldShowSearchResults = true
        self.tblSearchRelevantList.isHidden = false
        self.tblSearchRelevantList.reloadData()
    }    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        self.tblSearchRelevantList.reloadData()
        self.navigationController?.popViewController(animated: false)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.tblSearchRelevantList.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
    
    // MARK:-  UISearchResultsUpdating delegate function
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        // Filter the data array and get only those countries that match the search text.
        //        self.arrFilter = self.arrSearchData.filter({ (country) -> Bool in
        //            let countryText:NSString = country as! NSString
        //            print("countryText: ", countryText)
        //            return false
        //            //return (countryText.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        //        }) as NSArray
        
        let searchPredicate: NSPredicate
        searchPredicate = NSPredicate(format: "text_msg CONTAINS[C] %@", searchString)
        
        /*let onlyDigits: CharacterSet = CharacterSet.decimalDigits.inverted
         
         if searchString.rangeOfCharacter(from: onlyDigits) == nil
         {
         searchPredicate = NSPredicate(format: "Number CONTAINS[C] %@", searchString)
         }
         else
         {
         searchPredicate = NSPredicate(format: "Name CONTAINS[C] %@", searchString)
         }*/
        
        self.arrFilter = (self.arrSearchData as NSArray).filtered(using: searchPredicate) as NSArray as! NSMutableArray
        
        print ("array = \(self.arrFilter)")
        
        // Reload the tableview.
        self.tblSearchRelevantList.reloadData()
    }
    
    
    // MARK: CustomSearchControllerDelegate functions
    
    func didStartSearching() {
        shouldShowSearchResults = true
        self.tblSearchRelevantList.reloadData()
    }
    
    
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.tblSearchRelevantList.reloadData()
        }
    }
    
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        customSearchController.customSearchBar.text = ""
        customSearchController.customSearchBar.placeholder = "Search in this awesome bar..."
        self.tblSearchRelevantList.reloadData()
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
        
        searchPredicate = NSPredicate(format: "interests CONTAINS[C] %@", searchText)
        self.arrFilter = (self.arrSearchData as NSArray).filtered(using: searchPredicate) as NSArray as! NSMutableArray
        
        print ("array = \(self.arrFilter)")
        
        // Reload the tableview.
        self.tblSearchRelevantList.reloadData()
    }
    
    // MARK: - Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        //return 80
        
        return ((tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath))?.contentView.frame.size.height)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        print(self.arrFilter)
        print(self.arrSearchData)

        
        if shouldShowSearchResults {
            return self.arrFilter.count
        }
        else {
            return self.arrSearchData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellReuseIdentifier = "idRelevantCell"
        let cell:SearchRelevantTableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SearchRelevantTableViewCell?)!
        cell.selectionStyle = .none
        //let objMeshUser : UserDetailsModel?
        
        if shouldShowSearchResults
        {
            //objMeshUser = UserDetailsModel.init(dictionary: self.arrFilter[indexPath.row] as! NSDictionary)!
            
            print(self.arrFilter)
            
            let arr = self.arrFilter as NSArray
            let arrNew = arr[indexPath.row] as! NSArray
            let dict = arrNew[0] as! NSDictionary
            
            let objAllMessages = AllMessages.init(dictionary: dict)!
            //let objAllMessages = AllMessages.init(dictionary: self.arrFilter[indexPath.row] as! NSDictionary)!
            let strTimestamp = Utils.convertTimestampForChatHome(serverTimestamp: objAllMessages.messageTime!)
            //var strCreatedOn = strTimestamp.components(separatedBy: " ")
//            cell.lblChatUserName.text = objAllMessages.senderName!
//            cell.lblChatText.text = objAllMessages.textMessage!
            
            print(dict)
            
         //   cell.lblChatUserName.text = objAllMessages.senderName!
            
            
            let main_string = objAllMessages.senderName! + ":" + objAllMessages.textMessage!
            
            
            var abc = String()
            if let range = main_string.range(of: ":") {
                let firstPart = main_string[main_string.startIndex..<range.lowerBound]
                print(firstPart) // print Hello
                
                abc = String(firstPart)
                
            }
            
            let string_to_color:String = abc
            
            let range = (main_string as NSString).range(of: string_to_color)
            
            let attribute = NSMutableAttributedString.init(string: main_string)
            attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.gray , range: range)
            
            cell.lblChatText.attributedText = attribute
            
            
//            cell.lblChatText.text = objAllMessages.senderName! + ":" + objAllMessages.textMessage!
//
            cell.lblChatTime.text = String(format: "%@", strTimestamp)
            
            cell.imgProfile.sd_setImage(with: URL(string: (objAllMessages.senderImage!)), placeholderImage: UIImage(named: "gallery1"))
            
            
            print(dict.value(forKey: "group_id") as Any)
            
            let strGroupId = dict.value(forKey: "group_id") as! String//(self.arrFilter[indexPath.row] as AnyObject).value(forKey: "group_id") as! String
            var strChatType : String = ""
          
            let refChatInfo = ChatConstants.refs.databaseChatInfo.child(strGroupId)
            let arrGroupData = NSMutableArray()
            let dictPartData = NSMutableDictionary()
            //let chatUserId = Auth.auth().currentUser?.uid
            
            refChatInfo.observe(.childAdded, with: {snapshot in
                let msgGroupDict = snapshot.value as? NSDictionary
                strChatType = msgGroupDict!.value(forKey: "type") as! String
                
                arrGroupData.add(msgGroupDict!)
                if strChatType == "0"
                {
                    let childrens = msgGroupDict?.value(forKey: "participants") as! NSArray
                    for child in  childrens {
                        let msgParticipantsDict = child as? NSDictionary
                        //let strCheckKey = msgParticipantsDict!.value(forKey: "participant_id") as! String
                        //if strCheckKey != chatUserId
                        //{
                        dictPartData.setValue(msgParticipantsDict!, forKey: strGroupId)
                        //}
                    }
                }
                else if strChatType == "1"
                {
                    cell.lblChatUserName.text = msgGroupDict!.value(forKey: "group_name") as? String
                    
                    
                    cell.imgProfile.sd_setImage(with: URL(string: msgGroupDict!.value(forKey: "group_icon") as! String), placeholderImage: UIImage(named: "gallery1"))
                    
                    
                }
            })
            
            
            //End
            
            
        }
        else
        {
            //objMeshUser = UserDetailsModel.init(dictionary: self.arrSearchData[indexPath.row] as! NSDictionary)!
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let arr = self.arrFilter as NSArray
        let arrNew = arr[indexPath.row] as! NSArray
        let dict = arrNew[0] as! NSDictionary
        let objAllMessages = AllMessages.init(dictionary: dict)!
        print("objAllMessages: ", objAllMessages.messageId!)
        let strGroupId = dict.value(forKey: "group_id") as! String//(self.arrFilter[indexPath.row] as AnyObject).value(forKey: "group_id") as! String
        var strChatType : String = ""
        var strGroupName : String = ""
        var strGroupImage : String = ""
        
        let refChatInfo = ChatConstants.refs.databaseChatInfo.child(strGroupId)
        let arrGroupData = NSMutableArray()
        let dictPartData = NSMutableDictionary()
        //let chatUserId = Auth.auth().currentUser?.uid
        
        refChatInfo.observe(.childAdded, with: {snapshot in
            let msgGroupDict = snapshot.value as? NSDictionary
            strChatType = msgGroupDict!.value(forKey: "type") as! String
            
            arrGroupData.add(msgGroupDict!)
            if strChatType == "0"
            {
                let childrens = msgGroupDict?.value(forKey: "participants") as! NSArray
                for child in  childrens {
                    let msgParticipantsDict = child as? NSDictionary
                    //let strCheckKey = msgParticipantsDict!.value(forKey: "participant_id") as! String
                    //if strCheckKey != chatUserId
                    //{
                    dictPartData.setValue(msgParticipantsDict!, forKey: strGroupId)
                    //}
                }
            }
            else if strChatType == "1"
            {
                strGroupName = msgGroupDict!.value(forKey: "group_name") as! String
                strGroupImage = msgGroupDict!.value(forKey: "group_icon") as! String
            }
        })
        
        //self.dismiss(animated: true, completion: nil)
        
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            
            if strChatType == "0"
            {
                let objChatVC = Constant.chatStoryboard.instantiateViewController(withIdentifier: "idChatVC") as! ChatVC
                objChatVC.strReceiverKey = strGroupId
                let objParticipantsChat = Participants.init(dictionary: dictPartData.value(forKey: strGroupId)  as! NSDictionary)!
                objChatVC.objParticipants = objParticipantsChat
                objChatVC.isDataSearched = true
                
                self.navigationController?.pushViewController(objChatVC, animated: true)
            }
            else if strChatType == "1"
            {
                let objChatGroupVC = Constant.chatStoryboard.instantiateViewController(withIdentifier: "idChatGroupVC") as! ChatGroupVC
                objChatGroupVC.strGroupUniqueKey = strGroupId
                objChatGroupVC.strGroupName = strGroupName
                objChatGroupVC.strGroupImage = strGroupImage
                objChatGroupVC.isDataSearched = true
                self.navigationController?.pushViewController(objChatGroupVC, animated: true)
            }
        })
    }
    
    //MARK:- Menu Action
    
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
            //objAddGroupSubjectVC.arrParticipantsData = self.arrSelectedData.mutableCopy() as! NSMutableArray
            self.navigationController?.pushViewController(objAddGroupSubjectVC, animated: true)
        }
        else if index == 3
        {
            let objTermsAndPoliciesVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idTermsAndPoliciesVC") as! TermsAndPoliciesVC
            self.navigationController?.pushViewController(objTermsAndPoliciesVC, animated: true)
        }
    }
    
    //MARK:- Get All Buzz Posts
    
    @IBAction func btnSync_Click(_ sender: Any)
    {
        self.getFilteredData()
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.getRelevantData()
        })
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
    
    @IBAction func btnBuzzPosts_Click(_ sender: Any)
    {
        let objBuzzPostsVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idBuzzPostsVC") as! BuzzPostsVC
        objBuzzPostsVC.arrSearchData = self.arrSearchData 
        self.navigationController?.pushViewController(objBuzzPostsVC, animated: false)
    }
    
    @IBAction func btnRelevant_Click(_ sender: Any)
    {
//        let objSearchRelevantVC = Constant.chatStoryboard.instantiateViewController(withIdentifier: "idSearchRelevantVC") as! SearchRelevantVC
//        self.navigationController?.pushViewController(objSearchRelevantVC, animated: false)
    }
    
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
        let objChatListVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idChatListVC") as! ChatListVC
        self.navigationController?.pushViewController(objChatListVC, animated: false)
        //self.navigationController?.popViewController(animated: false)
    }
}
