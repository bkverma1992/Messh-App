//
//  NSUserDefaults+SaveCustomObject.swift
//  Locatem
//
//  Created by Mac admin on 17/05/18.
//  Copyright © 2018 Swati. All rights reserved.
//
import Foundation
import UIKit

extension UserDefaults
{
    static let messagesKey = "mockMessages"
    
    // MARK: - Mock Messages
    
    func setMockMessages(count: Int) {
        set(count, forKey: "mockMessages")
        synchronize()
    }
    
    func mockMessagesCount() -> Int {
        if let value = object(forKey: "mockMessages") as? Int {
            return value
        }
        return 20
    }
   
    func setCustomObject(_ obj: Any?, forKey key: String?) {
        defer {
        }
        do
        {
            if (obj as AnyObject).responds(to: #selector(NSCoding.encode(with:))) == false
            {
                print("Error save object to NSUserDefaults. Object must respond to encodeWithCoder: message")
                //throw exception
                return
            }
            
            let userDefaults = UserDefaults.standard
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: obj as Any)
            userDefaults.set(encodedData, forKey: key!)
            userDefaults.synchronize()
            
//            var encodedObject: Data? = nil
//            if let anObj = obj {
//                encodedObject = NSKeyedArchiver.archivedData(withRootObject: anObj)
//            }
//            let defaults = UserDefaults.standard
//            defaults.set(encodedObject, forKey: key ?? "")
            //defaults.synchronize()
        }
        /*catch let exception
        {
            print("error in defaults", exception)
        }*/
    }
    
    func customObject(forKey key: String?) -> Any?
    {
        let defaults = UserDefaults.standard
        let encodedObject = defaults.object(forKey: key ?? "") as? Data
        var obj: Any? = nil
        if let anObject = encodedObject {
            obj = NSKeyedUnarchiver.unarchiveObject(with: anObject)
        }
        return obj
    }
}
