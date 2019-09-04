//
//  Messages.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 27/11/2018.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class AllMessages: NSObject
{    
    /*public var textMessage : String?
    public var senderName : String?
    public var senderImage : String?
    public var senderId : String?
    public var messageId : String?
    public var isReplyMsg : String?
    public var receiverId : String?
    public var receiverFcmToken : String?
    public var messageTime : String?
    public var senderFcmToken : String?
    public var senderLocation : String?*/
    
    
    public var messageId: String?
    public var textMessage: String?
    public var senderName: String?
    public var senderImage: String?
    public var senderId: String?
    public var isReplyMsg: String?
    public var messageTime: Double?
    public var senderFcmToken: String?
    public var senderLocation: String?
    public var senderDesignation: String?
    public var senderCompany: String?

    
    static var arrChatData = NSMutableArray()
    
    public required override init()
    {
        super.init()
    }
    
    // MARK: - NSCoding Methods
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.textMessage, forKey: kTextMessage)
        aCoder.encode(self.senderName, forKey: kSenderName)
        aCoder.encode(self.senderImage, forKey: kSenderImage)
        aCoder.encode(self.senderId, forKey: kSenderId)
        aCoder.encode(self.messageId, forKey: kMessageId)
        aCoder.encode(self.isReplyMsg, forKey: kIsReplyMsg)

//        aCoder.encode(self.receiverName, forKey: kReceiverName)
//        aCoder.encode(self.receiverLocation, forKey: kReceiverLocation)
//        aCoder.encode(self.receiverImage, forKey: kReceiverImage)
        aCoder.encode(self.senderDesignation, forKey: kSenderDesignation)
        aCoder.encode(self.senderCompany, forKey: kSenderCompany)
        aCoder.encode(self.messageTime, forKey: kMessageTime)
        aCoder.encode(self.senderFcmToken, forKey: kSenderFcmToken)
        aCoder.encode(self.senderLocation, forKey: kSenderLocation)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.textMessage = aDecoder.decodeObject(forKey: kTextMessage) as? String
        self.senderName = aDecoder.decodeObject(forKey: kSenderName) as? String
        self.senderImage = aDecoder.decodeObject(forKey:kSenderImage ) as? String
        self.senderId = aDecoder.decodeObject(forKey: kSenderId) as? String
        self.messageId = aDecoder.decodeObject(forKey:kMessageId ) as? String
        self.isReplyMsg = aDecoder.decodeObject(forKey: kIsReplyMsg) as? String
        self.senderDesignation = aDecoder.decodeObject(forKey:kSenderDesignation ) as? String
        self.senderCompany = aDecoder.decodeObject(forKey:kSenderCompany ) as? String
        self.messageTime = aDecoder.decodeObject(forKey:kMessageTime ) as? Double
        self.senderFcmToken = aDecoder.decodeObject(forKey:kSenderFcmToken ) as? String
        self.senderLocation = aDecoder.decodeObject(forKey:kSenderLocation ) as? String
        
    }
    
    
    func initWithCoder(aDecoder: NSCoder) -> AllMessages
    {
        self.textMessage = aDecoder.decodeObject(forKey: kTextMessage) as? String
        self.senderName = aDecoder.decodeObject(forKey: kSenderName) as? String
        self.senderImage = aDecoder.decodeObject(forKey:kSenderImage ) as? String
        self.senderId = aDecoder.decodeObject(forKey: kSenderId) as? String
        self.messageId = aDecoder.decodeObject(forKey:kMessageId ) as? String
        self.isReplyMsg = aDecoder.decodeObject(forKey: kIsReplyMsg) as? String
        self.senderDesignation = aDecoder.decodeObject(forKey:kSenderDesignation ) as? String
        self.senderCompany = aDecoder.decodeObject(forKey:kSenderCompany ) as? String
        self.messageTime = aDecoder.decodeObject(forKey:kMessageTime ) as? Double
        self.senderFcmToken = aDecoder.decodeObject(forKey:kSenderFcmToken ) as? String
        self.senderLocation = aDecoder.decodeObject(forKey:kSenderLocation ) as? String
        
        return self
    }
    
    public static func modelsFromDictionaryArray(array:NSArray) -> [AllMessages]
    {
        var models:[AllMessages] = []
        for item in array
        {
            models.append(AllMessages(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary)
    {
        textMessage = dictionary[kTextMessage] as? String
        senderName = dictionary[kSenderName] as? String
        senderImage = dictionary[kSenderImage] as? String
        senderId = dictionary[kSenderId] as? String
        messageId = dictionary[kMessageId] as? String
        isReplyMsg = dictionary[kIsReplyMsg] as? String
//        receiverName = dictionary[kReceiverName] as? String
//        receiverLocation = dictionary[kReceiverLocation] as? String
//        receiverImage = dictionary[kReceiverImage] as? String
        senderDesignation = dictionary[kSenderDesignation] as? String
        senderCompany = dictionary[kSenderCompany] as? String
        messageTime = dictionary[kMessageTime] as? Double
        senderFcmToken = dictionary[kSenderFcmToken] as? String
        senderLocation = dictionary[kSenderLocation] as? String
    }
    
    public  func dictionaryDetails(dictionary:NSMutableDictionary) -> NSMutableDictionary
    {
        dictionary.setValue(self.textMessage, forKey: kTextMessage)
        dictionary.setValue(self.senderName, forKey: kSenderName)
        dictionary.setValue(self.senderImage, forKey: kSenderImage)
        dictionary.setValue(self.senderId, forKey: kSenderId)
        dictionary.setValue(self.messageId, forKey: kMessageId)
        dictionary.setValue(self.isReplyMsg, forKey: kIsReplyMsg)
        dictionary.setValue(self.senderDesignation, forKey: kSenderDesignation)
        dictionary.setValue(self.senderCompany, forKey: kSenderCompany)
        dictionary.setValue(self.messageTime, forKey: kMessageTime)
        dictionary.setValue(self.senderFcmToken, forKey: kSenderFcmToken)
        dictionary.setValue(self.senderLocation, forKey: kSenderLocation)
        
        return dictionary
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.textMessage, forKey: kTextMessage)
        dictionary.setValue(self.senderName, forKey: kSenderName)
        dictionary.setValue(self.senderImage, forKey: kSenderImage)
        dictionary.setValue(self.senderId, forKey: kSenderId)
        dictionary.setValue(self.messageId, forKey: kMessageId)
        dictionary.setValue(self.isReplyMsg, forKey: kIsReplyMsg)
        dictionary.setValue(self.senderDesignation, forKey: kSenderDesignation)
        dictionary.setValue(self.senderCompany, forKey: kSenderCompany)
        dictionary.setValue(self.messageTime, forKey: kMessageTime)
        dictionary.setValue(self.senderFcmToken, forKey: kSenderFcmToken)
        dictionary.setValue(self.senderLocation, forKey: kSenderLocation)        
        return dictionary
    }
}
