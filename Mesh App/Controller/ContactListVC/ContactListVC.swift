//
//  ContactListVC.swift
//  Mesh App
//
//  Created by Mac admin on 28/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import Contacts
import CoreTelephony
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD

class ContactListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, CustomSearchControllerDelegate,CNContactViewControllerDelegate, ContactListCellDelegate
{
    var contactStore = CNContactStore()
    @IBOutlet weak var selectedContactCollection: UICollectionView!
    @IBOutlet weak var viewCollectionList: UIView!
    @IBOutlet weak var tblContactList: UITableView!
    
    var arrFilter = NSArray()
    var arrColorCode = NSArray()
    var contactsArray = NSMutableArray()
    var refDatabase: DatabaseReference!
    
    @IBOutlet weak var viewSearch: UIView!
    
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    
    var customSearchController: CustomSearchController!
    
    @IBOutlet weak var searchBarName: UISearchBar!
    var arrAllContacts = NSArray()
    var arrAllNewContacts = NSMutableArray()
    var index = Int()
    var lastSelection = NSIndexPath()
    
    var arrAllMeshUserList = NSMutableArray()
    
    var arrFinalArray : [[String:String]] = []
    //var arrFinalArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //DefaultsValues.setBooleanValueToUserDefaults(false, forKey: kImportContactFirstTime)        
        DefaultsValues.setStringValueToUserDefaults("false", forKey: kImportContactFirstTime)
        
        let defaults = UserDefaults.standard
        
        //self.displayAlContacts()
        
        self.arrAllContacts = defaults.object(forKey: "phone_contacts")! as! NSArray
        arrFinalArray = self.arrAllContacts as! [[String : String]]
        
        print("arrAllContacts: ", arrAllContacts)
        //SaveAndFetchCoreData.savePhoneContactList(arrayContacts: arrAllContacts as! NSMutableArray)
        //let arrData = SaveAndFetchCoreData.getContactList()
        //print("arrData: ", arrData)
        
        arrColorCode = [UIColor.init(red: 238/255.0, green: 90/255.0, blue: 36/255.0, alpha: 1.0),
                        UIColor.init(red: 163/255.0, green: 203/255.0, blue: 56/255.0, alpha: 1.0),
                        UIColor.init(red: 87/255.0, green: 88/255.0, blue: 187/255.0, alpha: 1.0),
                        UIColor.init(red: 24/255.0, green: 167/255.0, blue: 227/255.0, alpha: 1.0),
                        UIColor.init(red: 246/255.0, green: 36/255.0, blue: 89/255.0, alpha: 1.0),
                        UIColor.init(red: 65/255.0, green: 131/255.0, blue: 215/255.0, alpha: 1.0),
                        UIColor.init(red: 58/255.0, green: 83/255.0, blue: 155/255.0, alpha: 1.0),
                        UIColor.init(red: 27/255.0, green: 163/255.0, blue: 156/255.0, alpha: 1.0),
                        UIColor.init(red: 30/255.0, green: 130/255.0, blue: 76/255.0, alpha: 1.0),
                        UIColor.init(red: 242/255.0, green: 120/255.0, blue: 75/255.0, alpha: 1.0),
                        UIColor.init(red: 68/255.0, green: 108/255.0, blue: 179/255.0, alpha: 1.0),
                        UIColor.init(red: 217/255.0, green: 30/255.0, blue: 24/255.0, alpha: 1.0),                        
        ]
        self.tblContactList.isHidden = true
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            connectedRef.observe(.value, with: { snapshot in
                if snapshot.value as? Bool ?? false {
                    self.getContactListWhichAreOnMesh()
                    print("Connected")
                }
                else
                {
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
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getContactListWhichAreOnMesh()
    {
//        let hud = JGProgressHUD(style: .dark)
//        hud.textLabel.text = "Loading"
//        hud.show(in: self.view)
        self.viewSearch.isHidden = true
        let arr = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kAllContacts) as! [[String : String]]
        if arr.count > 0
        {
            self.arrFinalArray = arr
            self.tblContactList.isHidden = false
            self.tblContactList.reloadData()
            return
        }
        
        for i in 0..<self.arrAllContacts.count
        {
            self.refDatabase = Database.database().reference()
            //let chatUserId = Auth.auth().currentUser?.uid
            let arrNewMessages = self.refDatabase.child("UserInfo")
            arrNewMessages.observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    
                    //let string = snap.key
                    let msgDict = snap.value as? [String: AnyObject]
                    let msgUserDetails = snap.value as? NSDictionary
                    print("msgDict: ", msgDict!["contact_no"]!)
                    let strMeshUserContactNo = msgDict!["contact_no"] as? String
                    let strPhoneContact = (self.arrAllContacts[i] as AnyObject).object(forKey:"Number") as! String
                    if strMeshUserContactNo == strPhoneContact
                    {
                        self.arrAllMeshUserList.add(msgUserDetails!)
                        DefaultsValues.setCustomObjToUserDefaults(self.arrAllMeshUserList, forKey: kMeshContactList)                        
                    }
                    let result = self.arrayContains(array: self.arrAllContacts as! [[String : String]], key: "Number", value: strMeshUserContactNo!)
                    print(result)
                }
                print("arrFinalArray: ", self.arrFinalArray)
                let deadlineTime = DispatchTime.now() + .seconds(2)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                    //hud.dismiss()
                    DefaultsValues.setCustomObjToUserDefaults(self.arrFinalArray, forKey: kAllContacts)
                    self.tblContactList.isHidden = false
                    self.tblContactList.reloadData()
                })
            })
        }
        
    }
    
    func arrayContains(array:[[String:String]], key: String, value: String) -> Bool
    {
        for var dict in array {
            print("dict: ", dict)
            if dict[key] == value {
                let index = array.index(of: dict)
                dict.updateValue("Yes", forKey: "isExist")
                arrFinalArray[index!] = dict
                return true
            }
        }
        return false
    }
    
    @IBAction func btnSearchContacts_Click(_ sender: UIButton) {
        //configureCustomSearchController()
    }
//    @IBAction func btnSearch_Click(_ sender: Any)
//    {
//
//    }
    
    @IBAction func btnBack_Click(_ sender: Any)
    {
         self.navigationController?.popViewController(animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("abc")
    }
    
    // MARK: - Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if shouldShowSearchResults {
            return self.arrFilter.count
        }
        else {
            return self.arrAllContacts.count
        }
        //return self.arrAllContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellReuseIdentifier = "idContactListCell"
        let cell:ContactListTableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ContactListTableViewCell?)!
        cell.selectionStyle = .none
        
//        let currentColor : UIColor = (arrColorCode[indexPath.row % arrColorCode.count] as? UIColor)!
//        cell.imgContactProfile.backgroundColor = currentColor
        
        cell.imgContactProfile.image = UIImage(named: "gallery1")
        
        cell.cellContactDelegate = self
        cell.tag = indexPath.row
        cell.btnInvite.tag = 100 + indexPath.row
        cell.btnChat.tag = 100 + indexPath.row
        
         let strIsExistOnMeshApp = (self.arrFinalArray[indexPath.row] as AnyObject).object(forKey:"isExist") as! String
        
        if strIsExistOnMeshApp == "Yes"
        {
            cell.btnChat.isHidden = false
            cell.btnInvite.isHidden = true
            cell.btnChat.addTarget(self, action: #selector(btnChat_Click), for: .touchUpInside)
            cell.btnInvite.addTarget(self, action: #selector(btnInvite_Click), for: .touchUpInside)
        }
        else
        {
            cell.btnChat.isHidden = true
            cell.btnInvite.isHidden = false
            cell.btnChat.addTarget(self, action: #selector(btnChat_Click), for: .touchUpInside)
            cell.btnInvite.addTarget(self, action: #selector(btnInvite_Click), for: .touchUpInside)
        }
        
        if shouldShowSearchResults
        {
            cell.btnInvite.tag = 100 + indexPath.row
            if (self.arrFilter[indexPath.row] as AnyObject).object(forKey:"Name") as? String != ""
            {
                let strName = (self.arrFilter[indexPath.row] as AnyObject).object(forKey:"Name") as! String
                let strFirstChar = strName.prefix(1);
                cell.lblContactName.text =  strName //(self.arrFilter[indexPath.row] as AnyObject).object(forKey:"Name") as? String
                cell.lblTitleName.text = String(strFirstChar)
            }
            else
            {
                let strName = (self.arrFilter[indexPath.row] as AnyObject).object(forKey:"Number") as! String
                let strFirstChar = strName.prefix(1);
                cell.lblContactName.text = strName //(self.arrFilter[indexPath.row] as AnyObject).object(forKey:"Number") as? String
                cell.lblTitleName.text = String(strFirstChar)
            }
        }
        else
        {
            if (self.arrAllContacts[indexPath.row] as AnyObject).object(forKey:"Name") as? String != ""
            {
                let strName = (self.arrAllContacts[indexPath.row] as AnyObject).object(forKey:"Name") as! String
                let strFirstChar = strName.prefix(1);
                cell.lblContactName.text =  strName //(self.arrFilter[indexPath.row] as AnyObject).object(forKey:"Name") as? String
                cell.lblTitleName.text = String(strFirstChar)
            }
            else //if (self.arrAllContacts[indexPath.row] as AnyObject).object(forKey:"Name") as? String == nil
            {
                let strName = (self.arrAllContacts[indexPath.row] as AnyObject).object(forKey:"Number") as! String
                let strFirstChar = strName.prefix(1);
                cell.lblContactName.text = strName //(self.arrFilter[indexPath.row] as AnyObject).object(forKey:"Number") as? String
                cell.lblTitleName.text = String(strFirstChar)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        let strPlusClicked = DefaultsValues.getStringValueFromUserDefaults_(forKey: "plus_clicked");
//         if strPlusClicked == "YES"
//         {
//            tableView.deselectRow(at: indexPath, animated: true)
//
//            if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
//                if cell.accessoryType == .checkmark{
//                    cell.accessoryType = .none
//                }
//                else{
//                    cell.accessoryType = .checkmark
//                }
//            }
//        }
//        else
//         {
                    //let objChatScreenVC = Constant.chatStoryboard.instantiateViewController(withIdentifier: "idChatScreenVC") as! ChatScreenVC
                    //self.navigationController?.pushViewController(objChatScreenVC, animated: true)
        //}
        
        //        print("self.arrFilter: ", self.arrFilter.count)
        //        if shouldShowSearchResults == true
        //        {
        //            self.strSOSName = ((self.arrFilter[indexPath.row] as AnyObject).object(forKey:"Name") as? String)!
        //            self.strSOSContactNo = ((self.arrFilter[indexPath.row] as AnyObject).object(forKey:"Number") as? String)!
        //        }
        //        else
        //        {
        //            self.strSOSName = ((self.arrAllContacts[indexPath.row] as AnyObject).object(forKey:"Name") as? String)!
        //            self.strSOSContactNo = ((self.arrAllContacts[indexPath.row] as AnyObject).object(forKey:"Number") as? String)!
        //        }
        //        self.openContactsinAddFriend(strName: self.strSOSName, strContactNo: self.strSOSContactNo)
    }
    
    @objc func btnChat_Click(sender: UIButton!)
    {
        print("Button tapped")
        index = sender.tag - 100

        let strContactNo = ((self.arrAllContacts[index] as AnyObject).object(forKey:"Number") as? String)!
        //let objFriendInfo = UserDetailsModel.init(dictionary: self.arrAllMeshUserList[index] as! NSDictionary)
        //print("objFriendInfo: ", objFriendInfo!.userId!)
        
         let objChatVC = Constant.chatStoryboard.instantiateViewController(withIdentifier: "idChatVC") as! ChatVC
        
        objChatVC.isClickedContactVC = "true"
        objChatVC.strNewContactNo = strContactNo
        self.navigationController?.pushViewController(objChatVC, animated: true)
        
        //self.refDatabase = Database.database().reference()
    }
    
    @objc func btnInvite_Click(sender: UIButton!)
    {
        print("Button tapped")
    }
    
    //MARK:- Configure Search Controller
    
    func configureCustomSearchController()
    {        
//        let searchBar = UISearchBar(frame: CGRectZero)
//        navigationController?.navigationBar.addSubview(searchBar)
//        searchBar.setTranslatesAutoresizingMaskIntoConstraints(false)
        
//        let leftConstraint = NSLayoutConstraint(item: searchBar, attribute: .leading, relatedBy: .equal, toItem: navigationController?.navigationBar, attribute: .leading, multiplier: 1, constant: 20) // add margin
//
//        let bottomConstraint = NSLayoutConstraint(item: searchBar, attribute: .bottom, relatedBy: .equal, toItem: navigationController?.navigationBar, attribute: .bottom, multiplier: 1, constant: 1)
//
//        let topConstraint = NSLayoutConstraint(item: searchBar, attribute: .top, relatedBy: .equal, toItem: navigationController?.navigationBar, attribute: .top, multiplier: 1, constant: 1)
//
//        let widthConstraint = NSLayoutConstraint(item: searchBar, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.view.frame.size.width - 40) // - margins from both sides
//
//        navigationController?.navigationBar.addConstraints([leftConstraint, bottomConstraint, topConstraint, widthConstraint])
        print("customSearchController: ", customSearchController)
        
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect.zero, searchBarFont: UIFont(name: "TitiliumWeb", size: 14.0)!, searchBarTextColor: UIColor.black, searchBarTintColor: UIColor.white)
        
//        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: self.tblContactList.frame.size.width-100, height: 50.0), searchBarFont: UIFont(name: "TitiliumWeb", size: 14.0)!, searchBarTextColor: UIColor.black, searchBarTintColor: UIColor.white)
        customSearchController.customSearchBar.placeholder = "Enter here to search"
        self.viewSearch.addSubview(customSearchController.customSearchBar)
        //self.tblContacts.tableHeaderView = customSearchController.customSearchBar
        
        self.viewSearch.isHidden = false
        customSearchController.customDelegate = self
    }
    
    // MARK:- UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        self.tblContactList.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        self.tblContactList.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.tblContactList.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
    
    // MARK:- UISearchResultsUpdating delegate function
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        let searchPredicate: NSPredicate
        
        let onlyDigits: CharacterSet = CharacterSet.decimalDigits.inverted
        
        if searchString.rangeOfCharacter(from: onlyDigits) == nil
        {
            searchPredicate = NSPredicate(format: "Number CONTAINS[C] %@", searchString)
        }
        else
        {
            searchPredicate = NSPredicate(format: "Name CONTAINS[C] %@", searchString)
        }
        
        self.arrFilter = (self.arrAllContacts as NSArray).filtered(using: searchPredicate) as NSArray
        
        print ("array = \(self.arrFilter)")
        //predicate = [NSPredicate predicateWithFormat:@"room_type_id contains[cd] %@",str];
        //arrFilteredHotelsList = [self.arrHotelsList filteredArrayUsingPredicate:predicate];
        
        // Reload the tableview.
        self.tblContactList.reloadData()
    }
    
    
    // MARK: CustomSearchControllerDelegate functions
    
    func didStartSearching() {
        shouldShowSearchResults = true
        self.tblContactList.reloadData()
    }
    
    
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.tblContactList.reloadData()
        }
    }
    
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        customSearchController.customSearchBar.text = ""
        customSearchController.customSearchBar.placeholder = "Search in this awesome bar..."
        self.tblContactList.reloadData()
    }
    
    func didChangeSearchText(searchText: String)
    {
        let searchPredicate: NSPredicate
        let onlyDigits: CharacterSet = CharacterSet.decimalDigits.inverted        
        if searchText.rangeOfCharacter(from: onlyDigits) == nil
        {
            searchPredicate = NSPredicate(format: "Number CONTAINS[C] %@", searchText)
        }
        else
        {
            searchPredicate = NSPredicate(format: "Name CONTAINS[C] %@", searchText)
        }
        self.arrFilter = (self.arrAllContacts as NSArray).filtered(using: searchPredicate) as NSArray
        
        print ("array = \(self.arrFilter)")
        
        // Reload the tableview.
        self.tblContactList.reloadData()
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
                //let digits = contact.value(forKey: "digits") as? String
                //print("digits: ", digits!)
                
                let components =
                    phoneNumber!.components(separatedBy: CharacterSet.decimalDigits.inverted)
                let phone = components.joined()
                print("phone: ", phone)
                
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
            SaveAndFetchCoreData.savePhoneContactList(arrayContacts: self.contactsArray, strIsLogin: "0")
            let arrData = SaveAndFetchCoreData.getContactList()
            print("arrData: ", arrData)
            defaults.synchronize()
        }
    }
    
    @IBAction func btnSyncContacts_Click(_ sender: Any)
    {
        self.arrAllContacts = NSArray()
        self.displayAlContacts()
        
        let defaults = UserDefaults.standard
        self.arrAllContacts = defaults.object(forKey: "phone_contacts")! as! NSArray
        self.getContactListWhichAreOnMesh()
        //self.tblContactList.reloadData()
    }
    
     //MARK:- Invite User By Activity Lst View Controller
    func shareTheApp()
    {
        let text1 = String(format: "%@\n%@\n%@\n", "meshapp.com", "meshappchat.page.link", "Follow this link to join my networking group on Mesh App")
//        let text2 = "meshappchat.page.link\n"
//        let text3 = "Follow this link to join my networking group on Mesh App\n"
        //let image = UIImage(named: "Image")
        //let myWebsite = NSURL(string:"https://meshappchat.page.link/B4tU")
        let myWebsite = URL(string:"https://meshappchat.page.link/B4tU")
        let shareAll = [text1, myWebsite!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK:- Contact List Table View Cell Delegate Method
    
    func didPressInviteButton(_ tag: Int)
    {
       self.shareTheApp()
    }
}
