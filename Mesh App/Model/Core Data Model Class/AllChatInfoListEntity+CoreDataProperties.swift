//
//  AllChatInfoListEntity+CoreDataProperties.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 18/02/2019.
//  Copyright © 2019 Swati. All rights reserved.
//
//

import Foundation
import CoreData


extension AllChatInfoListEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AllChatInfoListEntity> {
        return NSFetchRequest<AllChatInfoListEntity>(entityName: "AllChatInfoListEntity")
    }

    @NSManaged public var chatKey: String?
    @NSManaged public var created_By: String?
    @NSManaged public var created_on: Double
    @NSManaged public var group_description: String?
    @NSManaged public var group_icon: String?
    @NSManaged public var group_id: String?
    @NSManaged public var group_name: String?
    @NSManaged public var modified_on: Double
    @NSManaged public var participant_count: String?
    @NSManaged public var type: String?

}
