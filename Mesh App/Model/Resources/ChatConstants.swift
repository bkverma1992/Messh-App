//
//  ChatConstants.swift
//  Mesh App
//
//  Created by Mac admin on 08/10/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import Foundation
import Firebase
import CoreData
import FirebaseAuth
import FirebaseDatabase

struct ChatConstants
{
    struct refs
    {
        static let childUserId = Auth.auth().currentUser?.uid
        static let databaseRoot = Database.database().reference()
        static let databaseUserInfo = databaseRoot.child("UserInfo")
        static let databaseParticularUserInfo = databaseRoot.child("UserInfo").child(childUserId!).child("chats")
        static let databaseChatInfo = databaseRoot.child("ChatInfo")
        static let databaseChatKeyInfo = databaseRoot.child("ChatKeyInfo")
        static let databaseMessagesInfo = databaseRoot.child("AllMessages")
        static let databaseBuzzPostsInfo = databaseRoot.child("BuzzPosts")
    }
    
    struct entityName
    {
        static let entityLoginUserDetail = "LoginUserDetail"
        static let entityPhoneContactDetail = "PhoneContactDetail"
        static let entityAllChatUserList = "AllChatUserListEntity"
        static let entityAllChatMessagesList = "AllChatMessagesListEntity"
        static let entityAllChatInfoListEntity = "AllChatInfoListEntity"
        static let entityParticipantsListEntity = "ParticipantsListEntity"
    }
}
