//
//  ChatGroupVC.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 04/12/2018.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import MessageKit
import MessageInputBar
import MapKit

class ChatGroupVC: ChatGroupBubbleVC
{    
    var strGroupName : String = ""
    var strGroupImage : String = ""
    var arrParticipantsInfo = NSMutableArray()

    @IBOutlet weak var viewGroupNavigInfo: UIView!
    
    @IBOutlet weak var btnGroupImage: UIButton!
    @IBOutlet weak var lblGroupName: UILabel!
    
    let outgoingAvatarOverlap: CGFloat = 17.5
    var leftButton = UIButton()
    var rightButton = UIButton()
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
//        let userId = Auth.auth().currentUser?.uid
//        
//        for i in 0..<arrData.count {
//            let strParticipantId = ((self.arrParticipantsInfo[i]) as AnyObject).value(forKey: "participant_id") as! String
//            if strParticipantId == userId!
//            {
//                 self.arrParticipantsInfo.removeObject(at: i)
//            }
//        }
//        print("self.arrParticipantsInfo: ", arrParticipantsInfo)
        
        let scale : Bool = true
        self.viewGroupNavigInfo.layer.masksToBounds = false
        self.viewGroupNavigInfo.layer.shadowColor = UIColor.gray.cgColor
        self.viewGroupNavigInfo.layer.shadowOpacity = 0.5
        self.viewGroupNavigInfo.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.viewGroupNavigInfo.layer.shadowRadius = 2
        
        // self.viewChatInfo.layer.shadowPath = UIBezierPath(rect: self.viewChatInfo.bounds).cgPath
        self.viewGroupNavigInfo.layer.shouldRasterize = true
        self.viewGroupNavigInfo.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        
        /*self.lblGroupName.text = self.strGroupName
        let strImageURL = self.strGroupImage
        self.btnGroupImage.layer.cornerRadius = 4.0
        self.btnGroupImage.layer.masksToBounds = true
        self.btnGroupImage.layer.borderColor = UIColor.lightGray.cgColor
        self.btnGroupImage.layer.borderWidth = 1.0
        
        if strImageURL == ""
        {
            self.btnGroupImage.setBackgroundImage(UIImage(named: "gallery1"), for: UIControlState.normal)
        }
        else
        {
            self.btnGroupImage.sd_setBackgroundImage(with: URL(string:strImageURL), for: UIControlState.normal)
        }*/
        
//        messagesCollectionView = MessagesCollectionView(frame: .zero, collectionViewLayout: CustomMessagesFlowLayout())
//        messagesCollectionView.register(CustomCell.self)
        
        super.viewDidLoad()
        
        //updateTitleView(title: "Mesh App", subtitle: "2 Online")
    
       
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        self.viewGroupNavigInfo.isHidden = true
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        var arrLeftData = NSArray.init()
        arrLeftData = ["back_arrow", self.strGroupName];
        let arrLeftButton = self.setNavigationLeftButtonWithImageArray(arrLeftData)
        
        for i in 0..<arrLeftButton!.count {
            leftButton = arrLeftButton![i] as! UIButton
            leftButton.isExclusiveTouch = true
            leftButton.tag = i + 100
            //rightButton.addTarget(self, action: #selector(self.btnGroupInfo_Click(_:)), for: .touchUpInside)
        }
        
        var arrImageName = NSArray.init()
        let strImageURL = self.strGroupImage
        arrImageName = ["info", strImageURL];
        let arrRightButton = self.setNavigationRightButtonWithImageArray(arrImageName)
        
        for i in 0..<arrRightButton!.count {
            rightButton = arrRightButton![i] as! UIButton
            rightButton.isExclusiveTouch = true
            rightButton.tag = i + 200
            //rightButton.addTarget(self, action: #selector(self.btnGroupInfo_Click(_:)), for: .touchUpInside)
        }
        
        //let strGroupName = self.strGroupName
        //let leftButton: UIButton? = setNavigationLeftButtonWithImageTitle("back_arrow", strTitle: self.strGroupName)
        //leftButton?.addTarget(self, action: #selector(self.btnBack_Click(_:)), for: .touchUpInside)
    }
    
    func setNavigationLeftButtonWithImageTitle(_ imageName: String?,  strTitle: String?) -> UIButton?
    {
        let buttonContainer = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 44))
        let iconSize: Int = 18
        let leftButton = UIButton(frame: CGRect(x: 5, y: 15, width: CGFloat(iconSize), height: CGFloat(iconSize)))
        let leftImage = UIImage(named: imageName ?? "")
        buttonContainer.addSubview(leftButton)
        //buttonContainer.backgroundColor = UIColor.red
        let fixedspace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedspace.width = -15.0
        leftButton.setImage(leftImage, for: .normal)
        let backButtonItem = UIBarButtonItem(customView: buttonContainer)
        fixedspace.width = -15.0
        
        let buttonMeshTitle = UIButton.init(type: .custom)
        buttonMeshTitle.setTitle(strTitle, for: UIControlState.normal)
        buttonMeshTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left // UIControl.contentHorizontalAlignment.left
        buttonMeshTitle.frame = CGRect(x: leftButton.frame.size.width + 5, y: 16, width: 150, height: 30)
        buttonMeshTitle.setTitleColor(UIColor.black, for: UIControlState.normal)
        buttonMeshTitle.titleLabel?.font =  UIFont(name: "TitilliumWeb-Regular", size: 15)
        //buttonMeshTitle.backgroundColor = UIColor.red
        let barMeshTitle = UIBarButtonItem(customView: buttonMeshTitle)
        //fixedspace.width = -15.0
        
        navigationItem.leftBarButtonItems = [fixedspace, backButtonItem, barMeshTitle]
        return leftButton
    }
    
    func setNavigationLeftButtonWithImageArray(_ arrImageName: NSArray?) -> NSMutableArray?
    {
        let iconSize: Int = 34
        let arrBarButton = NSMutableArray()
        let buttonContainer = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        var i: Int = (arrImageName!.count == 1) ? 10 : 0
        
        var btnItem: UIButton?
        
        for btnTitle in arrImageName as? [String] ?? []
        {
            if i == 34
            {
                btnItem = UIButton(frame: CGRect(x: i - 10, y: 2, width: 150, height: 40))
                btnItem!.setTitle(btnTitle, for: UIControlState.normal)
                btnItem!.setTitleColor(UIColor.black, for: UIControlState.normal)
                btnItem!.titleLabel?.font =  UIFont(name: "TitilliumWeb-Regular", size: 15)
            }
            else
            {
                btnItem = UIButton(frame: CGRect(x: i, y: 3, width: iconSize, height: iconSize))
                btnItem!.setImage(UIImage(named: btnTitle), for: .normal)
                btnItem!.addTarget(self, action: #selector(self.btnBack_Click(_:)), for: .touchUpInside)
            }
            
            buttonContainer.addSubview(btnItem!)
            arrBarButton.add(btnItem!)
            i += iconSize
        }
        
        let fixedspace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedspace.width = (arrImageName!.count == 1) ? -0.0 : -15.0
        
        let backButtonItem = UIBarButtonItem(customView: buttonContainer)
        navigationItem.leftBarButtonItems = [fixedspace, backButtonItem]
        
        return arrBarButton
    }
    
    func setNavigationRightButtonWithImageArray(_ arrImageName: NSArray?) -> NSMutableArray?
    {
        let iconSize: Int = 34
        let arrBarButton = NSMutableArray()
        //let buttonContainer = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat((iconSize * (arrImageName!.count + 20))), height: 50))
        //buttonContainer.backgroundColor = UIColor.red
        
        let buttonContainer = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        
        var i: Int = (arrImageName!.count == 1) ? 10 : 0
        
        var btnItem: UIButton?
        
        for btnTitle in arrImageName as? [String] ?? [] {
            if i == 34
            {
                btnItem = UIButton(frame: CGRect(x: i + 25, y: 2, width: 40, height: 40))
                if btnTitle == ""
                {
                    btnItem!.setBackgroundImage(UIImage(named: "gallery1"), for: UIControlState.normal)
                    btnItem!.layer.cornerRadius = 4.0
                    btnItem!.layer.masksToBounds = true
                    btnItem!.layer.borderColor = UIColor.lightGray.cgColor
                    btnItem!.layer.borderWidth = 1.0
                }
                else
                {
                    btnItem!.sd_setBackgroundImage(with: URL(string:btnTitle), for: UIControlState.normal)
                    btnItem!.layer.cornerRadius = 4.0
                    btnItem!.layer.masksToBounds = true
                    btnItem!.layer.borderColor = UIColor.lightGray.cgColor
                    btnItem!.layer.borderWidth = 1.0
                }
            }
            else
            {
                btnItem = UIButton(frame: CGRect(x: i, y: 3, width: iconSize, height: iconSize))
                btnItem!.setImage(UIImage(named: btnTitle), for: .normal)
                btnItem!.addTarget(self, action: #selector(self.btnGroupInfo_Click(_:)), for: .touchUpInside)
            }
             buttonContainer.addSubview(btnItem!)
            arrBarButton.add(btnItem!)
            i += iconSize
        }
        let fixedspace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedspace.width = (arrImageName!.count == 1) ? -0.0 : -15.0
        
        let backButtonItem = UIBarButtonItem(customView: buttonContainer)
        navigationItem.rightBarButtonItems = [fixedspace, backButtonItem]
        
        return arrBarButton
    }
    
    func setAllButtonOnNavigationBar()
    {
        let buttonBack = UIButton.init(type: .custom)
        buttonBack.setImage(UIImage(named: "back_arrow"), for: UIControlState.normal)
        buttonBack.addTarget(self, action: #selector(btnBack_Click(_:)), for: UIControlEvents.touchUpInside)
        buttonBack.frame = CGRect(x: 16, y: 16, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: buttonBack)
        //self.navigationItem.leftBarButtonItem = barButton
        
        let buttonMeshTitle = UIButton.init(type: .custom)
        buttonMeshTitle.setTitle(self.strGroupName, for: UIControlState.normal)
        buttonMeshTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left // UIControl.contentHorizontalAlignment.left
        buttonMeshTitle.frame = CGRect(x: buttonBack.frame.size.width + 30, y: 16, width: 200, height: 30)
        buttonMeshTitle.setTitleColor(UIColor.black, for: UIControlState.normal)
        buttonMeshTitle.titleLabel?.font =  UIFont(name: "TitilliumWeb-Regular", size: 15)
        //buttonMeshTitle.backgroundColor = UIColor.red
        let barMeshTitle = UIBarButtonItem(customView: buttonMeshTitle)
        self.navigationItem.leftBarButtonItems = [barButton, barMeshTitle]
      
        let buttonInfo = UIButton.init(type: .custom)
        buttonInfo.setBackgroundImage(UIImage(named: "info"), for: UIControlState.normal)
        buttonInfo.addTarget(self, action: #selector(btnGroupInfo_Click(_:)), for: UIControlEvents.touchUpInside)
        buttonInfo.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        let barInfo = UIBarButtonItem(customView: buttonInfo)
        
        let spaceBtn = UIButton.init(type: .custom)
        spaceBtn.setBackgroundImage(UIImage(named: "ssdsds"), for: UIControlState.normal)
        spaceBtn.addTarget(self, action: #selector(btnGroupInfo_Click(_:)), for: UIControlEvents.touchUpInside)
          spaceBtn.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
        
        let barSpace = UIBarButtonItem(customView: spaceBtn)
        
        let buttonImage = UIButton.init(type: .custom)
        //buttonInfo.setImage(UIImage(named: "back"), for: UIControlState.normal)
        let strImageURL = self.strGroupImage
        buttonImage.layer.cornerRadius = 4.0
        buttonImage.layer.masksToBounds = true
        buttonImage.layer.borderColor = UIColor.lightGray.cgColor
        buttonImage.layer.borderWidth = 1.0
        
        //buttonImage.frame = CGRect(x: barInfo.accessibilityFrame.size.width + 20, y: 16, width: 25, height: 25)
        
        if strImageURL == ""
        {
            buttonImage.setBackgroundImage(UIImage(named: "gallery1"), for: UIControlState.normal)
        }
        else
        {
            buttonImage.sd_setBackgroundImage(with: URL(string:strImageURL), for: UIControlState.normal)
        }
        buttonImage.addTarget(self, action: #selector(btnBack1_Click(_:)), for: UIControlEvents.touchUpInside)
        buttonImage.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        let barImage = UIBarButtonItem(customView: buttonImage)
        //self.navigationItem.rightBarButtonItem = barInfo
        self.navigationItem.rightBarButtonItems = [barImage, barSpace,barInfo]
    }
    
    func navigationControllerItems()
    {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Load All Messages
    
    override func loadFirstMessages()
    {
        //DispatchQueue.global(qos: .userInitiated).async {
        //var messagesInfo: [MockMessage] = []
        
        let refMsgInfo = ChatConstants.refs.databaseMessagesInfo.child(self.strGroupUniqueKey)
        refMsgInfo.observe(.childAdded, with: {snapshot in
        //refMsgInfo.observeSingleEvent(of: .value, with: {snapshot in
            //for child in snapshot.children {
                //let snap = child as! DataSnapshot
                let msgLastInfoDict = snapshot.value as? NSDictionary
            
                self.objAllMessages  = AllMessages.init(dictionary:msgLastInfoDict!)!
            
            print(self.strSendMessageId)
            print(self.arrFullChatList)

            if self.strSendMessageId != self.objAllMessages!.messageId!
            {
                self.arrFullChatList.add(msgLastInfoDict!)
            }else{
                if self.strSendMessageId.isEmpty && self.self.objAllMessages!.messageId!.isEmpty{
                }else{
                    return
                }
            }
            
                //let
                let userId = Auth.auth().currentUser?.uid
                var strAttributedText = NSMutableAttributedString()
                if userId == self.objAllMessages!.senderId!
                {
//                    if self.isDataSearched == true
//                    {
//                        strAttributedText = self.attrStringWithSearchText(objMessages: self.objAllMessages!)
//                    }
//                    else
//                    {
                        strAttributedText = self.attributedStringWithTextAndTime(objMessages: self.objAllMessages!)
                    //}
                }
                else
                {
                    strAttributedText = self.attributedStringWithAllData(objMessages: self.objAllMessages!)
                }
                //let strMsgTime = self.objAllMessages!.messageTime!
            
                let strTimestamp = Utils.convertTimestamp(serverTimestamp: self.objAllMessages!.messageTime!)

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
                        
                    //    print("Child Reply: ", dictReplyMsg as Any)
                        
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
                        self.messagesCollectionView.scrollToBottom()
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
                    
//   saurabh                 if self.isFromChatListVC == "true"
//                    {
//                        //                    if self.strSendMessageId != self.objAllMessages!.messageId!
//                        //                    {
//
//
//                        self.insertMessage(message)
//                        self.messagesCollectionView.scrollToBottom()
//                        //     }
//                    }else{
//
//                      if self.strSendMessageId != self.objAllMessages!.messageId!
//                                        {
//                        self.insertMessage(message)
//                        self.messagesCollectionView.scrollToBottom()
//                             }
//                    }
                    
                    self.insertMessage(message)
                    self.messagesCollectionView.scrollToBottom()
                   
                    //messagesInfo.append(message)
                    
                    //DispatchQueue.main.async {
                        //self.messageList = messagesInfo
                        //print("self.messageList: ",  self.messageList)
                        //self.messagesCollectionView.reloadData()
                       
                        //self.messagesCollectionView.scrollToBottom()
                    //}
                }                
            //}
        }, withCancel: nil)
    }
    
    /*override func configureMessageCollectionView() {
        super.configureMessageCollectionView()
        
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 10, left: 8, bottom: 1, right: 8)
        
        // Hide the outgoing avatar and adjust the label alignment to line up with the messages
        layout?.setMessageOutgoingAvatarSize(.zero)
        layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
        layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
        
        // Set outgoing avatar to overlap with the message bubble
        layout?.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 18, bottom: outgoingAvatarOverlap, right: 0)))
        //layout?.setMessageIncomingAvatarSize(.zero)
        layout?.setMessageIncomingAvatarSize(CGSize(width: 35, height: 35))
        layout?.setMessageIncomingAvatarPosition(AvatarPosition(vertical: .cellTop))
        //layout?.setMessageIncomingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: outgoingAvatarOverlap + 25, bottom: 0, right: 0)))
        
        layout?.setMessageIncomingMessagePadding(UIEdgeInsets(top: -outgoingAvatarOverlap, left: -18, bottom: outgoingAvatarOverlap, right: 18))
        //layout?.setMessageIncomingMessagePadding(UIEdgeInsets(top: -outgoingAvatarOverlap, left: 5, bottom: 10, right: 18))
    
        //HERE Left me -18 tha Profile Image dikhane ke liye
        
        //layout?.setMessageIncomingAccessoryViewSize(CGSize(width: 30, height: 30))
        //layout?.setMessageIncomingAccessoryViewPadding(HorizontalEdgeInsets(left: 8, right: 0))
        //layout?.setMessageOutgoingAccessoryViewSize(CGSize(width: 30, height: 30))
        //layout?.setMessageOutgoingAccessoryViewPadding(HorizontalEdgeInsets(left: 0, right: 8))
        
        messagesCollectionView.backgroundColor = Constant.VERY_LIGHT_GRAY
        
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.addSubview(self.viewGroupNavigInfo)
    }*/
    
    
    override func configureMessageCollectionView() {
        super.configureMessageCollectionView()
        
        
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 10, left: 8, bottom: 1, right: 8)
        
        // Hide the outgoing avatar and adjust the label alignment to line up with the messages
        layout?.setMessageOutgoingAvatarSize(.zero)
        layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
        layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
        
        // Set outgoing avatar to overlap with the message bubble
        layout?.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 18, bottom: outgoingAvatarOverlap, right: 0)))
        layout?.setMessageIncomingAvatarSize(CGSize(width: 30, height: 30))
        layout?.setMessageIncomingMessagePadding(UIEdgeInsets(top: -outgoingAvatarOverlap, left: -18, bottom: outgoingAvatarOverlap, right: 18))
        
//        layout?.setMessageIncomingAccessoryViewSize(CGSize(width: 30, height: 30))
//        layout?.setMessageIncomingAccessoryViewPadding(HorizontalEdgeInsets(left: 8, right: 0))
//        layout?.setMessageOutgoingAccessoryViewSize(CGSize(width: 30, height: 30))
//        layout?.setMessageOutgoingAccessoryViewPadding(HorizontalEdgeInsets(left: 0, right: 8))
        
        messagesCollectionView.backgroundColor = Constant.VERY_LIGHT_GRAY
        
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        //messagesCollectionView.addSubview(self.viewGroupNavigInfo)
    }
        
    override func configureMessageInputBar()
    {
        super.configureMessageInputBar()
        
        messageInputBar.layer.masksToBounds = false
        messageInputBar.layer.shadowColor = UIColor.black.cgColor
        messageInputBar.layer.shadowOpacity = 0.5
        messageInputBar.layer.shadowOffset = CGSize(width: -1, height: 1)
        messageInputBar.layer.shadowRadius = 5
        
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.tintColor = Constant.primaryColor//.primaryColor
        messageInputBar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        messageInputBar.inputTextView.placeholderLabel.text = "Type here...."
        messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        messageInputBar.inputTextView.text = ""
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        configureInputBarItems()
    }
    
    private func configureInputBarItems() {
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
        //messageInputBar.sendButton.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        messageInputBar.sendButton.image = UIImage(named: "send")
        messageInputBar.sendButton.title = nil
        //messageInputBar.sendButton.imageView?.layer.cornerRadius = 16
        messageInputBar.textViewPadding.right = -38
        messageInputBar.textViewPadding.bottom = 8
        
        //**** To Add  limitation on the message text ****//
        
        /*let charCountButton = InputBarButtonItem()
         .configure {
         $0.title = "0/140"
         $0.contentHorizontalAlignment = .right
         $0.setTitleColor(UIColor(white: 0.6, alpha: 1), for: .normal)
         $0.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .bold)
         $0.setSize(CGSize(width: 50, height: 25), animated: false)
         }.onTextViewDidChange { (item, textView) in
         item.title = "\(textView.text.count)/140"
         let isOverLimit = textView.text.count > 140
         item.messageInputBar?.shouldManageSendButtonEnabledState = !isOverLimit // Disable automated management when over limit
         if isOverLimit {
         item.messageInputBar?.sendButton.isEnabled = false
         }
         let color = isOverLimit ? .red : UIColor(white: 0.6, alpha: 1)
         item.setTitleColor(color, for: .normal)
         }
         let bottomItems = [makeButton(named: "ic_at"), makeButton(named: "ic_hashtag"), makeButton(named: "ic_library"), .flexibleSpace, charCountButton]
         messageInputBar.textViewPadding.bottom = 8
         messageInputBar.setStackViewItems(bottomItems, forStack: .bottom, animated: false)*/
        
        // This just adds some more flare
        messageInputBar.sendButton
            .onEnabled { item in
                UIView.animate(withDuration: 0.3, animations: {
                    //item.imageView?.backgroundColor = Constant.primaryColor//.primaryColor
                })
            }.onDisabled { item in
                UIView.animate(withDuration: 0.3, animations: {
                    //item.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
                })
        }
    }
    
    //MARK:- Button Action
    
    @IBAction func btnGroupInfo_Click(_ sender: UIButton)
    {
        let objGroupViewProfileVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idGroupViewProfileVC") as! GroupViewProfileVC
        //objViewProfileVC.isClickedChatInfoButtonVC = "true"
        objGroupViewProfileVC.dictGroupFullInfo = self.dictGroupInfo
            print(self.dictGroupInfo)
        //let deadlineTime = DispatchTime.now() + .seconds(2)
        //DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
        self.navigationController?.pushViewController(objGroupViewProfileVC, animated: true)
        //})
    }
    
    @IBAction func btnBack_Click(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBack1_Click(_ sender: Any)
    {
        
    }
    
    // MARK: - Helpers
    
    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool
    {
        //return isPreviousMessageSameSender(at: indexPath)
        return indexPath.section % 3 == 0 && !isPreviousMessageSameSender(at: indexPath)
    }
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return messageList[indexPath.section].sender == messageList[indexPath.section - 1].sender
        
        //return true //Changed by Swati
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messageList.count else { return false }
        return messageList[indexPath.section].sender == messageList[indexPath.section + 1].sender
        
        //return true //Changed by Swati
    }
    
    func setTypingIndicatorHidden(_ isHidden: Bool, performUpdates updates: (() -> Void)? = nil) {
        /*updateTitleView(title: "Mesh App", subtitle: isHidden ? "2 Online" : "Typing...")
         setTypingBubbleHidden(isHidden, animated: true, whilePerforming: updates) { [weak self] (_) in
         if self?.isLastSectionVisible() == true {
         self?.messagesCollectionView.scrollToBottom(animated: true)
         }
         }
         messagesCollectionView.scrollToBottom(animated: true)*/
    }
    
    private func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                $0.setSize(CGSize(width: 25, height: 25), animated: false)
                $0.tintColor = UIColor(white: 0.8, alpha: 1)
            }.onSelected {
                $0.tintColor = Constant.primaryColor//.primaryColor
            }.onDeselected {
                $0.tintColor = UIColor(white: 0.8, alpha: 1)
            }.onTouchUpInside { _ in
                print("Item Tapped")
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("Ouch. nil data source for messages")
        }
        
        //        guard !isSectionReservedForTypingBubble(indexPath.section) else {
        //            return super.collectionView(collectionView, cellForItemAt: indexPath)
        //        }
        
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        if case .custom = message.kind {
            let cell = messagesCollectionView.dequeueReusableCell(CustomCell.self, for: indexPath)
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        }
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    // MARK: - MessagesDataSource
    
    override func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isTimeLabelVisible(at: indexPath) {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    override func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if !isPreviousMessageSameSender(at: indexPath) {
            //let name = message.sender.displayName
            return NSAttributedString(string: " ", attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)])
        }
        return nil
    }
    
    override func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if !isPreviousMessageSameSender(at: indexPath) {
            if self.arrFullChatList.count > 0{
            if self.arrFullChatList.count > indexPath.section{
            let objAllMessages  = AllMessages.init(dictionary:((self.arrFullChatList[indexPath.section] as AnyObject) as! NSDictionary))!
            let name = objAllMessages.senderLocation!
            return NSAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)])
        }
        }
        }
        return nil
        
        //if !isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message) {
            //return NSAttributedString(string:name, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)]) //"Delivered"
        //}
        //return nil
    }
}

// MARK: - MessagesDisplayDelegate

extension ChatGroupVC: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    /* func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedStringKey: Any] {
     return MessageLabel.defaultAttributes
     }
     
     func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
     return [.url, .address, .phoneNumber, .date, .transitInformation]
     }*/
    
    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        //.primaryColor
        return isFromCurrentSender(message: message) ? Constant.primaryColor : .white//UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath,
                             in messagesCollectionView: MessagesCollectionView) -> Bool {
        
        // 2
        return true
    }
    
    /*func messageStyle(for message: MessageType, at indexPath: IndexPath,
     in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
     
     let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
     
     // 3
     return .bubbleTail(corner, .curved)
     }*/
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        var corners: UIRectCorner = []
        
        if isFromCurrentSender(message: message) {
            corners.formUnion(.topLeft)
            corners.formUnion(.bottomLeft)
            if !isPreviousMessageSameSender(at: indexPath) {
                corners.formUnion(.topRight)
            }
            if !isNextMessageSameSender(at: indexPath) {
                corners.formUnion(.bottomRight)
            }
        } else {
            corners.formUnion(.topRight)
            corners.formUnion(.bottomRight)
            if !isPreviousMessageSameSender(at: indexPath) {
                corners.formUnion(.topLeft)
            }
            if !isNextMessageSameSender(at: indexPath) {
                corners.formUnion(.bottomLeft)
            }
        }
        
        return .custom { view in
            let radius: CGFloat = 8//16
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.mask = mask
        }
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView)
    {
        //let deadlineTime = DispatchTime.now() + .seconds(2)
        //DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
        
      //  print(self.arrFullChatList)
        
        if self.arrFullChatList.count > 0{
            if self.arrFullChatList.count > indexPath.section{

        let objAllMessages  = AllMessages.init(dictionary:((self.arrFullChatList[indexPath.section] as AnyObject) as! NSDictionary))!
        //print("objAllMessages: ", objAllMessages)
        //print("objAllMessages: ", objAllMessages.senderImage!)
        
        let imageAvatar = UIImageView()
        
        let userId = Auth.auth().currentUser?.uid
        //avatarView.layer.cornerRadius = 4.0
        //imageAvatar.layer.cornerRadius = 4.0
        
        if  objAllMessages.senderId != userId!
        {
            imageAvatar.sd_setImage(with: URL(string: objAllMessages.senderImage!), placeholderImage: UIImage(named: "gallery1"))
            
            let avatar = Avatar(image: imageAvatar.image, initials: "?")
            //let avatar = avatarView.set(avatar: avatar)
            avatarView.set(avatar: avatar)
            avatarView.isHidden = self.isNextMessageSameSender(at: indexPath)
            avatarView.layer.borderWidth = 1
            avatarView.layer.borderColor = Constant.primaryColor.cgColor
        }
    //})
        }
        }
}
    
    func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        // Cells are reused, so only add a button here once. For real use you would need to
        // ensure any subviews are removed if not needed
        guard accessoryView.subviews.isEmpty else { return }
        let button = UIButton(type: .infoLight)
        button.tintColor = Constant.primaryColor//.primaryColor
        accessoryView.addSubview(button)
        button.frame = accessoryView.bounds
        button.isUserInteractionEnabled = false // respond to accessoryView tap through `MessageCellDelegate`
        accessoryView.layer.cornerRadius = accessoryView.frame.height / 2
        accessoryView.backgroundColor = Constant.primaryColor.withAlphaComponent(0.3)//UIColor.primaryColor.withAlphaComponent(0.3)
    }
    
    // MARK: - Location Messages
    
    func annotationViewForLocation(message: MessageType, at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: nil)
        //let pinImage = #imageLiteral(resourceName: "ic_map_marker")
        let pinImage = #imageLiteral(resourceName: "city")
        annotationView.image = pinImage
        annotationView.centerOffset = CGPoint(x: 0, y: -pinImage.size.height / 2)
        return annotationView
    }
    
    func animationBlockForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> ((UIImageView) -> Void)? {
        return { view in
            view.layer.transform = CATransform3DMakeScale(2, 2, 2)
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
                view.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
    }
    
    func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions {
        
        return LocationMessageSnapshotOptions(showsBuildings: true, showsPointsOfInterest: true, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    }
    
}


// MARK: - MessagesLayoutDelegate

extension ChatGroupVC: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isTimeLabelVisible(at: indexPath) {
            return 18
        }
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isFromCurrentSender(message: message) {
            return !isPreviousMessageSameSender(at: indexPath) ? 20 : 0
        } else {
            return !isPreviousMessageSameSender(at: indexPath) ? (20 + outgoingAvatarOverlap) : 0
        }
        //return 0
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        //return (!isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message)) ? 16 : 12
        
        return 0
    }
    
}
