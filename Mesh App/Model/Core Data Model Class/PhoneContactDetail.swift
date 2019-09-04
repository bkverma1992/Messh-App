//
//  PhoneContactDetail.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 28/12/2018.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit
import CoreData

@objc(PhoneContactDetail)
class PhoneContactDetail: NSManagedObject {
    
    @NSManaged var name : String?
    @NSManaged var number : String?
    @NSManaged public var isExist : String?    
    @NSManaged var countryName : String?
    @NSManaged var countryCode : String?
    @NSManaged var phone : String?
    @NSManaged var deviceId : String?
    @NSManaged var fcmPushToken : String?
    @NSManaged var userId : String?
    @NSManaged var cityName : String?
    @NSManaged var companyName : String?
    @NSManaged var designation : String?
    @NSManaged var userImage : String?
    @NSManaged var industry : String?
    @NSManaged var institute : String?
    @NSManaged var interests : String?
    @NSManaged var shortBio : String?
    @NSManaged var userEmail : String?
    @NSManaged var userName : String?
    @NSManaged var isVerified : String?
    @NSManaged var isLogin : String?
    @NSManaged var createdOn : String?
    @NSManaged var modifiedOn : String?
    
    
    /*public var isExist : Bool? {
        get {
            willAccessValue(forKey: "isExist")
            //let isExist = primitiveValue(forKey: "isExist") as! Bool //Int64
            didAccessValue(forKey: "isExist")
            return self.isExist
        }
        set {
            willChangeValue(forKey: "isExist")
            setPrimitiveValue(newValue, forKey: "isExist")
            didChangeValue(forKey: "isExist")
        }
    }*/
}
