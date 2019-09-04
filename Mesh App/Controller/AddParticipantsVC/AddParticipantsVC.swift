//
//  AddParticipantsVC.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 02/01/2019.
//  Copyright © 2019 Swati. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import SwiftMessageBar
import FirebaseDatabase
import FirebaseAuth
import JGProgressHUD

class AddParticipantsVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var arrAllParticipantsList = NSMutableArray()
    var arrMeshUserList = NSArray()
     var arrFilter = NSMutableArray()
    var shouldShowSearchResults = false
    var strGroupId = String()
    var lastSelection: IndexPath!
    var arrNewParticipants = NSMutableArray()
    var dictGroupData = NSMutableDictionary()
    
    @IBOutlet weak var tblMeshContactList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        self.arrMeshUserList = defaults.object(forKey: "phone_contacts")! as! NSArray
        //self.arrNewParticipants.add(self.dictGroupData.value(forKey: "participants")!)
        self.arrNewParticipants = self.dictGroupData.value(forKey: "participants") as! NSMutableArray
        self.getMeshUserContactList()

        // Do any additional setup after loading the view.
    }
    
    func getMeshUserContactList()
    {
        let hud = JGProgressHUD(style: .dark)
        hud.indicatorView?.tintColor = Constant.MESH_BLUE
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        
        for i in 0..<self.arrMeshUserList.count
        {
            //let chatUserId = Auth.auth().currentUser?.uid
            let refMeshUserInfo = ChatConstants.refs.databaseUserInfo
            refMeshUserInfo.observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let msgDict = snap.value as? [String: AnyObject]
                    let msgUserDetails = snap.value as? NSDictionary
                    //print("msgDict: ", msgDict!["contact_no"]!)
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
                    self.tblMeshContactList.isHidden = false
                    self.tblMeshContactList.reloadData()
                })
            })
        }
    }
    
    //MARK: - Button Actions
    
    @IBAction func btnBack_Click(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSearch_Click(_ sender: Any) {
        
    }
    
    @IBAction func btnInviteViaLink_Click(_ sender: Any) {
        
    }
    @IBAction func btnAdd_Click(_ sender: Any)
    {
        //let userId = Auth.auth().currentUser?.uid
        //let userDetails = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kUserDetails)! as? UserDetailsModel
        //self.arrSelectedData.add(self.dictParticipantsInfo)
        //let strCurrentDate = Utils.getCurrentDateAndTimeInFormat()
        let strModifiedDate =  Utils.getCurrentDateAndTimeInFormatWithSeconds()
        
        let refDatabase = ChatConstants.refs.databaseChatInfo.child(self.strGroupId)
        
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            let dictData = NSMutableDictionary()
            dictData.setValue(self.dictGroupData.value(forKey: "created_By"), forKey: "created_By")
            dictData.setValue(self.dictGroupData.value(forKey: "created_on"), forKey: "created_on")
            dictData.setValue(self.strGroupId, forKey: "group_id")
            dictData.setValue(self.dictGroupData.value(forKey: "group_name"), forKey: "group_name")
            dictData.setValue(self.dictGroupData.value(forKey: "group_icon"), forKey: "group_icon")
            dictData.setValue(self.dictGroupData.value(forKey: "group_description"), forKey: "group_description")
            dictData.setValue(String(self.arrNewParticipants.count), forKey: "participant_count")
            dictData.setValue(ServerValue.timestamp() as! [String: AnyObject], forKey: "modified_on")
            //dictData.setValue(self.dictGroupData.value(forKey: "created_By"), forKey: "participants")
            dictData.setValue("1", forKey: "type")
            
            dictData.setValue(self.arrNewParticipants, forKey: "participants")
            let childUpdates = dictData
            refDatabase.updateChildValues(childUpdates as! [AnyHashable : Any])
            
            // self.refDatabase.child("GroupInfo").child(userId!).setValue(self.dictNewGroupInfo)
            let alertController = UIAlertController(title: kAppName, message: "Participants added successfully", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
                //self.navigationController?.dismiss(animated: true, completion: nil)
                //let objChatListVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idChatListVC") as! ChatListVC
                //self.navigationController?.pushViewController(objChatListVC, animated: true)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        })
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
        let cellReuseIdentifier = "idAddParticipantsCell"
        let cell:AddParticipantsTableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! AddParticipantsTableViewCell?)!
        cell.selectionStyle = .none
        cell.imgProfile.image = UIImage(named: "gallery1")
        cell.imgProfile.layer.cornerRadius = 4.0
        cell.imgProfile.layer.masksToBounds = true
        cell.tag = indexPath.row
        cell.viewProfile.layer.cornerRadius = 4.0
        cell.viewProfile.layer.masksToBounds = true
        
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
        //let strParticipants = self.dictGroupData.value(forKey: "participants")
        cell.imgProfile.sd_setImage(with: URL(string:meshUserDetails!.userImage!), placeholderImage: UIImage(named: "gallery1"))
        // }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*if self.lastSelection != nil {
            self.tblMeshContactList.cellForRow(at: self.lastSelection)?.accessoryType = .none
        }*/
        
        self.tblMeshContactList.cellForRow(at: indexPath)?.accessoryType = .checkmark
        self.lastSelection = indexPath
        //self.tblMeshContactList.deselectRow(at: indexPath, animated: true)
        let meshUserDetails = UserDetailsModel.init(dictionary: (self.arrAllParticipantsList[indexPath.row] as? NSDictionary)!)
        let dictAddNewParticipants = NSMutableDictionary()
        dictAddNewParticipants.setValue(false, forKey: "is_Admin")
        dictAddNewParticipants.setValue(meshUserDetails!.userName!, forKey: "participant_name")
        dictAddNewParticipants.setValue(meshUserDetails!.phone!, forKey: "phone_number")
        dictAddNewParticipants.setValue(meshUserDetails!.userId!, forKey: "participant_id")
        dictAddNewParticipants.setValue(meshUserDetails!.userImage!, forKey: "participant_image")
        dictAddNewParticipants.setValue(meshUserDetails!.cityName!, forKey: "participant_location")
        dictAddNewParticipants.setValue(meshUserDetails!.fcmPushToken!, forKey: "fcm_push_token")
        dictAddNewParticipants.setValue(meshUserDetails!.shortBio!, forKey: "short_bio")
        
        self.arrNewParticipants.add(dictAddNewParticipants)
    }
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
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
        dictGroupCreatedUser.setValue("false", forKey: "is_Admin")
        dictGroupCreatedUser.setValue(meshUserDetails!.userName!, forKey: "participant_name")
        dictGroupCreatedUser.setValue(meshUserDetails!.phone!, forKey: "phone_number")
        dictGroupCreatedUser.setValue(meshUserDetails!.userId!, forKey: "participant_id")
        dictGroupCreatedUser.setValue(meshUserDetails!.userImage!, forKey: "participant_image")
        dictGroupCreatedUser.setValue(meshUserDetails!.cityName!, forKey: "participant_location")
        dictGroupCreatedUser.setValue(meshUserDetails!.fcmPushToken!, forKey: "fcm_push_token")
        //}
    } */

}
