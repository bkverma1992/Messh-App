//
//  AllChatMessagesListEntity+CoreDataProperties.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 20/02/2019.
//  Copyright © 2019 Swati. All rights reserved.
//
//

import Foundation
import CoreData


extension AllChatMessagesListEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AllChatMessagesListEntity> {
        return NSFetchRequest<AllChatMessagesListEntity>(entityName: "AllChatMessagesListEntity")
    }

    @NSManaged public var isReplyMsg: String?
    @NSManaged public var messageId: String?
    @NSManaged public var messageTime: Double
    @NSManaged public var senderCompany: String?
    @NSManaged public var senderDesignation: String?
    @NSManaged public var senderFcmToken: String?
    @NSManaged public var senderId: String?
    @NSManaged public var senderImage: String?
    @NSManaged public var senderLocation: String?
    @NSManaged public var senderName: String?
    @NSManaged public var textMessage: String?
    @NSManaged public var uniqueChatKey: String?

}
