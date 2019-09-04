//
//  AddGroupSubjectVC.swift
//  Mesh App
//
//  Created by Mac admin on 03/10/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit
import CropViewController
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import JGProgressHUD
import SwiftMessageBar

class AddGroupSubjectVC: UIViewController,CropViewControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var txtViewGuidelines: UITextView!
    var strIsClickedSkipAndInvite : String = ""
    var coverView = UIView()
    var viewInviteLink = ViewInviteViaLink()
    var strGroupIconUrl : String = ""
    var strGroupUniqueKey : String = ""
    var isClickedEditGroupProfile = Bool()
    var dictGroupInfo = NSDictionary()
    @IBOutlet weak var viewTextView: UIView!
    var hud = JGProgressHUD()
    
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var imgGroupProfile: UIImageView!
    @IBOutlet weak var btnGroupProfile: UIButton!
    @IBOutlet weak var txtGroupSubject: UITextField!
    
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    //@IBOutlet weak var addGroupCollectionView: UICollectionView!
    @IBOutlet weak var btnGroupRules: UIButton!
    
    @IBOutlet weak var lblGroupRules: UILabel!
    @IBOutlet weak var viewGuide: UIView!
    var arrUserImages = NSArray()
    var arrParticipantsData = NSMutableArray()
    var dictParticipantsInfo = NSMutableDictionary()
    typealias FileCompletionBlock = () -> Void
    var block: FileCompletionBlock?
    
    var refDatabase: DatabaseReference!
    var dictNewGroupInfo = NSMutableDictionary()
    
    @IBOutlet var uploadDiscLBL: UILabel!
    @IBOutlet var imageSelect: UIImageView!
    @IBOutlet var UploadLbl2: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtViewGuidelines.text = "1. Avoid forwards not relevant to purpose of the Business Development. \n2. Use # tags to make messages relevant. "
        txtViewGuidelines.sizeToFit()
        self.UploadLbl2 .isHidden = true

        //self.txtViewGuidelines.layoutSubviews()
        
        self.imgGroupProfile.layer.cornerRadius = 4.0
        self.imgGroupProfile.layer.masksToBounds = true
        
        self.btnGroupProfile.layer.cornerRadius = 4.0
        self.btnGroupProfile.layer.masksToBounds = true

        // Do any additional setup after loading the view.
        arrUserImages = ["pic1","pic2","pic3","pic4","pic1","pic2","pic3","pic4","pic2","pic4"]
        print("self.arrParticipantsData: ", self.arrParticipantsData)
        if self.arrParticipantsData.count > 0
        {
            //self.addGroupCollectionView.reloadData()
        }
        
        if self.isClickedEditGroupProfile == true
        {
            self.txtGroupSubject.text = self.dictGroupInfo.value(forKey: "group_name") as? String
            self.txtViewGuidelines.text = self.dictGroupInfo.value(forKey: "group_description") as? String
            let strProfile = self.dictGroupInfo.value(forKey: "group_icon") as! String
            self.imgGroupProfile.sd_setImage(with: URL(string: strProfile), placeholderImage: UIImage(named: "gallery1"))
        }
        else
        {
            let key = Utils.randomString(length: 20) //self.refDatabase.childByAutoId().key
            strGroupUniqueKey = key
            self.dictNewGroupInfo.setValue("", forKey: "group_icon")
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
    
    //MARK:- Button Actions
    
    @IBAction func btnGroupProfile_Click(_ sender: UIButton)
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
            self.dismiss(animated: true, completion: nil)
        }))
    }
    
    func updateExistingGroupInfo()
    {
        //let userId = Auth.auth().currentUser?.uid
        hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        
        let arrPartList = self.dictGroupInfo.value(forKey: "participants") as! NSArray
        
        self.refDatabase = ChatConstants.refs.databaseChatInfo
        self.strGroupUniqueKey = self.dictGroupInfo.value(forKey: "group_id")! as! String
        
        //let deadlineTime = DispatchTime.now() + .seconds(2)
        //DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            //self.dictNewGroupInfo.setValue(userId!, forKey: "created_By")
            self.dictNewGroupInfo.setValue(self.dictGroupInfo.value(forKey: "created_By"), forKey: "created_By")
            self.dictNewGroupInfo.setValue(self.dictGroupInfo.value(forKey: "created_on"), forKey: "created_on")
            self.dictNewGroupInfo.setValue(self.strGroupUniqueKey, forKey: "group_id") //key
            self.dictNewGroupInfo.setValue(self.txtGroupSubject.text!, forKey: "group_name")
            self.dictNewGroupInfo.setValue(self.txtViewGuidelines.text, forKey: "group_description")
            self.dictNewGroupInfo.setValue(String(arrPartList.count), forKey: "participant_count")
            self.dictNewGroupInfo.setValue(ServerValue.timestamp() as! [String: AnyObject], forKey: "modified_on")
            self.dictNewGroupInfo.setValue(arrPartList, forKey: "participants")
            self.dictNewGroupInfo.setValue(self.dictGroupInfo.value(forKey: "type"), forKey: "type")
            
            let childUpdates = ["\(String(describing: self.strGroupUniqueKey))/groupInfo/": self.dictNewGroupInfo] //key
            self.refDatabase.updateChildValues(childUpdates)
        
            self.hud.dismiss()
            let alertController = UIAlertController(title: kAppName, message: "Group updated successfully", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                
                self.isClickedEditGroupProfile = false
                let objChatListVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idChatListVC") as! ChatListVC
                objChatListVC.strNewGroupCreated = "false"
                objChatListVC.dictNewGroupData = self.dictNewGroupInfo
                //DefaultsValues.setStringValueToUserDefaults(<#T##strValue: String?##String?#>, forKey:<#T##String?#>)
                self.navigationController?.pushViewController(objChatListVC, animated: true)
                //self.createAViewToShareLink()
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        //})
    }
    
    func addNewGroupDetails()
    {
        let userId = Auth.auth().currentUser?.uid
        
        let userDetails = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kUserDetails)! as? UserDetailsModel
        
        self.dictParticipantsInfo.setValue(true, forKey: "is_Admin")
        self.dictParticipantsInfo.setValue(userDetails!.userName!, forKey: "participant_name")
        self.dictParticipantsInfo.setValue(userDetails!.phone!, forKey: "phone_number")
        self.dictParticipantsInfo.setValue(userDetails!.fcmPushToken, forKey: "fcm_push_token")
        self.dictParticipantsInfo.setValue(userDetails!.userId!, forKey: "participant_id")
        self.dictParticipantsInfo.setValue(userDetails!.userImage!, forKey: "participant_image")
        self.dictParticipantsInfo.setValue(userDetails!.cityName!, forKey: "participant_location")
        self.dictParticipantsInfo.setValue(userDetails!.shortBio!, forKey: "short_bio")
        self.arrParticipantsData.add(self.dictParticipantsInfo)
        
        //self.arrSelectedData.add(self.dictParticipantsInfo)
        
        //let strCurrentDate = Utils.getCurrentDateAndTimeInFormat()
        //let strCurrentDate =  Utils.getCurrentDateAndTimeInFormatWithSeconds()
        self.refDatabase = ChatConstants.refs.databaseChatInfo //Database.database().reference()
//        let key = Utils.randomString(length: 20) //self.refDatabase.childByAutoId().key
//        strGroupUniqueKey = key
        
        //let refUserChatKeyPath = ChatConstants.refs.databaseUserInfo.child(userId!)
        
        let refAllMsgDatabase = ChatConstants.refs.databaseMessagesInfo
        
        //let deadlineTime = DispatchTime.now() + .seconds(2)
        //DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.dictNewGroupInfo.setValue(userId!, forKey: "created_By")
            self.dictNewGroupInfo.setValue(ServerValue.timestamp() as! [String: AnyObject], forKey: "created_on")
            self.dictNewGroupInfo.setValue(self.strGroupUniqueKey, forKey: "group_id") //key
            self.dictNewGroupInfo.setValue(self.txtGroupSubject.text!, forKey: "group_name")
            //self.dictNewGroupInfo.setValue(userDetails?.shortBio, forKey: "group_description")
            self.dictNewGroupInfo.setValue(self.txtViewGuidelines.text, forKey: "group_description")
            self.dictNewGroupInfo.setValue(String(self.arrParticipantsData.count), forKey: "participant_count")
            self.dictNewGroupInfo.setValue(ServerValue.timestamp() as! [String: AnyObject], forKey: "modified_on")
            self.dictNewGroupInfo.setValue(self.arrParticipantsData, forKey: "participants")
            self.dictNewGroupInfo.setValue("1", forKey: "type")
            
            let childUpdates = ["\(String(describing: self.strGroupUniqueKey))/groupInfo/": self.dictNewGroupInfo] //key
            self.refDatabase.updateChildValues(childUpdates)
            
            let dictionaryChatInfo = NSMutableDictionary()
            dictionaryChatInfo.setValue(self.strGroupUniqueKey, forKey: "") //key
            /*dictionaryChatInfo.setValue("", forKey: "receiver_id")
            dictionaryChatInfo.setValue(userId!, forKey: "user_id")*/
            
            //let childKeyUpdates = ["/chats/": dictionaryChatInfo]
            //refUserChatKeyPath.updateChildValues(childKeyUpdates)
            
            let allMsgKey = refAllMsgDatabase.childByAutoId().key
            
            let dictionaryAllMsg = NSMutableDictionary()
            dictionaryAllMsg.setValue("false", forKey: "is_reply")
            dictionaryAllMsg.setValue(allMsgKey, forKey: "message_id")
            //dictionaryAllMsg.setValue("", forKey: "reply_id")
            dictionaryAllMsg.setValue(ServerValue.timestamp() as! [String: AnyObject], forKey: "message_time")
            dictionaryAllMsg.setValue(userId, forKey: "sender_id")
            dictionaryAllMsg.setValue(userDetails!.userName, forKey: "sender_name")
            dictionaryAllMsg.setValue(userDetails!.userImage, forKey: "sender_image")
            dictionaryAllMsg.setValue(userDetails!.cityName, forKey: "sender_location")
//            dictionaryAllMsg.setValue(String(format: "created group \"%@\"", self.txtGroupSubject.text!), forKey: "text_msg")
            
            dictionaryAllMsg.setValue(String(format: "Group created"), forKey: "text_msg")
            
            dictionaryAllMsg.setValue(userDetails!.fcmPushToken!, forKey: "sender_fcm_push_token")
            dictionaryAllMsg.setValue(userDetails!.companyName!, forKey: "sender_company")
            dictionaryAllMsg.setValue(userDetails!.designation!, forKey: "sender_designation")
        
            let childAllMsgUpdates = ["\(String(describing: self.strGroupUniqueKey))/\(String(describing: allMsgKey!))/": dictionaryAllMsg] //key
            refAllMsgDatabase.updateChildValues(childAllMsgUpdates)
        
            for i in 0..<self.arrParticipantsData.count {
                let strUserId = ((self.arrParticipantsData[i] as AnyObject).value(forKey: "participant_id")) as? String
                let refLoginUserPath = ChatConstants.refs.databaseUserInfo.child(strUserId!)
                let childUserInfo = ["/chats/\(String(describing: self.strGroupUniqueKey))" : ""]
                refLoginUserPath.updateChildValues(childUserInfo)
            }
            self.hud.dismiss()
            // self.refDatabase.child("GroupInfo").child(userId!).setValue(self.dictNewGroupInfo)
            //let alertController = UIAlertController(title: kAppName, message: "Group created successfully", preferredStyle: .alert)
            
            //let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                if self.strIsClickedSkipAndInvite == "true"
                {
                    self.createAViewToShareLink()
                }
                else
                {
                    let objChatListVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idChatListVC") as! ChatListVC
                    objChatListVC.strNewGroupCreated = "true"
                    objChatListVC.dictNewGroupData = self.dictNewGroupInfo
                    self.navigationController?.pushViewController(objChatListVC, animated: true)
                    //self.createAViewToShareLink()
                }
            //}
            //alertController.addAction(okAction)
            //self.present(alertController, animated: true, completion: nil)
        //})
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
        viewInviteLink.lblGroupName.text = self.txtGroupSubject.text!
        viewInviteLink.lblGroupInviteLink.text = String(format: "Invite Link: https://mesh.page.link/GroupInvites?group_id=%@", self.strGroupUniqueKey)
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
        let text1 = String(format: "Follow this link to join my networking group on Mesh App \n")
        //        let text2 = "meshappchat.page.link\n"
        //        let text3 = "Follow this link to join my networking group on Mesh App\n"
        //let image = UIImage(named: "Image")
        //let myWebsite = NSURL(string:"https://meshappchat.page.link/B4tU")
        let strInviteUrl = String(format: "https://mesh.page.link/GroupInvites?group_id=%@", self.strGroupUniqueKey)
        let myWebsite = URL(string: strInviteUrl )
        let shareAll = [text1, myWebsite!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        coverView.removeFromSuperview()
        viewInviteLink.removeFromSuperview()
    }
    
    @IBAction func btnSkip_Click(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBack_Click(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDone_Click(_ sender: Any)
    {
        if self.txtGroupSubject.text == nil || self.txtGroupSubject.text == ""
        {
            SwiftMessageBar.showMessage(withTitle: "Please add group name", type: .error)
            return
        }
        hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        //let deadlineTime = DispatchTime.now() + .seconds(2)
        //DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
        connectedRef.observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.value as? Bool ?? false {
                    if self.isClickedEditGroupProfile == true{
                        self.updateExistingGroupInfo()
                    }
                    else
                    {
                        self.addNewGroupDetails()
                    }
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
        //})
    }
    
    @IBAction func btnGroupRules_Click(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        //var strRules = "\"Group Rules and Guidelines\" "
        var strRules = "Group Rules & Guidelines "
        self.lblGroupRules.textColor = Constant.MESH_BLUE
        
        if sender.isSelected
        {
            self.lblGroupRules.textColor = Constant.MESH_BLUE
//            strRules = "\"Group Rules and Guidelines\" \n\n  1. Avoid jokes or forwards not relevant to Business Developement. \n\n  2. Use # tags to make messages relevant. \n\n  3. For non business developement messages that ask for business help e.g:- if someone knows someone use #Help."
            self.txtViewGuidelines.text = ""
          //  self.txtViewGuidelines.text = "1. Avoid forwards not relevant to purpose of the Business Development. \n2. Use # tags to make messages relevant. "

            self.txtViewGuidelines.sizeToFit()
            //self.txtViewGuidelines.layoutSubviews()
          //  self.txtViewGuidelines.isHidden = true
            strRules = "Group Rules & Guidelines "//"\"Group Rules and Guidelines\""
            let myAttribute: [NSAttributedStringKey : Any] = [
                NSAttributedStringKey.foregroundColor: Constant.MESH_BLUE,
                NSAttributedStringKey.font: UIFont(name: "TitilliumWeb-Regular", size: 14.0)!]
            let attributedString1 = NSMutableAttributedString(string:strRules, attributes:myAttribute)
            
            
            /*let strRules2 = " \n\n  1. Avoid jokes or forwards not relevant to Business Developement. \n\n  2. Use # tags to make messages relevant. \n\n  3. For non business developement messages that ask for business help e.g:- if someone knows someone use #Help."
            
            let myAttributeTime: [NSAttributedStringKey : Any] = [
                NSAttributedStringKey.foregroundColor: UIColor.black,
                NSAttributedStringKey.font: UIFont(name: "TitilliumWeb-Regular", size: 14.0)!]
            
            let attributedString2 = NSMutableAttributedString(string:strRules2, attributes:myAttributeTime)
            
            attributedString1.append(attributedString2)*/
            
            self.lblGroupRules.attributedText! = attributedString1
            
            self.txtViewGuidelines .isHidden = true
            self.UploadLbl2 .isHidden = false
            self.uploadDiscLBL.isHidden = true
            imageSelect.image = UIImage(named: "right")

            
        }
        else
        {
            self.txtViewGuidelines .isHidden = false
            self.UploadLbl2 .isHidden = true
            self.uploadDiscLBL.isHidden = false
            imageSelect.image = UIImage(named: "bottom")

            
             self.txtViewGuidelines.text = ""
            // self.txtViewGuidelines.sizeToFit()
            //self.txtViewGuidelines.layoutSubviews()
            //self.txtViewGuidelines.isHidden = true
            self.lblGroupRules.textColor = Constant.MESH_BLUE
            strRules = "Group Rules & Guidelines "
            self.lblGroupRules.text! = strRules
            self.txtViewGuidelines.text = "1. Avoid forwards not relevant to purpose of the Business Development. \n2. Use # tags to make messages relevant. "

            self.txtViewGuidelines.sizeToFit()
            //self.txtViewGuidelines.layoutSubviews()
          //  self.txtViewGuidelines.isHidden = false
        }
        
        //self.lblGroupRules.text! = strRules
    }
    //MARK:- Collection View Datasource and Delegate
    
    /*func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
            return self.arrParticipantsData.count
            //return self.arrUserImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell : AddGroupSubjectCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "idAddSubjectCollectionCell", for: indexPath) as! AddGroupSubjectCollectionViewCell
        
        //let imageString : String  = String.init(format: "%@", self.arrUserImages[indexPath.item] as! CVarArg);
        //cell.imgAllParticipants.image = UIImage.init(named: "\(imageString)")
        
        print("name: %@", (self.arrParticipantsData[indexPath.row] as AnyObject).object(forKey:"participant_name") as! String)
        
        //let strName = (self.arrParticipantsData[indexPath.row] as AnyObject).object(forKey:"participant_name") as! String
        //let strFirstChar = strName.prefix(1);
        let objParticipants = Participants.init(dictionary: self.arrParticipantsData[indexPath.row] as! NSDictionary)
        cell.lblParticipantsName.text =  objParticipants?.participantsName
        
        //let imageString : String = ((self.followingArray[imageIndex] as AnyObject).object(forKey:"user_image") as? String)!
        
        cell.btnDeleteParticipants.tag = indexPath.row
        cell.btnDeleteParticipants.layer.cornerRadius = cell.btnDeleteParticipants.frame.size.height / 2
        cell.btnDeleteParticipants.layer.masksToBounds = true
        
        cell.imgAllParticipants.layer.cornerRadius = 4.0
        cell.imgAllParticipants.layer.masksToBounds = true
        cell.imgAllParticipants.sd_setImage(with: URL(string:objParticipants!.participantsImage!), placeholderImage: UIImage(named: "gallery1"))
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //let imageString : String  = String.init(format: "%@", arrUserImages[indexPath.item] as! CVarArg);
    }*/
    
    func uploadImage(forIndex index:Int, userImage : UIImage)
    {
        self.imgGroupProfile.image = userImage
        
        /// Perform uploading
        let data = UIImagePNGRepresentation(userImage)!
        let fileName = String(format: "%@.png", "yourUniqueFileName")
        
        FirebaseFile.shared.upload(data: data, withName: fileName, block: { (url) in
            print(url ?? "Couldn't not upload. You can either check the error or just skip this.")
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
        //var cropController = TOCropViewController(image: image)
        cropController.aspectRatioLockEnabled = true
        cropController.aspectRatioPickerButtonHidden = true
        cropController.aspectRatioPreset = .presetSquare
        
        cropController.delegate = self
        
        //self.imgGroupProfile.image = image
        
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
        
        //self.imgGroupProfile.image = image
        // layoutImageView()
        let strKey = String(format: "%@.jpg", strGroupUniqueKey)
        let storageRef = Constant.groupProfileStoragePath.child(strKey)
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading image...."
        hud.show(in: self.view)
        //let storageRef = Storage.storage().reference().child("GroupIcons").child(strKey)
        //let storageRef = Storage.storage(url: Constant.ServerFirebaseURL).reference().child("userProfileImages").child("myProfileImage.png")
        //self.imgGroupProfile.image = image
        if let uploadData = UIImagePNGRepresentation(image)
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
                    self.imgGroupProfile.image = image
                    print("profileImageURL: ",downloadURL.absoluteString)
                    self.strGroupIconUrl = downloadURL.absoluteString
                    
                    self.dictNewGroupInfo.setValue(downloadURL.absoluteString, forKey: "group_icon")
                    hud.dismiss()
                    self.btnDone.isHidden = false
                }
                print("metadata: ",metadata!)
            })
        }
        
        //self.uploadImage(forIndex: indexpath.row, userImage: cell.imgUserProfile.image!)
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        UserDefaults.standard.setCustomObject(UIImagePNGRepresentation(image), forKey: "group_image")
    }
    
    // Utility Method : base 64 String
    func encode(toBase64String image: UIImage?) -> String? {
        return UIImagePNGRepresentation(image!)?.base64EncodedString(options: .lineLength64Characters)
    }
}
