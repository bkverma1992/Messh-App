//
//  AllChatUserListEntity.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 03/01/2019.
//  Copyright © 2019 Swati. All rights reserved.
//

import UIKit
import CoreData

@objc(AllChatUserListEntity)
class AllChatUserListEntity: NSManagedObject {
    
    @NSManaged public var userChatKey: String?
    @NSManaged public var lastMessage: String?
    @NSManaged public var lastMessageTime: String?
    @NSManaged public var lastMessageId: String?
    @NSManaged public var participantsName: String?
    @NSManaged public var participantsId: String?
    @NSManaged public var participantsImage: String?
    @NSManaged public var groupId: String?
    @NSManaged public var groupName: String?
    @NSManaged public var groupIcon: String?
    @NSManaged public var isSeenMsg: String?
    @NSManaged public var chatType: String? 
    
}
