//
//  BuzzPosts.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 13/12/2018.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class BuzzPosts: NSObject, NSCoding {
    
    public var buzzPostDescription : String?
    public var buzzPostId : String?
    public var buzzPostImage : String?
    public var buzzPostText : String?
    public var buzzPostTime : Double?
    public var buzzPostTitle : String?
    public var buzzPostType : String?
    public var buzzPostUrl : String?
    public var buzzPostUserCompany : String?
    public var buzzPostUserDesignation : String?
    public var buzzPostUserId : String?
    public var buzzPostUserImage : String?
    public var buzzPostUserName : String?
    
    public required override init()
    {
        super.init()
    }
    
    // MARK: - NSCoding Methods
    public required init(coder aDecoder: NSCoder)
    {
        self.buzzPostDescription = aDecoder.decodeObject(forKey: kBuzzPostDescription) as? String
        self.buzzPostId = aDecoder.decodeObject(forKey: kBuzzPostId) as? String
        self.buzzPostImage = aDecoder.decodeObject(forKey:kBuzzPostImage ) as? String
        self.buzzPostText = aDecoder.decodeObject(forKey: kBuzzPostText) as? String
        self.buzzPostTime = aDecoder.decodeObject(forKey: kBuzzPostTime) as? Double
        self.buzzPostTitle = aDecoder.decodeObject(forKey: kBuzzPostTitle) as? String
        self.buzzPostType = aDecoder.decodeObject(forKey: kBuzzPostType) as? String
        self.buzzPostUrl = aDecoder.decodeObject(forKey: kBuzzPostUrl) as? String
        self.buzzPostUserCompany = aDecoder.decodeObject(forKey: kBuzzPostUserCompany) as? String
        
        self.buzzPostUserDesignation = aDecoder.decodeObject(forKey: kBuzzPostUserDesignation) as? String
        self.buzzPostUserId = aDecoder.decodeObject(forKey: kBuzzPostUserId) as? String
        self.buzzPostUserImage = aDecoder.decodeObject(forKey:kBuzzPostUserImage ) as? String
        self.buzzPostUserName = aDecoder.decodeObject(forKey: kBuzzPostUserName) as? String
    }
    
    func initWithCoder(aDecoder: NSCoder) -> BuzzPosts
    {
        self.buzzPostDescription = aDecoder.decodeObject(forKey: kBuzzPostDescription) as? String
        self.buzzPostId = aDecoder.decodeObject(forKey: kBuzzPostId) as? String
        self.buzzPostImage = aDecoder.decodeObject(forKey:kBuzzPostImage ) as? String
        self.buzzPostText = aDecoder.decodeObject(forKey: kBuzzPostText) as? String
        self.buzzPostTime = aDecoder.decodeObject(forKey: kBuzzPostTime) as? Double
        self.buzzPostTitle = aDecoder.decodeObject(forKey: kBuzzPostTitle) as? String
        self.buzzPostType = aDecoder.decodeObject(forKey: kBuzzPostType) as? String
        self.buzzPostUrl = aDecoder.decodeObject(forKey: kBuzzPostUrl) as? String
        self.buzzPostUserCompany = aDecoder.decodeObject(forKey: kBuzzPostUserCompany) as? String
        
        self.buzzPostUserDesignation = aDecoder.decodeObject(forKey: kBuzzPostUserDesignation) as? String
        self.buzzPostUserId = aDecoder.decodeObject(forKey: kBuzzPostUserId) as? String
        self.buzzPostUserImage = aDecoder.decodeObject(forKey:kBuzzPostUserImage ) as? String
        self.buzzPostUserName = aDecoder.decodeObject(forKey: kBuzzPostUserName) as? String
        
        return self
    }
    
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.buzzPostDescription, forKey: kBuzzPostDescription)
        aCoder.encode(self.buzzPostId, forKey: kBuzzPostId)
        aCoder.encode(self.buzzPostImage, forKey: kBuzzPostImage)
        aCoder.encode(self.buzzPostText, forKey: kBuzzPostText)
        aCoder.encode(self.buzzPostTime, forKey: kBuzzPostTime)
        aCoder.encode(self.buzzPostTitle, forKey: kBuzzPostTitle)
        aCoder.encode(self.buzzPostType, forKey: kBuzzPostType)
        aCoder.encode(self.buzzPostUrl, forKey: kBuzzPostUrl)
        aCoder.encode(self.buzzPostUserCompany, forKey: kBuzzPostUserCompany)
        aCoder.encode(self.buzzPostUserDesignation, forKey: kBuzzPostUserDesignation)
        aCoder.encode(self.buzzPostUserId, forKey: kBuzzPostUserId)
        aCoder.encode(self.buzzPostUserImage, forKey: kBuzzPostUserImage)
        aCoder.encode(self.buzzPostUserName, forKey: kBuzzPostUserName)
    }
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [BuzzPosts]
    {
        var models:[BuzzPosts] = []
        for item in array
        {
            models.append(BuzzPosts(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary)
    {
        buzzPostDescription = dictionary[kBuzzPostDescription] as? String
        buzzPostId = dictionary[kBuzzPostId] as? String
        buzzPostImage = dictionary[kBuzzPostImage] as? String
        buzzPostText = dictionary[kBuzzPostText] as? String
        buzzPostTime = dictionary[kBuzzPostTime] as? Double
        buzzPostTitle = dictionary[kBuzzPostTitle] as? String
         buzzPostType = dictionary[kBuzzPostType] as? String
        buzzPostUrl = dictionary[kBuzzPostUrl] as? String
        buzzPostUserCompany = dictionary[kBuzzPostUserCompany] as? String
        buzzPostUserDesignation = dictionary[kBuzzPostUserDesignation] as? String
        buzzPostUserId = dictionary[kBuzzPostUserId] as? String
        buzzPostUserImage = dictionary[kBuzzPostUserImage] as? String
        buzzPostUserName = dictionary[kBuzzPostUserName] as? String
    }
    
    public  func dictionaryDetails(dictionary:NSMutableDictionary) -> NSMutableDictionary
    {
        dictionary.setValue(self.buzzPostDescription, forKey: kBuzzPostDescription)
        dictionary.setValue(self.buzzPostId, forKey: kBuzzPostId)
        dictionary.setValue(self.buzzPostImage, forKey: kBuzzPostImage)
        dictionary.setValue(self.buzzPostText, forKey: kBuzzPostText)
        dictionary.setValue(self.buzzPostTime, forKey: kBuzzPostTime)
        dictionary.setValue(self.buzzPostTitle, forKey: kBuzzPostTitle)
        dictionary.setValue(self.buzzPostType, forKey: kBuzzPostType)
        dictionary.setValue(self.buzzPostUrl, forKey: kBuzzPostUrl)
        dictionary.setValue(self.buzzPostUserCompany, forKey: kBuzzPostUserCompany)
        dictionary.setValue(self.buzzPostUserDesignation, forKey:kBuzzPostUserDesignation)
        dictionary.setValue(self.buzzPostUserId, forKey: kBuzzPostUserId)
        dictionary.setValue(self.buzzPostUserImage, forKey: kBuzzPostUserImage)
        dictionary.setValue(self.buzzPostUserName, forKey: kBuzzPostUserName)
        
        return dictionary
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.buzzPostDescription, forKey: kBuzzPostDescription)
        dictionary.setValue(self.buzzPostId, forKey: kBuzzPostId)
        dictionary.setValue(self.buzzPostImage, forKey: kBuzzPostImage)
        dictionary.setValue(self.buzzPostText, forKey: kBuzzPostText)
        dictionary.setValue(self.buzzPostTime, forKey: kBuzzPostTime)
        dictionary.setValue(self.buzzPostTitle, forKey: kBuzzPostTitle)
        dictionary.setValue(self.buzzPostType, forKey: kBuzzPostType)
        dictionary.setValue(self.buzzPostUrl, forKey: kBuzzPostUrl)
        dictionary.setValue(self.buzzPostUserCompany, forKey: kBuzzPostUserCompany)
        dictionary.setValue(self.buzzPostUserDesignation, forKey:kBuzzPostUserDesignation)
        dictionary.setValue(self.buzzPostUserId, forKey: kBuzzPostUserId)
        dictionary.setValue(self.buzzPostUserImage, forKey: kBuzzPostUserImage)
        dictionary.setValue(self.buzzPostUserName, forKey: kBuzzPostUserName)
        
        return dictionary
    }
}
