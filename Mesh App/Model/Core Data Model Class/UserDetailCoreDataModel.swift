//
//  UserDetailCoreDataModel.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 27/12/2018.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit
import Foundation
import CoreData

@objc(UserDetailCoreDataModel)
class UserDetailCoreDataModel: NSManagedObject
{
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

    //public var userDetails : UserDetailsModel?
}
