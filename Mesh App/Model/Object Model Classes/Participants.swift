//
//  Participants.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 30/11/2018.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class Participants: NSObject{
    
    public var participantsFCMPushTokenDB : String?
    public var participantsLocation : String?
    public var participantsImage : String?
    //public var isAdmin : String?
    public var isAdmin : Bool?
    public var participantsPhone : String?
    public var participantsName : String?
    public var participantsId : String?
    public var participantsShortBio : String?
    
    public required override init()
    {
        super.init()
    }
    
    // MARK: - NSCoding Methods
    public required init(coder aDecoder: NSCoder)
    {
        self.participantsFCMPushTokenDB = aDecoder.decodeObject(forKey: kParticipantsFCMPushTokenDB) as? String
        self.participantsLocation = aDecoder.decodeObject(forKey: kParticipantsLocation) as? String
        self.participantsImage = aDecoder.decodeObject(forKey:kParticipantsImage ) as? String
        self.isAdmin = aDecoder.decodeObject(forKey: kIsAdmin) as? Bool
        self.participantsPhone = aDecoder.decodeObject(forKey: kParticipantsPhone) as? String
        self.participantsName = aDecoder.decodeObject(forKey: kParticipantsName) as? String
        self.participantsId = aDecoder.decodeObject(forKey: kParticipantsId) as? String
        self.participantsShortBio = aDecoder.decodeObject(forKey: kParticipantsShortBio) as? String
    }
    
    func initWithCoder(aDecoder: NSCoder) -> Participants
    {
        self.participantsFCMPushTokenDB = aDecoder.decodeObject(forKey: kParticipantsFCMPushTokenDB) as? String
        self.participantsLocation = aDecoder.decodeObject(forKey: kParticipantsLocation) as? String
        self.participantsImage = aDecoder.decodeObject(forKey:kParticipantsImage ) as? String
        self.isAdmin = aDecoder.decodeObject(forKey: kIsAdmin) as? Bool
        self.participantsPhone = aDecoder.decodeObject(forKey: kParticipantsPhone) as? String
        self.participantsName = aDecoder.decodeObject(forKey: kParticipantsName) as? String
        self.participantsId = aDecoder.decodeObject(forKey: kParticipantsId) as? String
        self.participantsShortBio = aDecoder.decodeObject(forKey: kParticipantsShortBio) as? String
        
        return self
    }
    
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.participantsFCMPushTokenDB, forKey: kParticipantsFCMPushTokenDB)
        aCoder.encode(self.participantsLocation, forKey: kParticipantsLocation)
        aCoder.encode(self.participantsImage, forKey: kParticipantsImage)
        aCoder.encode(self.isAdmin, forKey: kIsAdmin)
        aCoder.encode(self.participantsPhone, forKey: kParticipantsPhone)
        aCoder.encode(self.participantsName, forKey: kParticipantsName)
        aCoder.encode(self.participantsId, forKey: kParticipantsId)
        aCoder.encode(self.participantsShortBio, forKey: kParticipantsShortBio)
    }
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Participants]
    {
        var models:[Participants] = []
        for item in array
        {
            models.append(Participants(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary)
    {
        participantsFCMPushTokenDB = dictionary[kParticipantsFCMPushTokenDB] as? String
        participantsLocation = dictionary[kParticipantsLocation] as? String
        participantsImage = dictionary[kParticipantsImage] as? String
        isAdmin = dictionary[kIsAdmin] as? Bool
        participantsPhone = dictionary[kParticipantsPhone] as? String
        participantsName = dictionary[kParticipantsName] as? String
        participantsId = dictionary[kParticipantsId] as? String
        participantsShortBio = dictionary[kParticipantsShortBio] as? String
    }
    
    public  func dictionaryDetails(dictionary:NSMutableDictionary) -> NSMutableDictionary
    {
        dictionary.setValue(self.participantsFCMPushTokenDB, forKey: kParticipantsFCMPushTokenDB)
        dictionary.setValue(self.participantsLocation, forKey: kParticipantsLocation)
        dictionary.setValue(self.participantsImage, forKey: kParticipantsImage)
        dictionary.setValue(self.isAdmin, forKey: kIsAdmin)
        dictionary.setValue(self.participantsPhone, forKey: kParticipantsPhone)
        dictionary.setValue(self.participantsName, forKey: kParticipantsName)
        dictionary.setValue(self.participantsId, forKey: kParticipantsId)
        dictionary.setValue(self.participantsShortBio, forKey: kParticipantsShortBio)
        
        return dictionary
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.participantsFCMPushTokenDB, forKey: kParticipantsFCMPushTokenDB)
        dictionary.setValue(self.participantsLocation, forKey: kParticipantsLocation)
        dictionary.setValue(self.participantsImage, forKey: kParticipantsImage)
        dictionary.setValue(self.isAdmin, forKey: kIsAdmin)
        dictionary.setValue(self.participantsPhone, forKey: kParticipantsPhone)
        dictionary.setValue(self.participantsName, forKey: kParticipantsName)
        dictionary.setValue(self.participantsId, forKey: kParticipantsId)
        dictionary.setValue(self.participantsShortBio, forKey: kParticipantsShortBio)
        
        return dictionary
    }
}



