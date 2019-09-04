//
//  CreateGroupVC.swift
//  Mesh App
//
//  Created by Mac admin on 03/10/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import SwiftMessageBar
import FirebaseDatabase
import FirebaseAuth
import JGProgressHUD

class CreateGroupVC: UIViewController, UITableViewDelegate,UITableViewDataSource,CNContactViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, DeleteParticipantsDelegate, menuViewDelegate
{
    @IBOutlet weak var tblCreateGroup: UITableView!
    @IBOutlet weak var createGroupCollectionView: UICollectionView!
    var contactStore = CNContactStore()
    @IBOutlet weak var viewCollectionList: UIView!
    
    var viewMenuXib : MenuView!
    var viewTransparent : UIView!
    
    @IBOutlet weak var viewParticipants: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var lblSelectedCount: UILabel!
    //var dictSelectedData = [String : Any]()
    
     //var dictSelectedData = NSMutableDictionary()
    var arrSelectedData = NSMutableArray()
    //var viewConstraints = NSLayoutConstraint()
    
    @IBOutlet weak var viewHeightConstraints: NSLayoutConstraint!
    
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    
    var customSearchController: CustomSearchController!
    
    var strParticipantName : String = ""
    var strParticipantContactNo : String = ""
    
    var arrFilter = NSArray()
    var arrUserImages = NSArray()
    var arrAllParticipantsList = NSMutableArray()
    var arrMeshUserList = NSArray()
    var index = Int()
    var lastSelection = NSIndexPath()
    var i = Int()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
         i = 0
        let defaults = UserDefaults.standard
        self.arrMeshUserList = defaults.object(forKey: "phone_contacts")! as! NSArray
        arrUserImages = ["pic1","pic2","pic3"]
        
        self.lblSelectedCount.text = String(format: "0/%d selected", self.arrMeshUserList.count)
        
//        self.tblCreateGroup.estimatedRowHeight = 100.0
//        self.tblCreateGroup.rowHeight = UITableViewAutomaticDimension
        
//        let hud = JGProgressHUD(style: .dark)
//        hud.textLabel.text = "Loading"
//        hud.show(in: self.view)
        
        self.tblCreateGroup.tableFooterView = UIView()
        removeTheCustomView()
        self.viewHeightConstraints.constant = 0
        self.viewHeightConstraints.priority = UILayoutPriority(rawValue: 999)
        self.viewParticipants.addConstraint(self.viewHeightConstraints)
        
        //print("Mesh Contacts: ", DefaultsValues.getCustomObjFromUserDefaults_(forKey: kMeshContactList)!)
        
        for i in 0..<self.arrMeshUserList.count
        {
            //let chatUserId = Auth.auth().currentUser?.uid
            let refMeshUserInfo = ChatConstants.refs.databaseUserInfo
            refMeshUserInfo.observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let msgDict = snap.value as? [String: AnyObject]
                    let msgUserDetails = snap.value as? NSDictionary
                    print("msgDict: ", msgDict!["contact_no"]!)
                    let strMeshUserContactNo = msgDict!["contact_no"] as? String
                    //let strMeshUserId = msgDict!["user_id"] as? String
                    let strPhoneContact = (self.arrMeshUserList[i] as AnyObject).object(forKey:"Number") as! String
                    if strMeshUserContactNo == strPhoneContact
                    {
                        self.arrAllParticipantsList.add(msgUserDetails!)
                        DefaultsValues.setCustomObjToUserDefaults(self.arrAllParticipantsList, forKey: kMeshContactList)
                    }
                }
                let deadlineTime = DispatchTime.now() + .seconds(2)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                    //hud.dismiss()
                    self.tblCreateGroup.isHidden = false
                    self.tblCreateGroup.reloadData()
                })
            })
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // MARK: - Button Actions
    
    @IBAction func btnSkipInvite_Click(_ sender: Any)
    {
        let objAddGroupSubjectVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idAddGroupSubjectVC") as! AddGroupSubjectVC
        objAddGroupSubjectVC.strIsClickedSkipAndInvite = "true"
//        objAddGroupSubjectVC.arrParticipantsData = self.arrSelectedData.mutableCopy() as! NSMutableArray
        self.navigationController?.pushViewController(objAddGroupSubjectVC, animated: true)
    }
    
    @IBAction func btnNext_Click(_ sender: Any)
    {
        if self.arrSelectedData.count == 0
        {
            SwiftMessageBar.showMessage(withTitle: "Please select atleast one participant as a group member", type: .error)
        }
        else
        {
            let objAddGroupSubjectVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idAddGroupSubjectVC") as! AddGroupSubjectVC
            objAddGroupSubjectVC.arrParticipantsData = self.arrSelectedData.mutableCopy() as! NSMutableArray
            self.navigationController?.pushViewController(objAddGroupSubjectVC, animated: true)
        }
    }
    
    @IBAction func btnMenu_Click(_ sender: Any)
    {       
        viewMenuXib = MenuView(frame: CGRect(x: self.lblSelectedCount.frame.size.width - 10, y: self.btnMenu.frame.origin.y + 10, width: 150, height: 200))
       viewTransparent = UIView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height))
        viewTransparent.backgroundColor = UIColor.black
        viewTransparent.alpha = 0.6
        self.view.addSubview(viewTransparent)
        self.view.addSubview(viewMenuXib)
        viewMenuXib.layer.cornerRadius = 5
        viewMenuXib.layer.masksToBounds = true
        viewMenuXib.backgroundColor = UIColor.white
        viewMenuXib.menuDelegate = self
        viewMenuXib.dropShadow()
    }
    
    @IBAction func btnSearch_Click(_ sender: Any)
    {
        
    }
    
    @IBAction func btnBack_Click(_ sender: Any)
    {
        UserDefaults.standard.setValue("Yes", forKey: "isBackTrue")
         self.navigationController?.popViewController(animated: true)
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
        else
        {
            return self.arrAllParticipantsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellReuseIdentifier = "idCreateGroupCell"
        let cell:CreateGroupTableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CreateGroupTableViewCell?)!
        cell.selectionStyle = .none
        cell.imgProfile.image = UIImage(named: "gallery1")
        cell.tag = indexPath.row
        
        /*if shouldShowSearchResults
        {
            if (self.arrFilter[indexPath.row] as AnyObject).object(forKey:"Name") as? String != ""
            {
                let strName = (self.arrFilter[indexPath.row] as AnyObject).object(forKey:"Name") as! String
                cell.lblName.text =  strName
            }
            else
            {
                let strName = (self.arrFilter[indexPath.row] as AnyObject).object(forKey:"Number") as! String
                cell.lblName.text = strName //(self.arrFilter[indexPath.row] as AnyObject).object(forKey:"Number") as? String
               // cell.lblTitleName.text = String(strFirstChar)
            }
        }
        else
        {*/
        let meshUserDetails = UserDetailsModel.init(dictionary: (self.arrAllParticipantsList[indexPath.row] as? NSDictionary)!)
        cell.lblName.text! = meshUserDetails!.userName!
        cell.imgProfile.sd_setImage(with: URL(string:meshUserDetails!.userImage!), placeholderImage: UIImage(named: "gallery1"))
       // }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.removeTheCustomView()
        
        self.viewParticipants.isHidden = false
        
        self.viewHeightConstraints.constant = 88
        self.viewHeightConstraints.priority = UILayoutPriority(rawValue: 999)
        self.viewParticipants.addConstraint(self.viewHeightConstraints)
        
        var strSelectedContactNo = String()
        
        /*if shouldShowSearchResults == true
        {
            strSelectedContactNo = ((self.arrFilter[indexPath.row] as AnyObject).object(forKey:"Number") as? String)!
        }
        else
        {*/
            //strSelectedContactNo = ((self.arrAllParticipantsList[indexPath.row] as AnyObject).object(forKey:"Number") as? String)!
        
            let meshUserDetails = UserDetailsModel.init(dictionary: (self.arrAllParticipantsList[indexPath.row] as? NSDictionary)!)
            //strSelectedContactNo = meshUserDetails!.phone!
        let dictGroupCreatedUser = NSMutableDictionary()
        dictGroupCreatedUser.setValue(false, forKey: "is_Admin")
        dictGroupCreatedUser.setValue(meshUserDetails!.userName!, forKey: "participant_name")
        dictGroupCreatedUser.setValue(meshUserDetails!.phone!, forKey: "phone_number")
        dictGroupCreatedUser.setValue(meshUserDetails!.userId!, forKey: "participant_id")
        dictGroupCreatedUser.setValue(meshUserDetails!.userImage!, forKey: "participant_image")
        dictGroupCreatedUser.setValue(meshUserDetails!.cityName!, forKey: "participant_location")
        dictGroupCreatedUser.setValue(meshUserDetails!.fcmPushToken!, forKey: "fcm_push_token")
         dictGroupCreatedUser.setValue(meshUserDetails!.shortBio!, forKey: "short_bio")
        self.arrSelectedData.add(dictGroupCreatedUser)
        
        self.createGroupCollectionView.delegate = self
        self.createGroupCollectionView.dataSource = self
        self.createGroupCollectionView.isHidden = false
        self.createGroupCollectionView.reloadData()
        //}
        
        i = i + 1
        
        //let arrAllMsg = NSMutableArray()
        
        
        //need to check once
        
        /*let refChildPath = ChatConstants.refs.databaseUserInfo //self.refDatabase.child("UserInfo")
        let query = refChildPath.queryOrdered(byChild: "contact_no").queryEqual(toValue: strSelectedContactNo)
        
        query.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                print("snap.value: ", snap.value!)
                let msgDict = snap.value as? [String: AnyObject]
                arrAllMsg.add(msgDict!)
            }
            
            print("self.arrSelectedData: ", self.arrSelectedData)
            
            //self.lblSelectedCount.text = String(format: "%d/%d selected",i, self.arrAllParticipants.count)
            self.createGroupCollectionView.delegate = self
            self.createGroupCollectionView.dataSource = self
            self.createGroupCollectionView.isHidden = false
            self.createGroupCollectionView.reloadData()
        }, withCancel: nil)*/
    }
    
    //MARK:- Collection View Datasource and Delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {        
        return self.arrSelectedData.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell : CreateGroupCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "idCreateGroupCollectionCell", for: indexPath) as! CreateGroupCollectionViewCell
        
//        let imageString : String  = String.init(format: "%@", self.arrSelectedData[indexPath.item] as! CVarArg);
//        cell.imgParticipantsProfile.image = UIImage.init(named: "\(imageString)")
        
        //let imageString : String = ((self.followingArray[imageIndex] as AnyObject).object(forKey:"user_image") as? String)!
        cell.cellParticipantsDelegate = self
        
        cell.tag = indexPath.row        
        cell.imgParticipantsProfile.layer.cornerRadius = 4.0 //cell.imgParticipantsProfile.frame.size.height / 2
        cell.imgParticipantsProfile.layer.masksToBounds = true
        
        cell.btnDeleteParticipants.tag = indexPath.row
        cell.btnDeleteParticipants.layer.cornerRadius = cell.btnDeleteParticipants.frame.size.height / 2
        cell.btnDeleteParticipants.layer.masksToBounds = true
        let objParticipants = Participants.init(dictionary: (self.arrSelectedData[indexPath.row] as? NSDictionary)!)
        cell.lblSelParName.text = objParticipants!.participantsName
        cell.imgParticipantsProfile.sd_setImage(with: URL(string:objParticipants!.participantsImage!), placeholderImage: UIImage(named: "gallery1"))
//        cell.lblSelParName.text = (self.arrSelectedData[indexPath.row] as AnyObject).object(forKey:"Name") as? String
//        cell.imgParticipantsProfile.image = UIImage(named: "gallery1")
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //let imageString : String  = String.init(format: "%@", arrUserImages[indexPath.item] as! CVarArg);
    }
    
    // MARK:- Custom Delegate Methods
    
    func didDeleteCell_Click(_ tag: Int)
    {
        if self.arrSelectedData.count == 0
        {
            self.viewHeightConstraints.constant = 0
            self.viewHeightConstraints.priority = UILayoutPriority(rawValue: 999)
            self.viewParticipants.addConstraint(self.viewHeightConstraints)
        }
        
        self.arrSelectedData.removeObject(at: tag)
        i = i - 1        
        self.lblSelectedCount.text = String(format: "%d/%d selected",i, self.arrAllParticipantsList.count)
        print("arrSelectedData: ", self.arrSelectedData)
        self.createGroupCollectionView.reloadData()
    }
    
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
            let objCreateGroupVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idCreateGroupVC") as! CreateGroupVC
            self.navigationController?.pushViewController(objCreateGroupVC, animated: true)
        }
        else if index == 3
        {
            let objTermsAndPoliciesVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idTermsAndPoliciesVC") as! TermsAndPoliciesVC
            self.navigationController?.pushViewController(objTermsAndPoliciesVC, animated: true)
        }
    }
}
