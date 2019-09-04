//
//  Institute.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 04/02/2019.
//  Copyright © 2019 Swati. All rights reserved.
//

import UIKit

class Institute: NSObject {
    
    public var instituteName : String?
    public var institutePassingYear : String?
    
    public required override init()
    {
        super.init()
    }
    
    // MARK: - NSCoding Methods
    public required init(coder aDecoder: NSCoder)
    {
        self.instituteName = aDecoder.decodeObject(forKey: kInstituteName) as? String
        self.institutePassingYear = aDecoder.decodeObject(forKey: kInstitutePassingYear) as? String
    }
    
    func initWithCoder(aDecoder: NSCoder) -> Institute
    {
        self.instituteName = aDecoder.decodeObject(forKey: kInstituteName) as? String
        self.institutePassingYear = aDecoder.decodeObject(forKey: kInstitutePassingYear) as? String
        
        return self
    }
    
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.instituteName, forKey: kInstituteName)
        aCoder.encode(self.institutePassingYear, forKey: kInstitutePassingYear)
    }
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Institute]
    {
        var models:[Institute] = []
        for item in array
        {
            models.append(Institute(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary)
    {
        instituteName = dictionary[kInstituteName] as? String
        institutePassingYear = dictionary[kInstitutePassingYear] as? String
    }
    
    public  func dictionaryDetails(dictionary:NSMutableDictionary) -> NSMutableDictionary
    {
        dictionary.setValue(self.instituteName, forKey: kInstituteName)
        dictionary.setValue(self.institutePassingYear, forKey: kInstitutePassingYear)
        
        return dictionary
    }
    
    /*public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.instituteName, forKey: kInstituteName)
        dictionary.setValue(self.institutePassingYear, forKey: kInstitutePassingYear)
        
        return dictionary
    }*/

}
