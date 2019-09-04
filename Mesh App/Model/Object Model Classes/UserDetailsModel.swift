//
//  user_information.swift
//  Locatem
//
//  Created by Mac admin on 07/05/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import Foundation

/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */
public class UserDetailsModel : NSObject, NSCoding
{
    public var countryName : String?
    public var countryCode : String?
    public var phone : String?    
    public var deviceId : String?
    public var fcmPushToken : String?
    public var userId : String?
    public var cityName : String?
    public var companyName : String?
    public var designation : String?
    public var userImage : String?
    public var industry : String?
    public var institutes : String?
    public var interests : String?
    public var shortBio : String?
    public var userEmail : String?
    public var userName : String?    
    public var isVerified : String?
    public var isLogin : String?
    public var createdOn : Double?
    public var modifiedOn : Double?
    
    public var userDetails : UserDetailsModel?
    
    public var message : String?
    public var status : String?
    
    public required override init()
    {
        super.init()
    }
   
    // MARK: - NSCoding Methods
    public required init(coder aDecoder: NSCoder)
    {
        self.userId = aDecoder.decodeObject(forKey: kUserId) as? String
        self.countryName = aDecoder.decodeObject(forKey: kCountryName) as? String
        self.countryCode = aDecoder.decodeObject(forKey:kCountryCode ) as? String
        self.phone = aDecoder.decodeObject(forKey: kPhone) as? String
        self.isVerified = aDecoder.decodeObject(forKey: kIsVerified) as? String
        self.isLogin = aDecoder.decodeObject(forKey: kIsLogin) as? String
        self.fcmPushToken = aDecoder.decodeObject(forKey: kFCMPushTokenDB) as? String
        self.deviceId = aDecoder.decodeObject(forKey: kDeviceId) as? String
        self.userName = aDecoder.decodeObject(forKey: kUserName) as? String
        
        self.userEmail = aDecoder.decodeObject(forKey: kUserEmail) as? String
        self.shortBio = aDecoder.decodeObject(forKey: kShortBio) as? String
        self.designation = aDecoder.decodeObject(forKey:kDesignation ) as? String
        self.companyName = aDecoder.decodeObject(forKey: kCompany) as? String
        self.industry = aDecoder.decodeObject(forKey: kIndustry) as? String
        self.institutes = aDecoder.decodeObject(forKey: kInstitute) as? String
        self.interests = aDecoder.decodeObject(forKey: kInterests) as? String
        self.userImage = aDecoder.decodeObject(forKey: kUserImage) as? String
        self.cityName = aDecoder.decodeObject(forKey: kCityName) as? String
        
        self.createdOn = aDecoder.decodeObject(forKey: kCreatedOn) as? Double
        self.modifiedOn = aDecoder.decodeObject(forKey: kModifiedOn) as? Double
        
        self.message = aDecoder.decodeObject(forKey: kMessage) as? String
        self.status = aDecoder.decodeObject(forKey: kStatus) as? String
    }
    
    func initWithCoder(aDecoder: NSCoder) -> UserDetailsModel
    {
        self.userId = aDecoder.decodeObject(forKey: kUserId) as? String
        self.countryName = aDecoder.decodeObject(forKey: kCountryName) as? String
        self.countryCode = aDecoder.decodeObject(forKey:kCountryCode ) as? String
        self.phone = aDecoder.decodeObject(forKey: kPhone) as? String
        self.isVerified = aDecoder.decodeObject(forKey: kIsVerified) as? String
        self.isLogin = aDecoder.decodeObject(forKey: kIsLogin) as? String
        self.fcmPushToken = aDecoder.decodeObject(forKey: kFCMPushTokenDB) as? String
        self.deviceId = aDecoder.decodeObject(forKey: kDeviceId) as? String

        self.userEmail = aDecoder.decodeObject(forKey: kUserEmail) as? String
        self.shortBio = aDecoder.decodeObject(forKey: kShortBio) as? String
        self.designation = aDecoder.decodeObject(forKey:kDesignation ) as? String
        self.companyName = aDecoder.decodeObject(forKey: kCompany) as? String
        self.industry = aDecoder.decodeObject(forKey: kIndustry) as? String
        self.institutes = aDecoder.decodeObject(forKey: kInstitute) as? String
        self.interests = aDecoder.decodeObject(forKey: kInterests) as? String
        self.userImage = aDecoder.decodeObject(forKey: kUserImage) as? String
        self.cityName = aDecoder.decodeObject(forKey: kCityName) as? String
        
        self.createdOn = aDecoder.decodeObject(forKey: kCreatedOn) as? Double
        self.modifiedOn = aDecoder.decodeObject(forKey: kModifiedOn) as? Double
        
        return self
    }
    
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.userId, forKey: kUserId)
        aCoder.encode(self.countryName, forKey: kCountryName)
        aCoder.encode(self.countryCode, forKey: kCountryCode)
        aCoder.encode(self.phone, forKey: kPhone)
        aCoder.encode(self.isLogin, forKey: kIsLogin)
        aCoder.encode(self.isVerified, forKey: kIsVerified)
        aCoder.encode(self.fcmPushToken, forKey: kFCMPushTokenDB)
        aCoder.encode(self.userName, forKey: kUserName)
        aCoder.encode(self.userEmail, forKey: kUserEmail)
        aCoder.encode(self.shortBio, forKey: kShortBio)
        aCoder.encode(self.designation, forKey: kDesignation)
        aCoder.encode(self.companyName, forKey: kCompany)
        aCoder.encode(self.industry, forKey: kIndustry)
        aCoder.encode(self.interests, forKey: kInterests)
        aCoder.encode(self.userImage, forKey: kUserImage)
        aCoder.encode(self.cityName, forKey: kCityName)
        aCoder.encode(self.institutes, forKey: kInstitute)
        
        aCoder.encode(self.createdOn, forKey: kCreatedOn)
        aCoder.encode(self.modifiedOn, forKey:kModifiedOn)
    }
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [UserDetailsModel]
    {
        var models:[UserDetailsModel] = []
        for item in array
        {
            models.append(UserDetailsModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary)
    {
        
        print(dictionary)
        
        userId = dictionary[kUserId] as? String
        countryName = dictionary[kCountryName] as? String
        countryCode = dictionary[kCountryCode] as? String
        phone = dictionary[kPhone] as? String
        isVerified = dictionary[kIsVerified] as? String
        isLogin = dictionary[kIsLogin] as? String
        fcmPushToken = dictionary[kFCMPushTokenDB] as? String
        deviceId = dictionary[kDeviceId] as? String
        userName = dictionary[kUserName] as? String
        userEmail = dictionary[kUserEmail] as? String
        shortBio = dictionary[kShortBio] as? String
        designation = dictionary[kDesignation] as? String
        companyName = dictionary[kCompany] as? String
        industry = dictionary[kIndustry] as? String
        institutes = dictionary[kInstitute] as? String
        
        /*if let instituteDictArray = dictionary[kInstitute] as? [[String: Any]] {
            institutes = instituteDictArray.map { Institute($0) }
        }*/
        interests = dictionary[kInterests] as? String
        userImage = dictionary[kUserImage] as? String
        cityName = dictionary[kCityName] as? String
        
        createdOn = dictionary[kCreatedOn] as? Double
        modifiedOn = dictionary[kModifiedOn] as? Double

    }
    
    public  func dictionaryDetails(dictionary:NSMutableDictionary) -> NSMutableDictionary
    {
        dictionary.setValue(self.userId, forKey: kUserId)
        dictionary.setValue(self.countryName, forKey: kCountryName)
        dictionary.setValue(self.countryCode, forKey: kCountryCode)
        dictionary.setValue(self.phone, forKey: kPhone)
        dictionary.setValue(self.isVerified, forKey: kIsVerified)
        dictionary.setValue(self.isLogin, forKey: kIsLogin)
        dictionary.setValue(self.fcmPushToken, forKey: kFCMPushTokenDB)
        dictionary.setValue(self.deviceId, forKey: kDeviceId)
        dictionary.setValue(self.userName, forKey: kUserName)
        dictionary.setValue(self.userEmail, forKey:kUserEmail)
        dictionary.setValue(self.shortBio, forKey: kShortBio)
        dictionary.setValue(self.designation, forKey: kDesignation)
        dictionary.setValue(self.companyName, forKey: kCompany)
        dictionary.setValue(self.industry, forKey: kIndustry)
        dictionary.setValue(self.institutes, forKey: kInstitute)
        dictionary.setValue(self.interests, forKey: kInterests)
        dictionary.setValue(self.userImage, forKey: kUserImage)
        dictionary.setValue(self.cityName, forKey: kCityName)
        
        dictionary.setValue(self.createdOn, forKey: kCreatedOn)
        dictionary.setValue(self.modifiedOn, forKey:kModifiedOn)
       
        return dictionary
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.userId, forKey: kUserId)
        dictionary.setValue(self.countryName, forKey: kCountryName)
        dictionary.setValue(self.countryCode, forKey: kCountryCode)
        dictionary.setValue(self.phone, forKey: kPhone)
        dictionary.setValue(self.isVerified, forKey: kIsVerified)
        dictionary.setValue(self.isLogin, forKey: kIsLogin)
        dictionary.setValue(self.fcmPushToken, forKey: kFCMPushTokenDB)
        dictionary.setValue(self.deviceId, forKey: kDeviceId)
        dictionary.setValue(self.userName, forKey: kUserName)
        dictionary.setValue(self.userEmail, forKey:kUserEmail)
        dictionary.setValue(self.shortBio, forKey: kShortBio)
        dictionary.setValue(self.designation, forKey: kDesignation)
        dictionary.setValue(self.companyName, forKey: kCompany)
        dictionary.setValue(self.industry, forKey: kIndustry)
        dictionary.setValue(self.institutes, forKey: kInstitute)
        dictionary.setValue(self.interests, forKey: kInterests)
        dictionary.setValue(self.userImage, forKey: kUserImage)
        dictionary.setValue(self.cityName, forKey: kCityName)
        
        dictionary.setValue(self.createdOn, forKey: kCreatedOn)
        dictionary.setValue(self.modifiedOn, forKey:kModifiedOn)
        
        return dictionary
    }    
}




