//
//  ChatGroupBubbleVC.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 04/12/2018.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ChatGroupBubbleVC: MessagesViewController, MessagesDataSource {
    
    //var messageOnessssss: MockMessage
    
    
    var messageOnessssss: MockMessage?
    var objAllMessages : AllMessages?
    var arrFullChatList = NSMutableArray()
    var messageList: [MockMessage] = []
    var newMessage : MockMessage?
    var dicFriendsAllData = NSMutableDictionary()
    var dicFinalSendData = NSMutableDictionary()
    var refDatabase: DatabaseReference!
    var userDetails: UserDetailsModel!
    var isClickedContactVC : String = ""
    var strNewContactNo: String = ""
    var strSendMessageId : String = ""
    var strGroupUniqueKey : String = ""
    var isFromChatListVC : String = ""
    
    var isReply : String =  ""
    var viewReplyContainer : MessageContainerView?
    var viewTransparent : UIView!

    //All New Keys According To New DB
    
    var objAllNewChatList : AllMessages?
    var objParticipants : Participants?
    var strReceiverName: String = ""
    var strReceiverImage: String = ""
    var strReceiverKey: String = ""
    var strSearchText : String = ""
    
    var currentSenderId : Sender?
    
    var isDataSearched : Bool?
    var arrGroupData = NSMutableArray()
    var dictData = NSMutableDictionary()
    var dictGroupInfo = NSDictionary()
    //var arrCommonMessages = NSMutableArray()
    
    @IBOutlet weak var viewMsgBottom: UIView!
    @IBOutlet weak var viewTop: UIView!
    
    private let messageCell = "idMessageCell"
    
    let refreshControl = UIRefreshControl()
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //NotificationCenter.default.addObserver(self, selector: #selector(fcmChatNotificationInfo(notification:)), name: .fcmNotification, object: nil)
        //NotificationCenter.default.add
        
        
        
        
       
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = UIColor.lightGray
        cameraItem.image = UIImage(named: "attachments")
        
        // 2
        cameraItem.addTarget(
            self,
            action: #selector(attachmentButtonPressed),
            for: .primaryActionTriggered
        )
        cameraItem.setSize(CGSize(width: 40, height: 40), animated: false)
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        
        // 3
        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
        
        configureMessageCollectionView()
        configureMessageInputBar()
        
        if self.isFromChatListVC == "true"
        {
           loadFirstMessages()
        }
        if self.isDataSearched == true
        {
            getGroupInfo()
            //loadFirstMessages()
        }
        
        //title = "Mesh App"
       // self.messagesCollectionView.scrollToBottom(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        //self.messagesCollectionView.scrollToBottom(animated: true)

        //self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getGroupInfo()
    {
        let refChatInfo = ChatConstants.refs.databaseChatInfo.child(self.strGroupUniqueKey)
        refChatInfo.observe(.childAdded, with: {snapshot in
            let msgGroupDict = snapshot.value as? NSDictionary
            print("msgGroupDict ", msgGroupDict!)
            //print("msgGroupDict: ", msgGroupDict!)
            //let strType = msgGroupDict!.value(forKey: "type") as! String
            let strGroupId = msgGroupDict!.value(forKey: "group_id") as! String
            self.arrGroupData.add(msgGroupDict!)
            self.dictGroupInfo = msgGroupDict!
            
                /*let childrens = msgGroupDict?.value(forKey: "participants") as! NSArray
                for child in  childrens {
                    let msgParticipantsDict = child as? NSDictionary
                    //let strCheckKey = msgParticipantsDict!.value(forKey: "participant_id") as! String
//                    if strCheckKey != chatUserId
//                    {
                        //arrPart.add(msgParticipantsDict!)
                        self.dictData.setValue(msgParticipantsDict, forKey: strGroupId)
                    //}
            }*/
        self.loadFirstMessages()
        }, withCancel: nil)
    }
    
    func getContactListData()
    {
        if self.isClickedContactVC == "true"
        {
            
        }
    }
    
    func configureMessageCollectionView()
    {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        
        //Changed value to false by Swati on 20 march
        scrollsToBottomOnKeyboardBeginsEditing = true //true // default false
        maintainPositionOnKeyboardFrameChanged = false // default false
         
        //messagesCollectionView.addSubview(refreshControl)
        
        //refreshControl.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
    }
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = Constant.primaryColor //.primaryColor
        messageInputBar.sendButton.tintColor = Constant.primaryColor //.primaryColor
    }
    
    func attrStringWithSearchText(objMessages: AllMessages) -> NSMutableAttributedString
    {
        let strMsg = objMessages.textMessage! as String
        
        let nsRange = NSString(string: strMsg).range(of: self.strSearchText as String, options: String.CompareOptions.caseInsensitive)
        var attributedString1 = NSMutableAttributedString()
        
        if nsRange.location != NSNotFound
        {
            let attributedSubString = NSAttributedString.init(string: NSString(string: strMsg).substring(with: nsRange), attributes: [NSAttributedStringKey.font : UIFont(name: "TitilliumWeb-Bold", size: 15.0)!, NSAttributedStringKey.foregroundColor:UIColor.lightGray, NSAttributedStringKey.backgroundColor: UIColor.yellow])
            let normalNameString = NSMutableAttributedString.init(string: String(format: "%@      ", strMsg))
            normalNameString.replaceCharacters(in: nsRange, with: attributedSubString)
            let strTimestamp = Utils.convertTimestamp(serverTimestamp: objMessages.messageTime!)
            var strLastSentMsg = strTimestamp.components(separatedBy: " ")
            //var strLastSentMsg = objMessages.messageTime!.components(separatedBy: " ")
            var strFullTime = String(format: "%@", strLastSentMsg[1])
            //strFullTime.removeLast(3)
            let strNewTime = String(format: "%@ %@", strFullTime, strLastSentMsg[2])
            
            let userId = Auth.auth().currentUser?.uid
            let myAttributeTime: [NSAttributedStringKey : Any]
            let myAttribute: [NSAttributedStringKey : Any]
            if userId == objMessages.senderId!
            {
                myAttribute = [
                    NSAttributedStringKey.foregroundColor: UIColor.white,
                    NSAttributedStringKey.font: UIFont(name: "TitilliumWeb-Regular", size: 16.0)!]
                
                myAttributeTime = [
                    NSAttributedStringKey.foregroundColor: UIColor.white,
                    NSAttributedStringKey.font: UIFont(name: "TitilliumWeb-Regular", size: 11.0)!]
            }
            else
            {
                myAttribute = [
                    NSAttributedStringKey.foregroundColor: UIColor.white,
                    NSAttributedStringKey.font: UIFont(name: "TitilliumWeb-Regular", size: 16.0)!]
                
                myAttributeTime = [
                    NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                    NSAttributedStringKey.font: UIFont(name: "TitilliumWeb-Regular", size: 11.0)!]
            }
            
            attributedString1 = normalNameString//NSMutableAttributedString(string:strFinalMsg, attributes:myAttribute)
            
            let attributedString2 = NSMutableAttributedString(string:strNewTime, attributes:myAttributeTime)
            
            attributedString1.append(attributedString2)
        }
        return attributedString1
    }
    
    func attributedStringWithTextAndTime(objMessages: AllMessages) -> NSMutableAttributedString
    {
        let strTimestamp = Utils.convertTimestamp(serverTimestamp: objMessages.messageTime!)
        var strLastSentMsg = strTimestamp.components(separatedBy: " ")
        let strFullTime = String(format: "%@", strLastSentMsg[1])
        let strNewTime = String(format: "%@ %@", strFullTime, strLastSentMsg[2])
        
        let strFinalMsg = String(format: "%@    ", objMessages.textMessage!)
        
        let strMsg = objMessages.textMessage! as String
        let nsRange = NSString(string: strMsg).range(of: self.strSearchText as String, options: String.CompareOptions.caseInsensitive)
        var attributedString1 = NSMutableAttributedString()
        //var attributedString2 = NSMutableAttributedString()
        
        let userId = Auth.auth().currentUser?.uid
        let myAttributeTime: [NSAttributedStringKey : Any]
        let myAttribute: [NSAttributedStringKey : Any]
        
        if userId == objMessages.senderId!
        {
            myAttribute = [
                NSAttributedStringKey.foregroundColor: UIColor.white,
                NSAttributedStringKey.font: UIFont(name: "TitilliumWeb-Regular", size: 16.0)!]
            
            myAttributeTime = [
                NSAttributedStringKey.foregroundColor: UIColor.white,
                NSAttributedStringKey.font: UIFont(name: "TitilliumWeb-Regular", size: 11.0)!]
        }
        else
        {
            myAttribute = [
                NSAttributedStringKey.foregroundColor: UIColor.white,
                NSAttributedStringKey.font: UIFont(name: "TitilliumWeb-Regular", size: 16.0)!]
            
            myAttributeTime = [
                NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                NSAttributedStringKey.font: UIFont(name: "TitilliumWeb-Regular", size: 11.0)!]
        }
        
        if nsRange.location != NSNotFound
        {
            let attributedSubString = NSAttributedString.init(string: NSString(string: strMsg).substring(with: nsRange), attributes: [NSAttributedStringKey.font : UIFont(name: "TitilliumWeb-Bold", size: 15.0)!, NSAttributedStringKey.foregroundColor:UIColor.lightGray, NSAttributedStringKey.backgroundColor: UIColor.yellow])
            let normalNameString = NSMutableAttributedString(string:String(format: "%@      ", strMsg), attributes:myAttribute)//NSMutableAttributedString.init(string: String(format: "%@      ", strMsg))
            normalNameString.replaceCharacters(in: nsRange, with: attributedSubString)
            
            attributedString1 = normalNameString//NSMutableAttributedString(string:strFinalMsg, attributes:myAttribute)
        }
        else
        {
            attributedString1 = NSMutableAttributedString(string:strFinalMsg, attributes:myAttribute)
        }
        
        let attributedString2 = NSMutableAttributedString(string:strNewTime, attributes:myAttributeTime)
        
        attributedString1.append(attributedString2)
        
        return attributedString1
    }
    
    func attributedStringWithAllData(objMessages: AllMessages) -> NSMutableAttributedString
    {
        let strTimestamp = Utils.convertTimestamp(serverTimestamp: objMessages.messageTime!)
        var strLastSentMsg = strTimestamp.components(separatedBy: " ")
        let strNewTime = String(format: "%@ %@", strLastSentMsg[1], strLastSentMsg[2])
        
        let strFinalMsg = String(format: "%@    ", objMessages.textMessage!)
        
        let strMsg = objMessages.textMessage! as String
        let nsRange = NSString(string: strMsg).range(of: self.strSearchText as String, options: String.CompareOptions.caseInsensitive)
        
        var attributedString1 = NSMutableAttributedString()
        
        let myAttribute: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.black,
            NSAttributedStringKey.font: UIFont(name: "TitilliumWeb-Regular", size: 16.0)!]
        let myAttributeTime: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.lightGray,
            NSAttributedStringKey.font: UIFont(name: "TitilliumWeb-Regular", size: 11.0)!]
        
        let attributedString0 = NSMutableAttributedString(string:String(format: "%@, %@ - %@\n", objMessages.senderName!, objMessages.senderDesignation!, objMessages.senderCompany!), attributes:myAttributeTime)
        
        if nsRange.location != NSNotFound
        {
            let attributedSubString = NSAttributedString.init(string: NSString(string: strMsg).substring(with: nsRange), attributes: [NSAttributedStringKey.font : UIFont(name: "TitilliumWeb-Bold", size: 15.0)!, NSAttributedStringKey.foregroundColor:UIColor.lightGray, NSAttributedStringKey.backgroundColor: UIColor.yellow])
            let normalNameString = NSMutableAttributedString(string:String(format: "%@      ", strMsg), attributes:myAttribute)//NSMutableAttributedString.init(string: String(format: "%@      ", strMsg))
            normalNameString.replaceCharacters(in: nsRange, with: attributedSubString)
            
            attributedString1 = normalNameString//NSMutableAttributedString(string:strFinalMsg, attributes:myAttribute)
        }
        else
        {
            attributedString1 = NSMutableAttributedString(string:strFinalMsg, attributes:myAttribute)
        }
        
        let attributedString2 = NSMutableAttributedString(string:String(format: "         %@", strNewTime), attributes:myAttributeTime)
        
        let attributedString3 = NSMutableAttributedString(string:String(format:"\n %@", objMessages.senderLocation!), attributes:myAttributeTime)

        attributedString0.append(attributedString1)
        attributedString3.append(attributedString2)
        attributedString0.append(attributedString3)
        
        return attributedString0
    }
    
    func loadFirstMessages()
    {
        //DispatchQueue.global(qos: .userInitiated).async {
        //var messagesInfo: [MockMessage] = []
        
        let refMsgInfo = ChatConstants.refs.databaseMessagesInfo.child(self.strGroupUniqueKey)
        refMsgInfo.observe(.childAdded, with: {snapshot in
            //refMsgInfo.observeSingleEvent(of: .value, with: {snapshot in
            //for child in snapshot.children {
            //let snap = child as! DataSnapshot
            let msgLastInfoDict = snapshot.value as? NSDictionary
            self.arrFullChatList.add(msgLastInfoDict!)
            
            self.objAllMessages  = AllMessages.init(dictionary:msgLastInfoDict!)!
            //let
            let userId = Auth.auth().currentUser?.uid
            var strAttributedText = NSMutableAttributedString()
            if userId == self.objAllMessages!.senderId!
            {
                strAttributedText = self.attributedStringWithTextAndTime(objMessages: self.objAllMessages!)
                
            }
            else
            {
                strAttributedText = self.attributedStringWithAllData(objMessages: self.objAllMessages!)
            }
            //let strMsgTime = self.objAllMessages!.messageTime!
            
            let strTimestamp = Utils.convertTimestamp(serverTimestamp: self.objAllMessages!.messageTime!)
            print("strMsgTime: ", strTimestamp)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            let msgDate = dateFormatter.date(from: strTimestamp)!
            
            if self.objAllMessages?.isReplyMsg == "true"
            {
                let strReplyMessage = String(format: "%@", (self.objAllMessages?.messageId!)!)
                let refReplyMsgInfo = refMsgInfo.child(strReplyMessage)
                refReplyMsgInfo.observeSingleEvent(of: .value, with: {snapshot in
                    
                    let dictReplyMsg = (snapshot.value as? NSDictionary)!
                    //let msgObject  = AllMessages.init(dictionary:dictReplyMsg)!
                    
                    print("Child Reply: ", dictReplyMsg as Any)
                    
                    let strReplyMsgName = String(format: "  %@ \n", "You")
                    
                    let strReplyTextMsg = String(format: "    %@\n", dictReplyMsg.value(forKey: "text_msg") as! CVarArg)
                    
                    let myAttribute: [NSAttributedStringKey : Any] = [
                        NSAttributedStringKey.foregroundColor: UIColor.black,
                        NSAttributedStringKey.font: UIFont(name: "TitilliumWeb-Regular", size: 16.0)!]
                    
                    var attr12 = NSMutableAttributedString(string: strReplyMsgName, attributes: myAttribute)
                    
                    // let strAttributedText = self.attributedStringWithTextAndTime(objMessages: self.objAllMessages!)
                    
                    //attr12 =  self.attributedString(with: strReply, normalString:self.objAllMessages?.messageTime!), highlightColor: UIColor.lightGray)
                    //                            attr12 = self.attributedString(with: strReplyMsgName, oldReplyMsg: strReplyTextMsg, normalString: strAttributedText, highlightColor: UIColor(red: 224/255, green: 248/255, blue: 255/255, alpha: 0.95))
                    
                    attr12 = self.attributedString(with: strReplyMsgName, normalString: strAttributedText, highlightColor: UIColor(red: 224/255, green: 248/255, blue: 255/255, alpha: 0.95))
                    
                    //                            attr12 = self.attributedString(with: strReplyMsgName, oldReplyMsg: strReplyTextMsg, normalString: strAttributedText, highlightColor: UIColor(red: 181/255, green: 44/255, blue: 77/255, alpha: 0.95))
                    
                    //                            attr12 = self.attributedString(with: attr12, normalString: strAttributedText , highlightColor: UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1.0))
                    
                    //attr12.append(attributedString2)
                    //print("attr12: ", attr12)
                    
                    let strName = String(format: "%@, %@ - %@ \n \n", self.objAllMessages!.senderName!, self.objAllMessages!.senderDesignation!, self.objAllMessages!.senderCompany!, attr12, self.objAllMessages!.senderLocation!)
                    
                    let message = MockMessage.init(text: strName, sender: Sender.init(id: (self.objAllMessages!.senderId)!, displayName: strName), messageId: (self.objAllMessages?.messageId)!, date: msgDate)
                    //messagesInfo.append(message)
                    self.insertMessage(message)
                }, withCancel: nil)
                
                /*let deadlineTime = DispatchTime.now() + .seconds(2)
                 DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                 self.messageList = messagesInfo
                 print("self.messageList: ",  self.messageList)
                 self.messagesCollectionView.reloadData()
                 self.messagesCollectionView.scrollToBottom()
                 })*/
            }
            else
            {
                /*let strName = String(format: "%@, %@-%@", self.objAllMessages!.senderName!, self.objAllMessages!.senderDesignation!, self.objAllMessages!.senderCompany!)
                 
                 let message = MockMessage.init(attributedText: strAttributedText, sender: Sender.init(id: (self.objAllMessages!.senderId)!, displayName: strName), messageId: (self.objAllMessages?.messageId)!, date: msgDate)*/
                
                /*let strName = String(format: "%@, %@-%@ \n%@  %@ \n%@", self.objAllMessages!.senderName!, self.objAllMessages!.senderDesignation!, self.objAllMessages!.senderCompany!, self.objAllMessages!.textMessage!, self.objAllMessages!.messageTime!, self.objAllMessages!.senderLocation!)
                 let myAttribute: [NSAttributedStringKey : Any] = [
                 NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                 NSAttributedStringKey.font: UIFont(name: "TitilliumWeb-Regular", size: 12.0)!]
                 let attrName = NSMutableAttributedString(string: strName, attributes: myAttribute)
                 let attrLocation = NSMutableAttributedString(string: strName, attributes: myAttribute)*/
                
                let message = MockMessage.init(attributedText: strAttributedText, sender: Sender.init(id: (self.objAllMessages!.senderId)!, displayName: self.objAllMessages!.senderName!), messageId: (self.objAllMessages?.messageId)!, date: msgDate)
                if self.strSendMessageId != self.objAllMessages!.messageId!
                {
                    self.insertMessage(message)
                }
                
                /*messagesInfo.append(message)
                 
                 DispatchQueue.main.async {
                 self.messageList = messagesInfo
                 print("self.messageList: ",  self.messageList)
                 self.messagesCollectionView.reloadData()
                 self.messagesCollectionView.scrollToBottom()
                 }*/
            }
            //}
        }, withCancel: nil)
    }
    
    func loadReceiverMessages()
    {
        self.arrFullChatList = NSMutableArray.init()
        let refMsgInfo = ChatConstants.refs.databaseMessagesInfo.child(self.strGroupUniqueKey).queryLimited(toLast: 1)
        refMsgInfo.observe(.value, with: {snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let msgLastInfoDict = snap.value as? NSDictionary
                self.arrFullChatList.add(msgLastInfoDict!)
                print("self.arrFullChatList: ", self.arrFullChatList)
                
                //self.objAllMessages  = AllMessages.init(dictionary:msgLastInfoDict!)!
                let objAllMsg: AllMessages = AllMessages.init(dictionary:msgLastInfoDict!)!
                let strAttributedText = self.attributedStringWithTextAndTime(objMessages: objAllMsg)
                
                let messages = MockMessage.init(attributedText: strAttributedText, sender: Sender.init(id: (objAllMsg.senderId)!, displayName: (objAllMsg.senderName)!), messageId: "", date: NSDate() as Date)
                //self.messageList.insert(messages, at: 0)
                self.insertMessage(messages)
                
                //self.messageList.insert(messageList, at: 0)
                //self.messagesCollectionView.reloadDataAndKeepOffset()
                //self.refreshControl.endRefreshing()
                
                /*DispatchQueue.main.async {
                 self.messageList = messagesInfo
                 print("self.messageList: ",  self.messageList)
                 self.messagesCollectionView.reloadData()
                 self.messagesCollectionView.scrollToBottom()
                 }*/
            }
        }, withCancel: nil)
    }
    
    @objc func loadMoreMessages()
    {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            DispatchQueue.main.async {
                
                let refMsgInfo = ChatConstants.refs.databaseMessagesInfo.child(self.strGroupUniqueKey)
                refMsgInfo.observe(.value, with: {snapshot in
                    for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        let msgLastInfoDict = snap.value as? NSDictionary
                        self.arrFullChatList.add(msgLastInfoDict!)
                        print("self.arrFullChatList: ", self.arrFullChatList)
                        
                        //self.objAllMessages  = AllMessages.init(dictionary:msgLastInfoDict!)!
                        let objAllMsg: AllMessages = AllMessages.init(dictionary:msgLastInfoDict!)!
                        let strAttributedText = self.attributedStringWithTextAndTime(objMessages: objAllMsg)
                        
                        let messages = MockMessage.init(attributedText: strAttributedText, sender: Sender.init(id: (objAllMsg.senderId)!, displayName: (objAllMsg.senderName)!), messageId: "", date: NSDate() as Date)
                        self.messageList.insert(messages, at: 0)
                        //self.messageList.insert(messageList, at: 0)
                        self.messagesCollectionView.reloadDataAndKeepOffset()
                        self.refreshControl.endRefreshing()
                        
                        /*DispatchQueue.main.async {
                         self.messageList = messagesInfo
                         print("self.messageList: ",  self.messageList)
                         self.messagesCollectionView.reloadData()
                         self.messagesCollectionView.scrollToBottom()
                         }*/
                    }
                }, withCancel: nil)
            }
        }
    }
    
    // MARK: - Helpers
    
    /*private func insertNewMessage(_ message: MockMessage) {
        guard !messageList.contains(where: message) else {
            return
        }
        
        messageList.append(message)
        //messages.sort()
        
        let isLatestMessage = messageList.index(of: message) == (messageList.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
        
        messagesCollectionView.reloadData()
        
        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }*/
    
    func insertMessage(_ message: MockMessage)
    {
     //   print("Message List before: ", messageList.count)
        //self.arrFullChatList.add(message)
        messageList.append(message)
        //print("Message List: ", messageList)
       // print("Message List after: ", messageList.count)
        
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messageList.count - 1])
            if messageList.count >= 2 {
                messagesCollectionView.reloadSections([messageList.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
        
    }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messageList.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    @objc private func attachmentButtonPressed(sender: UIButton)
    {
        sender.tintColor = Constant.MESH_BLUE
        /*let picker = UIImagePickerController()
         picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
         
         if UIImagePickerController.isSourceTypeAvailable(.camera) {
         picker.sourceType = .camera
         } else {
         picker.sourceType = .photoLibrary
         }
         
         present(picker, animated: true, completion: nil)*/
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actionCamera = UIAlertAction(title: "Camera", style: .default, handler: { action in
            //Do some thing here
            actionSheet.dismiss(animated: true)
            
        })
        
        let actionPhotoVideo = UIAlertAction(title: "Photo & Video Library", style: .default, handler: { action in
            //Do some thing here
            actionSheet.dismiss(animated: true)
            
        })
        
        let actionDocument = UIAlertAction(title: "Document", style: .default, handler: { action in
            //Do some thing here
            actionSheet.dismiss(animated: true)
            
        })
        
        let actionLocation = UIAlertAction(title: "Location", style: .default, handler: { action in
            //Do some thing here
            actionSheet.dismiss(animated: true)
            
        })
        
        let actionContact = UIAlertAction(title: "Contact", style: .default, handler: { action in
            //Do some thing here
            actionSheet.dismiss(animated: true)
            
        })
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        let image1 = UIImage(named: "camera")
        actionCamera.setValue(image1, forKey: "image")
        
        let image2 = UIImage(named: "photos")
        actionPhotoVideo.setValue(image2, forKey: "image")
        
        let image3 = UIImage(named: "document")
        actionDocument.setValue(image3, forKey: "image")
        
        let image4 = UIImage(named: "location_share")
        actionLocation.setValue(image4, forKey: "image")
        
        let image5 = UIImage(named: "contact")
        actionContact.setValue(image5, forKey: "image")
        
        actionSheet.addAction(actionCamera)
        actionSheet.addAction(actionPhotoVideo)
        actionSheet.addAction(actionDocument)
        actionSheet.addAction(actionLocation)
        actionSheet.addAction(actionContact)
        
        actionSheet.addAction(actionCancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - MessagesDataSource
    
    func currentSender() -> Sender
    {
        userDetails = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kUserDetails) as? UserDetailsModel
        let loginUser = Sender(id: userDetails!.userId!, displayName: userDetails!.userName!)
        //let userID = Auth.auth().currentUser?.uid
        return loginUser
        
        //return SampleData.shared.currentSender
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        //return self.objOneToOneChat.count
       // print("messageList in number of Sections: ", messageList.count)
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType
    {
        //return self.objOneToOneChat[indexPath.section] as! MessageType
        /*if strSendMessageId != ""
        {
            indexPath.section = messageList.count - 1
        }*/
        return messageList[indexPath.section] as MessageType
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?
    {
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
    func sendFullDetailsOfSelectedUser(strSelectedContactNo: String)
    {
        let arrAllMsg = NSMutableArray()
        
        let refChildPath = ChatConstants.refs.databaseUserInfo//self.refDatabase.child("UserInfo")
        let query = refChildPath.queryOrdered(byChild: "contact_no").queryEqual(toValue: strSelectedContactNo)
        
        query.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                print("snap.value: ", snap.value!)
                let msgDict = snap.value as? [String: AnyObject]
                arrAllMsg.add(msgDict!)
            }
            print("arrAllMsg: ", arrAllMsg)
            print("user_id: ", ((arrAllMsg[0] as AnyObject).value(forKey: "user_id"))!)
        }, withCancel: nil)
        
        //let deadlineTime = DispatchTime.now() + .seconds(2)
        //DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            
            let key = Utils.randomString(length: 20) //self.refDatabase.childByAutoId().key
            DefaultsValues.setStringValueToUserDefaults(key, forKey: kReceiverChatKey)
            let dictChatUserInfo = NSMutableDictionary()
            let dictParticipantsInfo = NSMutableDictionary()
            let dictParticipantsSecond = NSMutableDictionary()
            let arrParticipantsList = NSMutableArray()
            let userId = Auth.auth().currentUser?.uid
            
            let userDetails = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kUserDetails)! as? UserDetailsModel
            
            dictParticipantsInfo.setValue(true, forKey: "is_Admin")
            dictParticipantsInfo.setValue(userDetails!.userName!, forKey: "participant_name")
            dictParticipantsInfo.setValue(userDetails!.phone!, forKey: "phone_number")
            dictParticipantsInfo.setValue(userId!, forKey: "participant_id")
            dictParticipantsInfo.setValue(userDetails!.userImage!, forKey: "participant_image")
            dictParticipantsInfo.setValue(userDetails!.cityName!, forKey: "participant_location")
            dictParticipantsInfo.setValue(userDetails!.fcmPushToken!, forKey: "fcm_push_token")
            dictParticipantsInfo.setValue(userDetails!.shortBio!, forKey: "short_bio")
        
            arrParticipantsList.add(dictParticipantsInfo)
            
            dictParticipantsSecond.setValue(true, forKey: "is_Admin")
        
        
        if arrAllMsg.count == 0{
            
            return
        }
        
            dictParticipantsSecond.setValue(((arrAllMsg[0] as AnyObject).value(forKey: "user_name"))!, forKey: "participant_name")
            dictParticipantsSecond.setValue(((arrAllMsg[0] as AnyObject).value(forKey: "contact_no"))!, forKey: "phone_number")
            dictParticipantsSecond.setValue(((arrAllMsg[0] as AnyObject).value(forKey: "user_id"))!, forKey: "participant_id")
            dictParticipantsSecond.setValue(((arrAllMsg[0] as AnyObject).value(forKey: "image"))!, forKey: "participant_image")
            dictParticipantsSecond.setValue(((arrAllMsg[0] as AnyObject).value(forKey: "city_name"))!, forKey: "participant_location")
            dictParticipantsSecond.setValue(((arrAllMsg[0] as AnyObject).value(forKey: "fcm_push_token"))!, forKey: "fcm_push_token")
            dictParticipantsSecond.setValue(((arrAllMsg[0] as AnyObject).value(forKey: "short_bio"))!, forKey: "short_bio")
            
            arrParticipantsList.add(dictParticipantsSecond)
            
            dictChatUserInfo.setValue("", forKey: "created_By")
            dictChatUserInfo.setValue(ServerValue.timestamp() as! [String: AnyObject], forKey: "created_on")
            dictChatUserInfo.setValue(key, forKey: "group_id")
            dictChatUserInfo.setValue("", forKey: "group_name")
            dictChatUserInfo.setValue("", forKey: "group_description")
            dictChatUserInfo.setValue(String(arrParticipantsList.count), forKey: "participant_count")
            dictChatUserInfo.setValue(ServerValue.timestamp() as! [String: AnyObject], forKey: "modified_on")
            dictChatUserInfo.setValue(arrParticipantsList, forKey: "participants")
            dictChatUserInfo.setValue("0", forKey: "type")
            
            print("dictChatUserInfo: ", dictChatUserInfo)
            
            let childUpdates = ["/ChatInfo/\(String(describing: key))": dictChatUserInfo]
            self.refDatabase.updateChildValues(childUpdates)
            
            let dictionaryNew = NSMutableDictionary()
            dictionaryNew.setValue(((arrAllMsg[0] as AnyObject).value(forKey: "contact_no")), forKey: "receiver_phone")
            dictionaryNew.setValue(((arrAllMsg[0] as AnyObject).value(forKey: "user_id"))!, forKey: "receiver_id")
            dictionaryNew.setValue(userId!, forKey: "user_id")
            
            let childKeyUpdates = ["/ChatKeyInfo/\(String(describing: key))" : dictionaryNew]
            self.refDatabase.updateChildValues(childKeyUpdates)
        //})
    }

}

// MARK: - MessageCellDelegate

extension ChatGroupBubbleVC: MessageCellDelegate {
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else { return }
     //   guard let messagesDataSource = messagesCollectionView.messagesDataSource else { return }
        //let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        //print("message: ", message)
        //print("indexpath.row: ", indexPath.section)
        print("array: ", self.arrFullChatList[indexPath.section] as AnyObject)
        let objAllMsg = AllMessages.init(dictionary:self.arrFullChatList[indexPath.section] as! NSDictionary)!
        DefaultsValues.setStringValueToUserDefaults(objAllMsg.messageId!, forKey: kOnWhichMsgReplyId)
    
        self.createView(_message: objAllMsg)
    }
    
    func createView(_message: AllMessages)
    {
        viewReplyContainer = MessageContainerView.init(frame: CGRect(x: self.messageInputBar.frame.origin.x, y: -80, width: self.messageInputBar.frame.size.width, height: 80))
        viewReplyContainer!.backgroundColor = UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1)
        //viewReplyContainer?.isUserInteractionEnabled = true
        
        let viewFriendMsgInfo = UIView.init(frame: CGRect(x: 18, y: 10, width: self.messageInputBar.frame.size.width-60, height: 60))
        
        viewFriendMsgInfo.layer.cornerRadius = 4.0
        viewFriendMsgInfo.layer.masksToBounds = true
        
        let lblName = UILabel.init(frame: CGRect(x: viewFriendMsgInfo.frame.origin.x+12, y: viewFriendMsgInfo.frame.origin.y+2, width: self.messageInputBar.frame.size.width-80, height: 30))
        //lblName.backgroundColor = UIColor.yellow
        
        let btnCross = UIButton.init(frame: CGRect(x: viewFriendMsgInfo.frame.size.width+20, y: 20, width: 30, height: 30))
        //btnCross.backgroundColor = UIColor.red
        btnCross.setBackgroundImage(UIImage(named: "icon_reply_cross"), for: UIControlState.normal)
        //btnCross.backgroundColor = UIColor.red
        btnCross.addTarget(self, action: #selector(btnCross_Click(sender:)), for: .touchUpInside)
        // btnCross.addTarget(self, action: #selector(btnCross_Click), for: .touchUpInside)
        
        btnCross.tag = 22
        btnCross.isEnabled = true
        print("messages: ", _message)
        
        lblName.text = "You"
        lblName.textColor = Constant.MESH_BLUE
        lblName.font = UIFont(name: "TitilliumWeb-SemiBold", size: 16.0)
        
        let lblMessage = UILabel.init(frame: CGRect(x: viewFriendMsgInfo.frame.origin.x+15, y: lblName.frame.origin.y+25, width: self.messageInputBar.frame.size.width-80, height: 30))
        lblMessage.text =  _message.textMessage!
        lblMessage.font = UIFont(name: "TitilliumWeb-Regular", size: 12.0)
        viewFriendMsgInfo.backgroundColor = UIColor.white
        
        //lblMessage.backgroundColor = UIColor.blue
        
        let viewIndicator = UIView.init(frame: CGRect(x: 0, y: 0, width: 4, height:viewFriendMsgInfo.frame.size.height))
        viewIndicator.backgroundColor = Constant.MESH_BLUE
        viewFriendMsgInfo.addSubview(viewIndicator)
        //viewFriendMsgInfo.addSubview(btnCross)
        viewReplyContainer!.addSubview(viewFriendMsgInfo)
        self.messageInputBar.addSubview(viewReplyContainer!)
    
        viewTransparent = UIView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height))
        viewTransparent.backgroundColor = UIColor.clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.delegate = self as? UIGestureRecognizerDelegate // This is not required
        viewTransparent.addGestureRecognizer(tap)
        self.view.addSubview(viewTransparent)
        
        //viewReplyContainer!.addSubview(btnCross)
        
        viewReplyContainer!.addSubview(lblName)
        viewReplyContainer!.addSubview(lblMessage)
        messagesCollectionView.scrollToBottom(animated: true)
        messageInputBar.inputTextView.becomeFirstResponder()
        isReply = "true"
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer)
    {
        self.viewTransparent.removeFromSuperview()
        self.viewReplyContainer?.removeFromSuperview()
    }
    
    @objc func btnCross_Click(sender: UIButton)
    {
        print("asdfghjkjhvcxzcvbnmxcvbvcxdcfvbnm,")
        let btnsendtag:UIButton = sender
        if btnsendtag.tag == 22
        {
            if self.viewReplyContainer != nil
            {
                self.viewReplyContainer?.removeFromSuperview()
            }
        }
    }
    
   
    
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }
    
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }
    
    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }
    
}

// MARK: - MessageLabelDelegate

extension ChatGroupBubbleVC: MessageLabelDelegate {
    
    func didSelectAddress(_ addressComponents: [String: String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
    }
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {
        print("TransitInformation Selected: \(transitInformation)")
    }
    
    func getCurrentDateAndTime() -> String
    {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        //formatter.dateFormat = "h:mm a" //yyyy-MM-dd HH:mm
        let dateString = formatter.string(from: now)
        return dateString
    }
}

// MARK: - MessageInputBarDelegate

extension ChatGroupBubbleVC: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String)
    {
        refDatabase = Database.database().reference()
        
        //let childKey = self.refDatabase.childByAutoId() ------> Imp (How to make a Dictionary with the help of Key on Firebase)
        //childKey.updateChildValues(childUpdates) ------> Imp (How to make a Dictionary with the help of Key on Firebase)
        //let childUpdates = ["/users/\(String(describing: key))": post, ------> Imp
        //"/user-posts/\(countryName)/\(String(describing: key))/": post] ------> Imp
        
        
        let keyAutoId = self.refDatabase.childByAutoId().key
        self.strSendMessageId = keyAutoId!
        
        if self.messageList.count == 0
        {
            self.sendFullDetailsOfSelectedUser(strSelectedContactNo: self.strNewContactNo)
        }
        
        for component in inputBar.inputTextView.components
        {
            if let str = component as? String
            {
                let strTime =  Utils.getCurrentDateAndTimeInFormatWithoutSeconds()
                
                var strLastSentMsg = strTime.components(separatedBy: " ")
                let strNewTime = String(format: "%@ %@", strLastSentMsg[1], strLastSentMsg[2])
                
                //let strAttributedText = self.attributedStringWithTextAndTime(objMessages: self.objAllMessages!)
                
                let strFinalMsg = String(format: "%@    ", str)
                
                //if userDetails.userId
                
                let myAttribute: [NSAttributedStringKey : Any] = [
                    NSAttributedStringKey.foregroundColor: UIColor.white,
                    NSAttributedStringKey.font: UIFont(name: "TitilliumWeb-Regular", size: 16.0)!]
                
                let myAttributeTime: [NSAttributedStringKey : Any] = [
                    NSAttributedStringKey.foregroundColor: UIColor.white,
                    NSAttributedStringKey.font: UIFont(name: "TitilliumWeb-Regular", size: 11.0)!]
                
                let attributedString1 = NSMutableAttributedString(string:strFinalMsg, attributes:myAttribute)
                
                let attributedString2 = NSMutableAttributedString(string:strNewTime, attributes:myAttributeTime)
                
                attributedString1.append(attributedString2)
                
                if self.isReply == "true"
                {
                    let strReply = String(format: "%@ \n %@ \n", "You", str)
                    
                    var attr12 = NSMutableAttributedString(string: strReply, attributes: myAttribute)
                    
                    attr12 =  self.attributedString(with: strReply, normalString: attributedString1 , highlightColor: UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1.0))
                    
                    attr12.append(attributedString2)
                    
                    let message = MockMessage.init(attributedText: attr12, sender: Sender.init(id: (self.userDetails!.userId)!, displayName: (self.userDetails!.userName)!), messageId: keyAutoId!, date: Date())
                    if self.messageList.count == 0 //|| self.isClickedContactVC == "true"
                    {
                        self.insertMessage(message)
                    }
                }
                else
                {
                    //self.messageList = []
                     let strName = String(format: "%@  %@", self.userDetails!.userName!, self.userDetails!.cityName!)
                    let message = MockMessage(attributedText: attributedString1, sender: Sender.init(id: (self.userDetails!.userId)!, displayName: strName), messageId: keyAutoId!, date: Date())
                    
                    messageOnessssss = message
                    
                    //let message = MockMessage.init(attributedText: attributedString1, sender: Sender.init(id: (self.userDetails!.userId)!, displayName: strName), messageId: keyAutoId!, date: Date())
                    
                    //let message = MockMessage(text: str, sender: currentSender(), messageId: UUID().uuidString, date: Date())
                    
                    //let deadlineTime = DispatchTime.now() + .seconds(2)
                    //DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                    
                    //})
                }
               
            }
            /*else if let img = component as? UIImage
            {
                //let message = MockMessage(image: img, sender: self.currentSender(), messageId: UUID().uuidString, date: Date())
                //self.insertMessage(message)
            }*/
        //}
        
            self.userDetails = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kUserDetails) as? UserDetailsModel
            
            if self.isReply == "true"
            {
                self.dicFinalSendData.setValue(self.isReply, forKey: "is_reply")
                let strReplyId = DefaultsValues.getStringValueFromUserDefaults_(forKey: kOnWhichMsgReplyId)
                self.dicFinalSendData.setValue(strReplyId, forKey: "message_id")
            }
            else
            {
                self.isReply = "false"
                self.dicFinalSendData.setValue(self.isReply, forKey: "is_reply")
                self.dicFinalSendData.setValue(keyAutoId, forKey: "message_id")
            }
            self.dicFinalSendData.setValue(ServerValue.timestamp() as! [String: AnyObject], forKey: "message_time")
            
            self.dicFinalSendData.setValue(inputBar.inputTextView.text, forKey: "text_msg")
            
            self.dicFinalSendData.setValue(self.userDetails!.userId!, forKey: "sender_id")
            self.dicFinalSendData.setValue(self.userDetails!.userImage!, forKey: "sender_image")
            self.dicFinalSendData.setValue(self.userDetails!.userName!, forKey: "sender_name")
            self.dicFinalSendData.setValue(self.userDetails!.cityName!, forKey: "sender_location")
            self.dicFinalSendData.setValue(self.userDetails!.fcmPushToken!, forKey: "sender_fcm_push_token")
            self.dicFinalSendData.setValue(self.userDetails!.companyName!, forKey: "sender_company")
            self.dicFinalSendData.setValue(self.userDetails!.designation!, forKey: "sender_designation")
            
            self.arrFullChatList.add(self.dicFinalSendData)
            self.insertMessage(messageOnessssss!)
        }
            
            let refChildPath = ChatConstants.refs.databaseMessagesInfo
            refChildPath.observeSingleEvent(of: .value, with: { snapshot in
                let strRandomKey = self.strGroupUniqueKey
                
                let childUpdates = ["\(String(describing: strRandomKey))/\(String(describing: keyAutoId!))": self.dicFinalSendData]
                refChildPath.updateChildValues(childUpdates)
                //}
            })
        
        /*if self.viewReplyContainer != nil
        {
            self.viewReplyContainer?.removeFromSuperview()
            self.viewReplyContainer = nil
        }*/
        inputBar.inputTextView.text = String()
        self.messagesCollectionView.scrollToBottom(animated: true)        
    }
    
    func attributedString(with highlightString: String, normalString: NSAttributedString, highlightColor: UIColor) -> NSMutableAttributedString
    {
        //let attributes = [NSAttributedString.Key.backgroundColor: highlightColor]
        
        //UIColor(red: 181/255, green: 44/255, blue: 77/255, alpha: 1.0)
        let attributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor: Constant.MESH_BLUE,
            NSAttributedStringKey.font: UIFont(name: "TitilliumWeb-SemiBold", size: 17.0)!,
            NSAttributedStringKey.backgroundColor: highlightColor]
        //UIBezierPath(rounde)
        //String(format: "%@ \n %@ ", highlightString, oldReplyMsg)
        /*let runBounds = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 50)) //CGRectFromString(oldReplyMsg)
         let path = UIBezierPath(roundedRect: runBounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 3.0, height: 3.0))
         highlightColor.setFill()
         path.fill()*/
        
        let myAttributeTime: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.black,
            NSAttributedStringKey.font: UIFont(name: "TitilliumWeb-Regular", size: 11.0)!, NSAttributedStringKey.backgroundColor: highlightColor]
        
        //let attributedString = highlightString
        let attributedString = NSMutableAttributedString(string: highlightString, attributes: attributes)
       //let strOldMsg = NSMutableAttributedString(string: oldReplyMsg, attributes: myAttributeTime)
       // attributedString.append(strOldMsg)
        attributedString.append(normalString)
        //attributedString.append(NSAttributedString(string: normalString))
        
        return attributedString
    }
}

