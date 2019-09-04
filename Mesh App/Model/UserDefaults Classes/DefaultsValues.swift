//
//  DefaultsValues.swift
//  Locatem
//
//  Created by Mac admin on 15/05/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import Foundation

class DefaultsValues : NSObject
{
     let defaults = UserDefaults.standard
    // MARK: -
    // MARK: - Defaults Dictionary Values
    
    class func setUserValueToUserDefaults(_ userValue: NSDictionary?, forKey strKey: String?)
    {
        //if(UserDefaults.standard.object(forKey: strKey!) == nil)
       // UserDefaults.standard
        //{

            if let aValue = userValue {
                UserDefaults.standard.setValue(NSKeyedArchiver.archivedData(withRootObject: aValue), forKey: strKey!)
            }
            UserDefaults.standard.synchronize()
        //}
    }
    
    class func getUserValueFromUserDefaults_(forKey strKey: String?) ->NSDictionary?
    {
        var dict: NSDictionary? = nil
        var data: Data?
        //if(UserDefaults.standard.object(forKey: strKey!) == nil) {
            data = UserDefaults.standard.value(forKey: strKey ?? "") as? Data
            if let aData = data {
                dict = NSKeyedUnarchiver.unarchiveObject(with: aData) as? NSDictionary
            }
            UserDefaults.standard.synchronize()
        //}
        return dict
    }
    
    // MARK: -
    // MARK: - Defaults String Values
    class func setStringValueToUserDefaults(_ strValue: String?, forKey strKey: String?)
    {
       // if(UserDefaults.standard.object(forKey: strKey!) == nil)
        //{
        //if UserDefaults.standard {
            UserDefaults.standard.setValue("\(strValue ?? "")", forKey: strKey!)
            UserDefaults.standard.synchronize()
        //}
    }
    
    class func getStringValueFromUserDefaults_(forKey strKey: String?) -> String? {
        var s: String?
        //if(UserDefaults.standard.object(forKey: strKey!) == nil) {
            s = UserDefaults.standard.value(forKey: strKey ?? "") as? String
        //}
        return s
    }
    
    // MARK: - Defaults Integer Values
    class func setIntegerValueToUserDefaults(_ intValue: Int, forKey intKey: String?) {
        if(UserDefaults.standard.object(forKey: intKey!) == nil){
            UserDefaults.standard.set(intValue, forKey: intKey ?? "")
            UserDefaults.standard.synchronize()
        }
    }
    
    class func getIntegerValueFromUserDefaults_(forKey intKey: String?) -> Int {
        var i: Int = 0
        if(UserDefaults.standard.object(forKey: intKey!) == nil){
            i = UserDefaults.standard.integer(forKey: intKey!)
        }
        return i
    }
    
    // MARK: - Defaults Boolean Values
    class func setBooleanValueToUserDefaults(_ booleanValue: Bool, forKey booleanKey: String?) {
        if(UserDefaults.standard.object(forKey: booleanKey!) == nil) {
            UserDefaults.standard.set(booleanValue, forKey: booleanKey ?? "")
            UserDefaults.standard.synchronize()
        }
    }
    
    class func getBooleanValueFromUserDefaults_(forKey booleanKey: String?) -> Bool {
        var b = false
        if(UserDefaults.standard.object(forKey: booleanKey!) == nil) {
            b = UserDefaults.standard.bool(forKey: booleanKey ?? "")
        }
        return b
    }
    
    // MARK: - Defaults Custom Object Values
    class func setCustomObjToUserDefaults(_ CustomObj: Any?, forKey CustomObjKey: String?)
    {
        UserDefaults.standard.setCustomObject(CustomObj, forKey: CustomObjKey)
        UserDefaults.standard.synchronize()
    }
    
    class func getCustomObjFromUserDefaults_(forKey CustomObjKey: String?) -> Any?
    {
        return UserDefaults.standard.customObject(forKey: CustomObjKey)
    }
    
    // MARK: - Remove Defaults Values
    class func removeObject(forKey objectKey: String)
    {
        UserDefaults.standard.removeObject(forKey: objectKey)
        UserDefaults.standard.synchronize()
    }
    
    /*class func hasValue(forKey key: String) -> Bool {
        return nil != object(forKey: key)
    }*/
}
