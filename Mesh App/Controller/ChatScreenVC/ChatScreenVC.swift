//
//  ChatScreenVC.swift
//  Mesh App
//
//  Created by Mac admin on 26/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class ChatScreenVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var txtTypeMessage: UITextField!
    @IBOutlet weak var lblFriendName: UILabel!
    
    @IBOutlet weak var tblChatData: UITableView!
    
    @IBOutlet weak var viewMsgBottom: UIView!
    @IBOutlet weak var viewTop: UIView!
    var refDatabase: DatabaseReference!
    var arrSendMessages = NSMutableArray()
    var arrReceiveMessages = NSMutableArray()
    var dictFriendData = NSMutableDictionary()
    var strCurrentMsgTime : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("arrSendMessages: ", arrSendMessages)
        print("arrSendMessages.count: ", arrSendMessages.count)
        
        print("arrReceiveMessages: ", arrReceiveMessages)
        
        self.lblFriendName.text = dictFriendData.value(forKey: "friend_name") as? String
        
//        let paddingForFirst = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.txtTypeMessage.frame.size.height-5))
//        self.txtTypeMessage.leftView = paddingForFirst
//        self.txtTypeMessage.leftViewMode = UITextFieldViewMode .always
        self.txtTypeMessage.addPaddingLeft(16.0)
        
        let scale : Bool = true
        self.viewTop.layer.masksToBounds = false
        self.viewTop.layer.shadowColor = UIColor.black.cgColor
        self.viewTop.layer.shadowOpacity = 0.5
        self.viewTop.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.viewTop.layer.shadowRadius = 5
        
        self.viewTop.layer.shadowPath = UIBezierPath(rect: self.viewTop.bounds).cgPath
        self.viewTop.layer.shouldRasterize = true
        self.viewTop.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        
        self.viewMsgBottom.layer.masksToBounds = false
        self.viewMsgBottom.layer.shadowColor = UIColor.black.cgColor
        self.viewMsgBottom.layer.shadowOpacity = 0.5
        self.viewMsgBottom.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.viewMsgBottom.layer.shadowRadius = 5
        
        self.viewMsgBottom.layer.shadowPath = UIBezierPath(rect: self.viewMsgBottom.bounds).cgPath
        self.viewMsgBottom.layer.shouldRasterize = true
        self.viewMsgBottom.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func btnBack_Click(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }    
    
    @IBAction func btnInfo_Click(_ sender: Any)
    {
        
    }
    
    @IBAction func btnAddGroup_Click(_ sender: Any)
    {
        DefaultsValues.setStringValueToUserDefaults("YES", forKey: "plus_clicked")
        let objCreateGroupVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idCreateGroupVC") as! CreateGroupVC
        self.navigationController?.pushViewController(objCreateGroupVC, animated: true)
    }
    
    @IBAction func btnSendMsg_Click(_ sender: Any)
    {
        self.getCurrentDateAndTime()
        refDatabase = Database.database().reference()
        dictFriendData.setValue(self.txtTypeMessage.text!, forKey: "text_msg")
        let userId = Auth.auth().currentUser?.uid
        let strFriendId = dictFriendData.value(forKey: "friend_id")
        
        //let childKey = self.refDatabase.childByAutoId() ------> Imp (How to make a Dictionary with the help of Key on Firebase)
        //childKey.updateChildValues(childUpdates) ------> Imp (How to make a Dictionary with the help of Key on Firebase)
        //let childUpdates = ["/users/\(String(describing: key))": post, ------> Imp
        //"/user-posts/\(countryName)/\(String(describing: key))/": post] ------> Imp
        
        let key = self.refDatabase.childByAutoId().key
        dictFriendData.setValue(userId, forKey: "sender_id")
        dictFriendData.setValue(ServerValue.timestamp() as! [String: AnyObject], forKey: "message_time")
        
        let childUpdates = ["/OneToOneMessages/\(String(describing: userId!))/\(String(describing: strFriendId!))/\(String(describing: key!))": dictFriendData]
        refDatabase.updateChildValues(childUpdates)
        self.getRecentMessage()
        self.txtTypeMessage.text! = ""
    }
    
    @IBAction func btnAttachDoc_Click(_ sender: Any)
    {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionGallery = UIAlertAction(title: NSLocalizedString("Gallery", comment: ""), style: .default, handler: { _ in
        })
        let imageGallery = UIImage(named: "email")
        actionGallery.setValue(imageGallery?.withRenderingMode(.alwaysOriginal), forKey: "image")
        actionSheet.addAction(actionGallery)
        
        let actionCamera = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default, handler: { _ in
        })
        let imageCamera = UIImage(named: "email")
        actionCamera.setValue(imageCamera?.withRenderingMode(.alwaysOriginal), forKey: "image")
        actionSheet.addAction(actionCamera)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK:- UITextfield Delegate Methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        //let tag:Int = textField.tag
        print("textField.text!: ", textField.text!)
        return true
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool
//    {
//       return true
//    }
    
    /*func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (range.length == 0) {
            if textField.text == "\n" {
                textField.resignFirstResponder
                return false
            }
        }
        return false
    }*/
    
    // MARK: - Current Date And Time For Sending Messages
    
    func getCurrentDateAndTime()
    {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "h:mm a" //yyyy-MM-dd HH:mm
        let dateString = formatter.string(from: now)
        self.strCurrentMsgTime = dateString
    }
    
    // MARK: - Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        //return 100
        return ((tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath))?.contentView.frame.size.height)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrSendMessages.count
        //return self.arrAllContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellReuseIdentifier = "idChatScreenCell"
        let cell:ChatScreenTableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ChatScreenTableViewCell?)!
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    func getRecentMessage()
    {
        //self.dictFriendData.setValue(self.dictFriendData.value(forKey: "friend_name"), forKey: "friend_name")
        self.arrSendMessages = NSMutableArray()
        let loginUserId = Auth.auth().currentUser?.uid
        self.refDatabase = Database.database().reference()
        let strFriendId = self.dictFriendData.value(forKey: "friend_id")
        let allMessages = self.refDatabase.child("OneToOneMessages").child(loginUserId!).child(strFriendId as! String)
        allMessages.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                print("snap.value: ", snap.value!)
                let msgDict = snap.value as? [String: AnyObject]
                self.arrSendMessages.add(msgDict!)
            }
            print("arrAllMsg: ", self.arrSendMessages)
        })
        
       // let deadlineTime = DispatchTime.now() + .seconds(2)
        //DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.tblChatData.reloadData()
        //})
    }
}
