//
//  SearchFromChatListVC.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 07/01/2019.
//  Copyright © 2019 Swati. All rights reserved.
//

import UIKit
import  FirebaseAuth

class SearchFromChatListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomSearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate
{
    
    @IBOutlet weak var viewTop: UIView!
    var arrSearchData = NSArray()
    var arrFilter = NSArray()
    @IBOutlet weak var tblSearchChatList: UITableView!
    
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    var newString = NSString()
    
    var customSearchController: CustomSearchController!
    
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
        
        self.tblSearchChatList.estimatedRowHeight = 180.0
        self.tblSearchChatList.rowHeight = UITableViewAutomaticDimension
        self.tblSearchChatList.tableFooterView = UIView()
        self.tblSearchChatList.isHidden = false
        //self.tblSearchChatList.reloadData()
        configureSearchController()
        //configureCustomSearchController()
        print("arrSearchData: ", arrSearchData)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
        tblSearchChatList.tableHeaderView = searchController.searchBar
        //self.viewTop.addSubview(searchController.searchBar)
    }
    
    func configureCustomSearchController()
    {
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: self.viewTop.frame.size.width-100, height: 50.0), searchBarFont: UIFont(name: "Titilium Web", size: 14.0)!, searchBarTextColor: UIColor.black, searchBarTintColor: UIColor.white)
        
        customSearchController.customSearchBar.placeholder = "Enter here to search"
        self.viewTop.addSubview(customSearchController.customSearchBar)
        //self.tblSearchChatList.tableHeaderView = customSearchController.customSearchBar
        customSearchController.customDelegate = self
    }
    
    // MARK: UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        self.tblSearchChatList.isHidden = false
        self.tblSearchChatList.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        self.tblSearchChatList.reloadData()
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popToRootViewController(animated: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.tblSearchChatList.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
    // MARK:-  UISearchResultsUpdating delegate function
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        let searchPredicate: NSPredicate
        searchPredicate = NSPredicate(format: "text_msg CONTAINS[C] %@", searchString)
        newString = searchString as NSString
        
        self.arrFilter = (self.arrSearchData as NSArray).filtered(using: searchPredicate) as NSArray
        
        print ("array = \(self.arrFilter)")
        self.tblSearchChatList.reloadData()
    }
    
    
    // MARK: CustomSearchControllerDelegate functions
    
    func didStartSearching() {
        shouldShowSearchResults = true
        self.tblSearchChatList.isHidden = false
        self.tblSearchChatList.reloadData()
    }
    
    
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.tblSearchChatList.isHidden = false
            self.tblSearchChatList.reloadData()
        }
    }
    
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        self.tblSearchChatList.isHidden = true
        //customSearchController.customSearchBar.text = ""
        //customSearchController.customSearchBar.placeholder = "Search in this awesome bar..."
        //self.tblSearchChatList.reloadData()
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
        
        searchPredicate = NSPredicate(format: "text_msg CONTAINS[C] %@", searchText)
        self.arrFilter = (self.arrSearchData as NSArray).filtered(using: searchPredicate) as NSArray
        
        print ("array = \(self.arrFilter)")
        
        // Reload the tableview.
        self.tblSearchChatList.reloadData()
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
        let cellReuseIdentifier = "idSearchChatListCell"
        let cell:SearchChatListTableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SearchChatListTableViewCell?)!
        cell.selectionStyle = .none
        self.tblSearchChatList.separatorStyle = .none
        let objAllMessages : AllMessages?
        if shouldShowSearchResults
        {
            if self.arrFilter.count == 0
            {
                cell.textLabel?.text = "No Results"
            }
            else
            {
            objAllMessages = AllMessages.init(dictionary: self.arrFilter[indexPath.row] as! NSDictionary)!
            //let objAllMessages = AllMessages.init(dictionary: self.arrSearchData[indexPath.row] as! NSDictionary)!
            
            let strTimestamp = Utils.convertTimestamp(serverTimestamp: objAllMessages!.messageTime!)
            var strLastSentMsg = strTimestamp.components(separatedBy: " ")
            
            cell.lblChatUserName.text = objAllMessages!.senderName!
            
            let strMsg = objAllMessages!.textMessage! as String
            cell.imgProfile.sd_setImage(with: URL(string: (objAllMessages!.senderImage!)), placeholderImage: UIImage(named: "gallery1"))
           // let attributedStringForMsg = NSMutableAttributedString(string: strMsg as String, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15.0)])
            // Part of string to be bold and blue color
            //let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15.0)]
            
            let nsRange = NSString(string: strMsg).range(of: newString as String, options: String.CompareOptions.caseInsensitive)
            
            if nsRange.location != NSNotFound
            {
                let attributedSubString = NSAttributedString.init(string: NSString(string: strMsg).substring(with: nsRange), attributes: [NSAttributedStringKey.font : UIFont(name: "TitilliumWeb-Bold", size: 15.0)!, NSAttributedStringKey.foregroundColor: Constant.MESH_BLUE])
                let normalNameString = NSMutableAttributedString.init(string: strMsg)
                normalNameString.replaceCharacters(in: nsRange, with: attributedSubString)
                cell.lblChatText.attributedText = normalNameString
            }
            else
            {
                cell.lblChatText.text = strMsg
            }
            
            //cell.textLabel!.attributedText = attributedStringForName
            //cell.lblChatText.attributedText = attributedStringForMsg
            cell.lblChatTime.text = String(format: "%@", strLastSentMsg[0]) //strLastSentMsg[1], strLastSentMsg[2]
            }
        }
//        else
//        {
//            objAllMessages = AllMessages.init(dictionary: self.arrSearchData[indexPath.row] as! NSDictionary)!
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let objAllMessages = AllMessages.init(dictionary: self.arrFilter[indexPath.row] as! NSDictionary)!
        print("objAllMessages: ", objAllMessages.messageId!)
        let strGroupId = (self.arrFilter[indexPath.row] as AnyObject).value(forKey: "group_id") as! String
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

        self.dismiss(animated: true, completion: nil)
        
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            
        if strChatType == "0"
        {
            let objChatVC = Constant.chatStoryboard.instantiateViewController(withIdentifier: "idChatVC") as! ChatVC
            objChatVC.strSearchText = self.newString as String
            objChatVC.strReceiverKey = strGroupId
            let objParticipantsChat = Participants.init(dictionary: dictPartData.value(forKey: strGroupId)  as! NSDictionary)!
            objChatVC.objParticipants = objParticipantsChat
            objChatVC.isDataSearched = true
           
            self.navigationController?.pushViewController(objChatVC, animated: true)
        }
        else if strChatType == "1"
        {
            let objChatGroupVC = Constant.chatStoryboard.instantiateViewController(withIdentifier: "idChatGroupVC") as! ChatGroupVC
            objChatGroupVC.strSearchText = self.newString as String
            objChatGroupVC.strGroupUniqueKey = strGroupId
            objChatGroupVC.strGroupName = strGroupName
            objChatGroupVC.strGroupImage = strGroupImage
            objChatGroupVC.isDataSearched = true
            self.navigationController?.pushViewController(objChatGroupVC, animated: true)
        }
    })
    }
    
    /*func getGroupInfo(strGroupId: String) -> String
    {
        
        return strType
    }*/
}
