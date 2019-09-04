//
//  SaveAndFetchCoreData.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 27/12/2018.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit
import CoreData

class SaveAndFetchCoreData: NSObject
{
    class func save(objUserDetail : UserDetailsModel)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: ChatConstants.entityName.entityLoginUserDetail, in: managedContext)!
        print(objUserDetail.createdOn as Any)
        let loginUserDetail = NSManagedObject(entity: entity, insertInto: managedContext)
        loginUserDetail.setValue(objUserDetail.userId, forKey: "userId")
        loginUserDetail.setValue(objUserDetail.userName, forKey: "userName")
        loginUserDetail.setValue(objUserDetail.cityName, forKey: "cityName")
        loginUserDetail.setValue(objUserDetail.countryCode, forKey: "countryCode")
        loginUserDetail.setValue(objUserDetail.countryName, forKey: "countryName")
        loginUserDetail.setValue(objUserDetail.shortBio, forKey: "shortBio")
        loginUserDetail.setValue(objUserDetail.userImage, forKey: "userImage")
        loginUserDetail.setValue(objUserDetail.companyName, forKey: "companyName")
        loginUserDetail.setValue(objUserDetail.interests, forKey: "interests")
        loginUserDetail.setValue(objUserDetail.industry, forKey: "industry")
        loginUserDetail.setValue(objUserDetail.designation, forKey: "designation")
        loginUserDetail.setValue(objUserDetail.userEmail, forKey: "userEmail")
        loginUserDetail.setValue(objUserDetail.institutes, forKey: "institute")
        loginUserDetail.setValue(objUserDetail.phone, forKey: "phone")
        loginUserDetail.setValue(objUserDetail.fcmPushToken, forKey: "fcmPushToken")
        loginUserDetail.setValue(objUserDetail.isVerified, forKey: "isVerified")
        loginUserDetail.setValue(objUserDetail.isLogin, forKey: "isLogin")
        loginUserDetail.setValue(objUserDetail.deviceId, forKey: "deviceId")
        loginUserDetail.setValue(objUserDetail.createdOn, forKey: "createdOn")
        loginUserDetail.setValue(objUserDetail.modifiedOn, forKey: "modifiedOn")
        
        //loginUserDetail.setValue(name, forKeyPath: "name")        
        do {
            try managedContext.save()
            var coreDataManagedObject: [NSManagedObject] = []
            coreDataManagedObject.append(loginUserDetail)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    class func getUserDetailFromCoreData() -> UserDetailCoreDataModel
    {
        var objUserDetail : UserDetailCoreDataModel?
        let appDelegate  : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ChatConstants.entityName.entityLoginUserDetail)
        fetchRequest.returnsDistinctResults = true
        fetchRequest.returnsObjectsAsFaults = false
        do{
            let arrResults : NSArray = try context.fetch(fetchRequest) as NSArray
            if arrResults.count > 0
            {
                for newUser in arrResults
                {
                    objUserDetail = newUser as? UserDetailCoreDataModel
                }
            }
            else
            {
                print("Failed to fetch User Detail")
            }
        }catch
        {
            print("Failed to fetch the Data")
        }
        /*let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: ChatConstants.entityName.entityLoginUserDetail)
         
         do {
         let fetchedEmployees = try context.fetch(employeesFetch) as! [UserDetailCoreDataModel]
         
         for newUser in fetchedEmployees
         {
         let objUser = newUser
         print("objUser.userId: ", objUser.userId!)
         }
         
         } catch {
         fatalError("Failed to fetch employees: \(error)")
         }*/
        return objUserDetail!
    }
    
    class func getChatInfoKey(_ projIDString: String?) -> ParticipantsListEntity?
    {
        var fetchedObjects: [Any]
        let appDelegate  : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ChatConstants.entityName.entityParticipantsListEntity)
        fetchRequest.predicate = NSPredicate(format: "(ANY participantsId contains[cd] %@)", projIDString ?? "")
        //var error: Error? = nil
        var arrChatList = NSArray()
        
        if let execute = try? context.fetch(fetchRequest) {
            fetchedObjects = execute
            arrChatList = fetchedObjects as NSArray
            if arrChatList.count > 0
            {
                let objParticipants = arrChatList[0] as! ParticipantsListEntity
                return objParticipants
            }
            else
            {
                return nil
            }
        }
        else
        {
            print("No Data Found")
            return nil
        }
    }
    
    class func checkGroupIdExists(id: String, entityName: String) -> Bool
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        //let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "group_id = %@", id)
        
        //fetchRequest.includesSubentities = false
        
        var results: [NSManagedObject] = []
        
        do {
            results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            for object in results {
                managedContext?.delete(object)
            }
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.count > 0
    }
    
    /*class func saveChatInfo(strGroupId: String, dictGroupData : NSDictionary)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entityChatInfo = NSEntityDescription.entity(forEntityName: ChatConstants.entityName.entityAllChatInfoListEntity, in: managedContext)!
               
        /*let isExistsData = self.checkGroupIdExists(id: strGroupId, entityName: ChatConstants.entityName.entityAllChatInfoListEntity)
        if isExistsData == true
        {
            print("strGroupId already exists in the Coredata: %@", strGroupId)
        }
        else
        {*/
             var objChatInfo = NSManagedObject()
            objChatInfo = NSManagedObject(entity: entityChatInfo, insertInto: managedContext)
            objChatInfo.setValue(strGroupId, forKey: "chatKey")
            
            objChatInfo.setValue((dictGroupData.value(forKey: kGroupId)), forKey: "group_id")
            objChatInfo.setValue((dictGroupData.value(forKey: kCreatedBy)), forKey: "created_By")
            objChatInfo.setValue((dictGroupData.value(forKey: kGroupCreatedOn)), forKey: "created_on")
            objChatInfo.setValue((dictGroupData.value(forKey: kGroupName)), forKey: "group_name")
            objChatInfo.setValue((dictGroupData.value(forKey: kGroupDescription)) as! String?, forKey: "group_description")
            let strImage = (dictGroupData.value(forKey: kGroupIcon)) as! String?
            objChatInfo.setValue(strImage, forKey: "group_icon")
            objChatInfo.setValue((dictGroupData.value(forKey: kChatType)), forKey: "type")
            objChatInfo.setValue((dictGroupData.value(forKey: kParticipantCount)), forKey: "participant_count")
            
            objChatInfo.setValue((dictGroupData.value(forKey: kGroupModifiedOn)), forKey: "modified_on")
            objChatInfo.setValue((dictGroupData.value(forKey: "message_time")), forKey: "messageTime")
            objChatInfo.setValue((dictGroupData.value(forKey: "text_msg")), forKey: "textMsg")
        
            do {
                try managedContext.save()
                var coreDataManagedObject: [NSManagedObject] = []
                coreDataManagedObject.append(objChatInfo)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        //}
    }*/
    
    class func saveChatInfo(strGroupId: String, arrGroupData : NSArray)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entityChatInfo = NSEntityDescription.entity(forEntityName: ChatConstants.entityName.entityAllChatInfoListEntity, in: managedContext)!
        
        var isExistsData = self.checkGroupIdExists(id: strGroupId, entityName: ChatConstants.entityName.entityAllChatInfoListEntity)
        
        isExistsData = false //saurabh
        
         if isExistsData == true
         {
            print("strGroupId already exists in the Coredata: %@", strGroupId)
         }
         else
         {
        var objChatInfo = NSManagedObject()
        objChatInfo = NSManagedObject(entity: entityChatInfo, insertInto: managedContext)
        objChatInfo.setValue(strGroupId, forKey: "chatKey")
        
        for j in 0..<arrGroupData.count
        {
            let dictGroupData = (arrGroupData[j] as AnyObject) as! NSDictionary
            objChatInfo.setValue((dictGroupData.value(forKey: kGroupId)), forKey: "group_id")
            objChatInfo.setValue((dictGroupData.value(forKey: kCreatedBy)), forKey: "created_By")
            objChatInfo.setValue((dictGroupData.value(forKey: kGroupCreatedOn)), forKey: "created_on")
            objChatInfo.setValue((dictGroupData.value(forKey: kGroupName)), forKey: "group_name")
            objChatInfo.setValue((dictGroupData.value(forKey: kGroupDescription)) as! String?, forKey: "group_description")
            let strImage = (dictGroupData.value(forKey: kGroupIcon)) as! String?
            objChatInfo.setValue(strImage, forKey: "group_icon")
            objChatInfo.setValue((dictGroupData.value(forKey: kChatType)), forKey: "type")
            objChatInfo.setValue((dictGroupData.value(forKey: kParticipantCount)), forKey: "participant_count")
            
            objChatInfo.setValue((dictGroupData.value(forKey: kGroupModifiedOn)), forKey: "modified_on")
            objChatInfo.setValue((dictGroupData.value(forKey: "message_time")), forKey: "messageTime")
            objChatInfo.setValue((dictGroupData.value(forKey: "text_msg")), forKey: "textMsg")
        }
        
        do {
            try managedContext.save()
            print("managedContext: ", managedContext)
            var coreDataManagedObject: [NSManagedObject] = []
            coreDataManagedObject.append(objChatInfo)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    }

    
    /*class func saveChatInfo(strGroupId: String, arrGroupData : NSArray)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entityChatInfo = NSEntityDescription.entity(forEntityName: ChatConstants.entityName.entityAllChatInfoListEntity, in: managedContext)!
        var objChatInfo = NSManagedObject()
        objChatInfo = NSManagedObject(entity: entityChatInfo, insertInto: managedContext)
        objChatInfo.setValue(strGroupId, forKey: "chatKey")
        
        for j in 0..<arrGroupData.count
        {
            let dictGroupData = (arrGroupData[j] as AnyObject) as! NSDictionary
            objChatInfo.setValue((dictGroupData.value(forKey: kGroupId)), forKey: "group_id")
            objChatInfo.setValue((dictGroupData.value(forKey: kCreatedBy)), forKey: "created_By")
            objChatInfo.setValue((dictGroupData.value(forKey: kGroupCreatedOn)), forKey: "created_on")
            objChatInfo.setValue((dictGroupData.value(forKey: kGroupName)), forKey: "group_name")
            objChatInfo.setValue((dictGroupData.value(forKey: kGroupDescription)) as! String?, forKey: "group_description")
            let strImage = (dictGroupData.value(forKey: kGroupIcon)) as! String?
            objChatInfo.setValue(strImage, forKey: "group_icon")
            objChatInfo.setValue((dictGroupData.value(forKey: kChatType)), forKey: "type")
            objChatInfo.setValue((dictGroupData.value(forKey: kParticipantCount)), forKey: "participant_count")
            
            objChatInfo.setValue((dictGroupData.value(forKey: kGroupModifiedOn)), forKey: "modified_on")
            objChatInfo.setValue((dictGroupData.value(forKey: "message_time")), forKey: "messageTime")
            objChatInfo.setValue((dictGroupData.value(forKey: "text_msg")), forKey: "textMsg")
        }
        
        do {
            try managedContext.save()
            var coreDataManagedObject: [NSManagedObject] = []
            coreDataManagedObject.append(objChatInfo)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }*/

    
    class func getChatInfoList() -> NSArray
    {
        //var objUserDetail : UserDetailCoreDataModel?
        let appDelegate  : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ChatConstants.entityName.entityAllChatInfoListEntity)
        fetchRequest.returnsDistinctResults = true
        fetchRequest.returnsObjectsAsFaults = false
        var arrChatList = NSArray()
        do{
            arrChatList = try context.fetch(fetchRequest) as NSArray
        }catch
        {
            print("Failed to fetch the Data")
        }
        return arrChatList
    }
    
    class func checkParticipantsExists(id: String, entityName: String) -> Bool
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        //let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "chatUniqueKey = %@", id)
        
        //fetchRequest.includesSubentities = false
        
        var results: [NSManagedObject] = []
        
        do {
            results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            for object in results {
                managedContext?.delete(object)
            }
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return results.count > 0
    }
    
    class func saveParticipantsInfo(strGroupId: String, arrParticipantsInfo : NSArray)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entityParticipants = NSEntityDescription.entity(forEntityName: ChatConstants.entityName.entityParticipantsListEntity, in: managedContext)!
        let isExistsData = self.checkParticipantsExists(id: strGroupId, entityName: ChatConstants.entityName.entityParticipantsListEntity)
//        if isExistsData == true
//        {
//            print("chatUniqueKey(Participants) already exists in the Coredata: %@", strGroupId)
//        }
//        else
//        {
        var objParticipantsList = NSManagedObject()
            objParticipantsList = NSManagedObject(entity: entityParticipants, insertInto: managedContext)
            objParticipantsList.setValue(strGroupId, forKey: "chatUniqueKey")
            for j in 0..<arrParticipantsInfo.count
            {
                let dictData = (arrParticipantsInfo[j] as AnyObject) as! NSDictionary
                
                objParticipantsList.setValue((dictData.value(forKey: kParticipantsId)), forKey: "participantsId")
                objParticipantsList.setValue((dictData.value(forKey: kParticipantsName)), forKey: "participantsName")
                objParticipantsList.setValue((dictData.value(forKey: kParticipantsPhone)), forKey: "participantsPhone")
                objParticipantsList.setValue((dictData.value(forKey: kParticipantsLocation)) as! String?, forKey: "participantsLocation")
                let strImage = (dictData.value(forKey: kParticipantsImage)) as! String?
                objParticipantsList.setValue(strImage, forKey: "participantsImage")
                objParticipantsList.setValue((dictData.value(forKey: kParticipantsShortBio)), forKey: "participantsShortBio")
                objParticipantsList.setValue((dictData.value(forKey: kIsAdmin)), forKey: "isAdmin")                
                objParticipantsList.setValue((dictData.value(forKey: kParticipantsFCMPushTokenDB)), forKey: "participantsFCMPushTokenDB")
            }
        do {
            try managedContext.save()
            var coreDataManagedObject: [NSManagedObject] = []
            coreDataManagedObject.append(objParticipantsList)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
     //   }
    }
    
    class func getParticipantsData() -> NSArray
    {
        //var objUserDetail : UserDetailCoreDataModel?
        let appDelegate  : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ChatConstants.entityName.entityParticipantsListEntity)
        fetchRequest.returnsDistinctResults = true
        fetchRequest.returnsObjectsAsFaults = false
        var arrChatList = NSArray()
        do{
            arrChatList = try context.fetch(fetchRequest) as NSArray
        }catch
        {
            print("Failed to fetch the Data")
        }
        return arrChatList
    }
    
    class func checkMessageExists(id: String, entityName: String) -> Bool
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        //let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "uniqueChatKey = %@", id)
        
        //fetchRequest.includesSubentities = false
        
        var results: [NSManagedObject] = []
        
        do {
            results = try managedContext!.fetch(fetchRequest) as! [NSManagedObject]
            for object in results {
                managedContext?.delete(object)
            }
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.count > 0
    }
    
    class func updateAllMessagesData(identifier: String, dictAllMessages : NSDictionary) -> Bool
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: ChatConstants.entityName.entityAllChatMessagesList)
        let predicate = NSPredicate(format: "uniqueChatKey = %@", identifier)
        //NSPredicate(format: "ID = '\(identifier)'")
        fetchRequest.predicate = predicate
        fetchRequest.returnsDistinctResults = true
        fetchRequest.returnsObjectsAsFaults = false
        var object: [NSManagedObject] = []
        do
        {
            object = try context.fetch(fetchRequest) as! [NSManagedObject]
            if object.count == 1
            {
                let objectUpdate = object.first
                //for j in 0..<arrAllMessagesList.count
                //{
                    let dictData = dictAllMessages//(arrAllMessagesList[j] as AnyObject) as! NSDictionary
                    objectUpdate!.setValue((dictData.value(forKey: "is_reply")), forKey: "isReplyMsg")
                    objectUpdate!.setValue((dictData.value(forKey: "message_id")), forKey: "messageId")
                    objectUpdate!.setValue((dictData.value(forKey: "message_time")), forKey: "messageTime")
                    objectUpdate!.setValue((dictData.value(forKey: "sender_company")), forKey: "senderCompany")
                    objectUpdate!.setValue((dictData.value(forKey: "sender_designation")) as! String?, forKey: "senderDesignation")
                    objectUpdate!.setValue((dictData.value(forKey: "sender_fcm_push_token")), forKey: "senderFcmToken")
                    objectUpdate!.setValue((dictData.value(forKey: "sender_id")), forKey: "senderId")
                
                    let strImage = (dictData.value(forKey: "sender_image")) as! String?
                    objectUpdate!.setValue(strImage, forKey: "senderImage")
                    objectUpdate!.setValue((dictData.value(forKey: "sender_location")), forKey: "senderLocation")
                    objectUpdate!.setValue((dictData.value(forKey: "sender_name")), forKey: "senderName")
                    objectUpdate!.setValue((dictData.value(forKey: "text_msg")), forKey: "textMessage")
                    do{
                        try context.save()
                    }
                    catch
                    {
                        print("error executing fetch request: \(error)")
                    }
                //}
            }
        }
        catch
        {
            print(error)
        }
        return object.count > 0
    }
    
    /*class func saveAllMessages(strUniqueKey: String, dictAllMessages : NSDictionary)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: ChatConstants.entityName.entityAllChatMessagesList, in: managedContext)!
        
        //        let isExistsData = self.checkMessageExists(id: strUniqueKey, entityName: ChatConstants.entityName.entityAllChatMessagesList)
        let isExistsData = self.updateAllMessagesData(identifier: strUniqueKey, dictAllMessages: dictAllMessages)
        if isExistsData == true
        {
            print("update the record of the All Messages: %@", strUniqueKey)
        }
        else
        {
            var objMessages = NSManagedObject()
            objMessages = NSManagedObject(entity: entity, insertInto: managedContext)
            objMessages.setValue(strUniqueKey, forKey: "uniqueChatKey")
            //for j in 0..<arrAllMessagesList.count
            //{
                let dictData = dictAllMessages//(arrAllMessagesList[j] as AnyObject) as! NSDictionary
                
                objMessages.setValue((dictData.value(forKey: "is_reply")), forKey: "isReplyMsg")
                objMessages.setValue((dictData.value(forKey: "message_id")), forKey: "messageId")
                objMessages.setValue((dictData.value(forKey: "message_time")), forKey: "messageTime")
                objMessages.setValue((dictData.value(forKey: "sender_company")), forKey: "senderCompany")
                objMessages.setValue((dictData.value(forKey: "sender_designation")) as! String?, forKey: "senderDesignation")
                objMessages.setValue((dictData.value(forKey: "sender_fcm_push_token")), forKey: "senderFcmToken")
                objMessages.setValue((dictData.value(forKey: "sender_id")), forKey: "senderId")
                
                let strImage = (dictData.value(forKey: "sender_image")) as! String?
                objMessages.setValue(strImage, forKey: "senderImage")
                objMessages.setValue((dictData.value(forKey: "sender_location")), forKey: "senderLocation")
                objMessages.setValue((dictData.value(forKey: "sender_name")), forKey: "senderName")
                objMessages.setValue((dictData.value(forKey: "text_msg")), forKey: "textMessage")
            //}
            do {
                try managedContext.save()
                var coreDataManagedObject: [NSManagedObject] = []
                coreDataManagedObject.append(objMessages)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }*/
    
    class func saveAllMessages(strUniqueKey: String, arrAllMessagesList : NSMutableArray)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: ChatConstants.entityName.entityAllChatMessagesList, in: managedContext)!
        
        let isExistsData = self.checkMessageExists(id: strUniqueKey, entityName: ChatConstants.entityName.entityAllChatMessagesList)
       //let isExistsData = self.updateAllMessagesData(identifier: strUniqueKey, arrAllMessagesList: arrAllMessagesList)
//        if isExistsData == true
//        {
//            print("update the record of the All Messages: %@", strUniqueKey)
//        }
//        else
//        {
        var objMessages = NSManagedObject()
        objMessages = NSManagedObject(entity: entity, insertInto: managedContext)
        objMessages.setValue(strUniqueKey, forKey: "uniqueChatKey")
        for j in 0..<arrAllMessagesList.count
        {
            let dictData = (arrAllMessagesList[j] as AnyObject) as! NSDictionary
            
            objMessages.setValue((dictData.value(forKey: "is_reply")), forKey: "isReplyMsg")
            objMessages.setValue((dictData.value(forKey: "message_id")), forKey: "messageId")
            objMessages.setValue((dictData.value(forKey: "message_time")), forKey: "messageTime")
            objMessages.setValue((dictData.value(forKey: "sender_company")), forKey: "senderCompany")
            objMessages.setValue((dictData.value(forKey: "sender_designation")) as! String?, forKey: "senderDesignation")
            objMessages.setValue((dictData.value(forKey: "sender_fcm_push_token")), forKey: "senderFcmToken")
            objMessages.setValue((dictData.value(forKey: "sender_id")), forKey: "senderId")
            
            let strImage = (dictData.value(forKey: "sender_image")) as! String?
            objMessages.setValue(strImage, forKey: "senderImage")
            objMessages.setValue((dictData.value(forKey: "sender_location")), forKey: "senderLocation")
            objMessages.setValue((dictData.value(forKey: "sender_name")), forKey: "senderName")
            objMessages.setValue((dictData.value(forKey: "text_msg")), forKey: "textMessage")
        }
        do {
            try managedContext.save()
            var coreDataManagedObject: [NSManagedObject] = []
            coreDataManagedObject.append(objMessages)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
       // }
    }
    
    class func getAllChatMessagesData() -> NSArray
    {
        let appDelegate  : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ChatConstants.entityName.entityAllChatMessagesList)
        fetchRequest.returnsDistinctResults = true
        fetchRequest.returnsObjectsAsFaults = false
        var arrMessagesList = NSArray()
        do{
            arrMessagesList = try context.fetch(fetchRequest) as NSArray
            if arrMessagesList.count > 0
            {
                //print("Messages Data: ", arrMessagesList)
            }
            else
            {
                print("Failed to fetch User Detail")
            }
        }catch
        {
            print("Failed to fetch the Data")
        }
        return arrMessagesList
    }
    
    class func savePhoneContactList(arrayContacts : NSArray, strIsLogin: String)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: ChatConstants.entityName.entityPhoneContactDetail, in: managedContext)!
        let phoneContactDetail = NSManagedObject(entity: entity, insertInto: managedContext)
        
        for i in 0..<arrayContacts.count
        {
            let dict = (arrayContacts[i] as AnyObject) as! NSDictionary
            phoneContactDetail.setValue(dict.value(forKey:"Name"), forKey: "name")
            phoneContactDetail.setValue(dict.value(forKey:"Number"), forKey: "number")
            phoneContactDetail.setValue(dict.value(forKey:"isExist"), forKey: "isExist")
            if strIsLogin == "0"
            {
                phoneContactDetail.setValue("", forKey: "userId")
                phoneContactDetail.setValue("", forKey: "userName")
                phoneContactDetail.setValue("", forKey: "cityName")
                phoneContactDetail.setValue("", forKey: "countryCode")
                phoneContactDetail.setValue("", forKey: "countryName")
                phoneContactDetail.setValue("", forKey: "shortBio")
                phoneContactDetail.setValue("", forKey: "userImage")
                phoneContactDetail.setValue("", forKey: "companyName")
                phoneContactDetail.setValue("", forKey: "interests")
                phoneContactDetail.setValue("", forKey: "industry")
                phoneContactDetail.setValue("", forKey: "designation")
                phoneContactDetail.setValue("", forKey: "userEmail")
                phoneContactDetail.setValue("", forKey: "institute")
                phoneContactDetail.setValue("", forKey: "phone")
                phoneContactDetail.setValue("", forKey: "fcmPushToken")
                phoneContactDetail.setValue("", forKey: "isVerified")
                phoneContactDetail.setValue("", forKey: "isLogin")
                phoneContactDetail.setValue("", forKey: "deviceId")
                phoneContactDetail.setValue("", forKey: "createdOn")
                phoneContactDetail.setValue("", forKey: "modifiedOn")
            }
            else if strIsLogin == "1"
            {
                
            }
            
        }
        //print("Core Data Saved User:",  phoneContactDetail.value(forKeyPath: "name") as! String)
        
        //loginUserDetail.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            var coreDataManagedObject: [NSManagedObject] = []
            coreDataManagedObject.append(phoneContactDetail)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    class func getContactList() -> NSArray
    {
        //self.resetAllRecords(in: ChatConstants.entityName.entityPhoneContactDetail)
        let appDelegate  : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ChatConstants.entityName.entityPhoneContactDetail)
        fetchRequest.returnsDistinctResults = true
        fetchRequest.returnsObjectsAsFaults = false
        var arrContactList = NSArray()
        do{
            arrContactList = try context.fetch(fetchRequest) as NSArray
        }catch
        {
            print("Failed to fetch the Data")
        }
        return arrContactList
    }
    
    class func resetAllRecords(in entity : String) // entity = Your_Entity_Name
    {
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print ("There was an error")
        }
    }
        
    class func saveAllChatUserList(arrChatList : NSMutableArray, arrChatKeyInfo: NSMutableArray, arrLastMessages: NSMutableArray, dictParticipantsData : NSMutableDictionary)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: ChatConstants.entityName.entityAllChatUserList, in: managedContext)!
        var objChatList = NSManagedObject()
        
        for i in 0..<arrChatKeyInfo.count
        {
            objChatList = NSManagedObject(entity: entity, insertInto: managedContext)
            for j in 0..<arrLastMessages.count
            {
            objChatList.setValue(arrChatKeyInfo[i], forKey: "userChatKey")
            
            let strType = ((arrChatList[i] as AnyObject).value(forKey: "type")) as! String
            objChatList.setValue(strType, forKey: "chatType")
            
            objChatList.setValue(((arrChatList[i] as AnyObject).value(forKey: "group_name")) as? String, forKey: "groupName")
            let strImage = ((arrChatList[i] as AnyObject).value(forKey: "group_icon")) as? String
            objChatList.setValue(strImage, forKey: "groupIcon")
            //objChatList.setValue(((arrChatList[i] as AnyObject).value(forKey: "group_id")) as? String, forKey: "groupId")
            let strCellGroupId = ((arrChatList[i] as AnyObject).value(forKey: "group_id")) as? String
            objChatList.setValue(strCellGroupId, forKey: "groupId")
            
            if strType == "0"
            {
                //let objParticipants = ParticipantsListEntity.init(context: dictParticipantsData.value(forKey: strCellGroupId!) as! NSManagedObjectContext)
                let objParticipants =   Participants.init(dictionary: dictParticipantsData.value(forKey: strCellGroupId!)  as! NSDictionary)!
                objChatList.setValue(objParticipants.participantsName!, forKey: "participantsName")
                objChatList.setValue(objParticipants.participantsId!, forKey: "participantsId")
                objChatList.setValue(objParticipants.participantsImage!, forKey: "participantsImage")
            }
            else if strType == "1"
            {
                let dict : NSDictionary = ((arrChatList[i] as AnyObject) as! NSDictionary)
                objChatList.setValue((dict.value(forKey: "group_name")) as? String, forKey: "groupName")
                let strImage = (dict.value(forKey: "group_icon")) as? String
                objChatList.setValue(strImage, forKey: "groupIcon")
                objChatList.setValue((dict.value(forKey: "group_id")) as? String, forKey: "groupId")
            }
            
                let objAllMessages = AllMessages.init(dictionary: arrLastMessages[j] as! NSDictionary)!
                objChatList.setValue(objAllMessages.textMessage, forKey: "lastMessage")
                objChatList.setValue(objAllMessages.messageTime, forKey: "lastMessageTime")
                objChatList.setValue(objAllMessages.messageId, forKey: "lastMessageId")
                //objChatList.setValue("", forKey: "isSeenMsg")
            }
            //print("objChatList: ", objChatList)
        }
        do {
            try managedContext.save()
            var coreDataManagedObject: [NSManagedObject] = []
            coreDataManagedObject.append(objChatList)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        //print("Core Data Saved User:",  loginUserDetail.value(forKeyPath: "userName") as! String)
        //print("objChatList: ", objChatList)
    }
    
    class func getChatListData() -> NSArray
    {
        //var objUserDetail : UserDetailCoreDataModel?
        let appDelegate  : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ChatConstants.entityName.entityAllChatUserList)
        fetchRequest.returnsDistinctResults = true
        fetchRequest.returnsObjectsAsFaults = false
        var arrChatList = NSArray()
        do{
            arrChatList = try context.fetch(fetchRequest) as NSArray
        }catch
        {
            print("Failed to fetch the Data")
        }
        return arrChatList
    }
    
    class func getParticipantsUniqueKey(_ projIDString: String?) -> ParticipantsListEntity?
    {
        var fetchedObjects: [Any]
        let appDelegate  : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ChatConstants.entityName.entityParticipantsListEntity)
        fetchRequest.predicate = NSPredicate(format: "(ANY participantsId contains[cd] %@)", projIDString ?? "")
        //var error: Error? = nil
        var arrChatList = NSArray()
        
        if let execute = try? context.fetch(fetchRequest) {
            fetchedObjects = execute
            arrChatList = fetchedObjects as NSArray
            if arrChatList.count > 0
            {
                let objParticipants = arrChatList[0] as! ParticipantsListEntity
                return objParticipants
            }
            else
            {
                return nil
            }
        }
        else
        {
            print("No Data Found")
            return nil
        }
    }
}
