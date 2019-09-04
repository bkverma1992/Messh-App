//
//  ParticipantsListEntity.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 18/02/2019.
//  Copyright © 2019 Swati. All rights reserved.
//

import UIKit
import CoreData

@objc(ParticipantsListEntity)
class ParticipantsListEntity: NSManagedObject {
    
    @NSManaged public var chatUniqueKey: String?
    @NSManaged public var participantsFCMPushTokenDB: String?
    @NSManaged public var participantsLocation: String?
    @NSManaged public var participantsImage: String?
    @NSManaged public var isAdmin: Bool
    @NSManaged public var participantsPhone: String?
    @NSManaged public var participantsName: String?
    @NSManaged public var participantsId: String?
    @NSManaged public var participantsShortBio: String?

}
