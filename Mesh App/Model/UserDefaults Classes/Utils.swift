//
//  Utils.h
//  QR Reader
//
//  Created by JAYANT SAXENA on 31/01/12.
//  Copyright 2012 LSquare Technologies. All rights reserved.
//
import Foundation
import UIKit
import FirebaseDatabase

let TAGS_MARGIN = 10
let TAGS_BUTTON_HEIGHT = 10

class Utils: NSObject {
    
    class func getCurrentDateAndTimeInFormatWithSeconds() -> String
    {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"//"yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: now)
        return dateString
    }
    
    class func getCurrentDateAndTimeInFormatWithoutSeconds() -> String
    {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd hh:mm a"//"yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: now)
        return dateString
    }
    
    class func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    class func convertTimestamp(serverTimestamp: Double) -> String
    {
        let x = serverTimestamp / 1000
        let date = Date(timeIntervalSince1970: x)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        formatter.timeZone = NSTimeZone.local

        formatter.dateFormat = "yyyy-MM-dd hh:mm a"
        let time = formatter.string(from: date as Date)
        return time
    }
    
    
    class func convertTimestampForChatHome(serverTimestamp: Double) -> String
    {
        let x = serverTimestamp / 1000
        let calendar = Calendar.current
        let date = Date(timeIntervalSince1970: x)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        formatter.timeZone = NSTimeZone.local
        
        if calendar.isDateInYesterday(date)
        {
            return "Yesterday"
        }
        else if calendar.isDateInToday(date)
        {
            formatter.dateFormat = "hh:mm a" //"yyyy-MM-dd hh:mm a"
            let time = formatter.string(from: date as Date)
            return time
            //return "Today"
        }
        else
        {
            formatter.dateFormat = "dd/MM/yy" //"yyyy-MM-dd hh:mm a"
            let time = formatter.string(from: date as Date)
            return time
        }
        /*else if calendar.isDateInTomorrow(date)
         {
         return "Tomorrow"
         }*/
    }
    
    /*class func getFirebaseServerTimestamp() -> TimeInterval
    {
        let ref = Database.database().reference()
        ref.setValue(ServerValue.timestamp())
        var currentTimeStamp : TimeInterval?
        ref.observe(.value, with: { snap in
            if let t = snap.value as? TimeInterval {
                currentTimeStamp = t
                //let currentTimeStamp = t/1000
                /*let date = NSDate(timeIntervalSince1970: currentTimeStamp)
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                formatter.timeStyle = .medium
                formatter.timeZone = NSTimeZone.local
                formatter.dateFormat = "hh:mm a"
                let time = formatter.string(from: date as Date)
                print("time: ", time)*/
            }
        })
        return currentTimeStamp ?? 1234567890
    }*/
    
    class func getCurrentDateAndTimeWithoutSeconds() -> String
    {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd hh:mm a"//"yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: now)
        return dateString
    }

    class func getActivityTimeInFormat(for time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm a"
            //@"EEE, dd MMM yyyy HH:mm:ss Z"];
        var myDate = dateFormatter.date(from: time)!
        let refDateString = myDate.description.substring(to: myDate.description.index(myDate.description.startIndex, offsetBy: 16))
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        myDate = dateFormatter.date(from: refDateString)!
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm a"
        //[dateFormatter setDateFormat:@"dd MMM yyyy"];
        print("\("on \(dateFormatter.string(from: myDate))")")
      //  print("\("on \(dateFormatter.string(from: myDate))")")
        return "\("on \(dateFormatter.string(from: myDate))")"
    }
    
    class func getDateInFormat(_ time : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var myDate = Date()
        let refDateString = myDate.description.substring(to: myDate.description.index(myDate.description.startIndex, offsetBy: 10))
        dateFormatter.dateFormat = "yyyy-MM-dd"
        myDate = dateFormatter.date(from: refDateString)!
        let finaldate:String = (dateFormatter.string(from: myDate))
        return finaldate
    }

    class func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
         //dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            //@"EEE, dd MMM yyyy HH:mm:ss Z"];
        var myDate = Date()
        let refDateString = myDate.description.substring(to: myDate.description.index(myDate.description.startIndex, offsetBy: 10))
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        myDate = dateFormatter.date(from: refDateString)!
        //dateFormatter.dateFormat = "dd MMM yyyy"
        let finaldate:String = (dateFormatter.string(from: myDate)) 
        return finaldate
    }
    
    class func getCurrentDateForThankyouVC() -> String {
        

        let formatter = DateFormatter()
        //formatter.dateFormat = "h:mm a 'on' MMMM dd, yyyy"
        formatter.dateFormat = "dd'nd' MMMM,yyyy | h:mm a"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        
        let dateString = formatter.string(from: Date())
        print(dateString)   // "4:44 PM on June 23, 2016\n"
        
        return dateString
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = NSLocale.current
//        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm a"
//        //@"EEE, dd MMM yyyy HH:mm:ss Z"];
//        var myDate = Date()
//        let refDateString = myDate.description.substring(to: myDate.description.index(myDate.description.startIndex, offsetBy: 10))
//        
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        myDate = dateFormatter.date(from: refDateString)!
//        
//        myDate = dateFormatter.date(from: refDateString)!
//        
//        dateFormatter.dateFormat = "dd"
//        let dateStr = (dateFormatter.string(from: myDate))
//        
//        dateFormatter.dateFormat = "MMMM"
//        let monthStr = (dateFormatter.string(from: myDate))
//
//        
//        dateFormatter.dateFormat = "yyyy"
//        let yearStr = (dateFormatter.string(from: myDate))
//
//        
//     
//       let refTimeString = myDate.description.substring(from: myDate.description.index(myDate.description.startIndex, offsetBy: 12))
//        
//        let finaldate = String.init(format: "%@nd %@,%@ | %@", dateStr,monthStr,yearStr,refTimeString)
//        return finaldate
    }
    
    
    class func getBookSheetDate(_ time : String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd"

        var myDate = dateFormatter.date(from: time)!
        let refDateString = myDate.description.substring(to: myDate.description.index(myDate.description.startIndex, offsetBy: 10))
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        myDate = dateFormatter.date(from: refDateString)!
        dateFormatter.dateFormat = "dd"
        let dateStr = (dateFormatter.string(from: myDate))

        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.date(from: time)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: todayDate)
        let weekDay = myComponents.weekday
        //print(weekDay)
        let dayStr = Utils.getDayWithDate(_dayValue: weekDay!)
        let finaldateStr = String.init(format: "%@\n%@", dateStr,dayStr)
        
        return finaldateStr

    }
    
    class func getDayWithDate(_dayValue : NSInteger) -> String {
        switch _dayValue {
        case 1:
            return "SUN"
            
        case 2:
             return "MON"
            
        case 3:
             return "TUE"
            
        case 4:
             return "WED"
            
        case 5:
             return "THU"
            
        case 6:
             return "FRI"
            
        case 7:
             return "SAT"
            
        default:
            return ""
            
        }
    }
    
    class func getBirthDate(_ time : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //@"EEE, dd MMM yyyy HH:mm:ss Z"];
        var myDate = dateFormatter.date(from: time)!
        let refDateString = myDate.description.substring(to: myDate.description.index(myDate.description.startIndex, offsetBy: 10))
        dateFormatter.dateFormat = "yyyy-MM-dd"
        myDate = dateFormatter.date(from: refDateString)!
        dateFormatter.dateFormat = "dd,MMM"
        let finaldate:String = (dateFormatter.string(from: myDate))
        return finaldate
    }
    
    class func getReverseDate(_ time : String) -> String {
        
        
        let array = time.components(separatedBy: "-")
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = NSLocale.current
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        //@"EEE, dd MMM yyyy HH:mm:ss Z"];
//        var myDate = dateFormatter.date(from: time)!
//        let refDateString = myDate.description.substring(to: myDate.description.index(myDate.description.startIndex, offsetBy: 10))
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        myDate = dateFormatter.date(from: refDateString)!
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//        
//        let finaldate:String = (dateFormatter.string(from: myDate))
        let final =  String.init(format: "%@/%@/%@",array[2],array[1],array[0])
        return final
    }
    class func getProfileBirthDate(_ time : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //@"EEE, dd MMM yyyy HH:mm:ss Z"];
        var myDate = dateFormatter.date(from: time)!
        let refDateString = myDate.description.substring(to: myDate.description.index(myDate.description.startIndex, offsetBy: 10))
        dateFormatter.dateFormat = "yyyy-MM-dd"
        myDate = dateFormatter.date(from: refDateString)!
        dateFormatter.dateFormat = "dd,MMM,yyyy"
        let finaldate:String = (dateFormatter.string(from: myDate))
        return finaldate
    }
    
    class func getTimeInFormat(for time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            //@"EEE, dd MMM yyyy HH:mm:ss Z"];
        var myDate = dateFormatter.date(from: time)!
        let refDateString = myDate.description.substring(to: myDate.description.index(myDate.description.startIndex, offsetBy: 10))
        dateFormatter.dateFormat = "yyyy-MM-dd"
        myDate = dateFormatter.date(from: refDateString)!
        dateFormatter.dateFormat = "dd MMM yyyy"
        return "\(dateFormatter.string(from: myDate))"
        
    }

    class func getLastSavedServerData(forKey key: String) -> Data {
        let fileManager = FileManager.default
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = NSURL(fileURLWithPath: documentsPath).appendingPathComponent(key)!.absoluteString
        print("Get Path: \(filePath)")
        //_ = fileManager.fileExists(atPath: filePath)
        print(fileManager.fileExists(atPath: filePath))
        print(fileManager.isReadableFile(atPath: filePath))
        print(fileManager.isWritableFile(atPath: filePath))
        print(fileManager.isExecutableFile(atPath: filePath))
        print(fileManager.isDeletableFile(atPath: filePath))
       
        let dataRetrive:Data = fileManager.contents(atPath: filePath)!
        if fileManager.fileExists(atPath: filePath) {
            var dataRetrive:Data
            dataRetrive = fileManager.contents(atPath: filePath)!
            print("Bytes: \(UInt(dataRetrive.count))")
            return dataRetrive
        }
        return Data()
    }

    class func saveServerData(_ json: Any, forKey key: String) -> Bool {
        let data = NSKeyedArchiver.archivedData(withRootObject: json)
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir = paths[0]
        let savedPath = NSURL(fileURLWithPath: documentsDir).appendingPathComponent(key)!.absoluteString
        print("Save Path: \(savedPath)")
        return NSKeyedArchiver.archiveRootObject(data, toFile: savedPath)
    }
    class func isUserLoggedIntoFloost() -> Bool {
        return UserDefaults.standard.bool(forKey: "LoggedIntoFloost")
    }
    class func deleteallSavedData() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dirContents = try! FileManager.default.contentsOfDirectory(atPath: documentsPath)
        for _: String in dirContents {
            do {
                try FileManager.default.removeItem(atPath: documentsPath)

            }
            catch let _ {
            }
        }
    }

    class func userNameForFloost() -> String {
        return (UserDefaults.standard.value(forKey: "userName") as! String)
    }

    class func passwordForFloost() -> String {
        return (UserDefaults.standard.value(forKey: "password") as! String)
    }
   
    class func setUserName(_ userName: String) {
        return UserDefaults.standard.set(userName, forKey: "userName")
    }

    class func setPassword(_ password: String) {
        return UserDefaults.standard.set(password, forKey: "password")
    }

    class func setLoggedIntoFloost(_ val: Bool) {
        return UserDefaults.standard.set(val, forKey: "LoggedIntoFloost")
    }

    class func connected() -> Bool {
  
        return true
       
    }
    class func getgroupDisscussionPostTime(_ time : String) -> String {
        
        //2017-07-05T17:55:28.000Z
        if time != nil && time != "" {
            
            let dateFormatter = DateFormatter()
            let tempLocale = dateFormatter.locale // save locale temporarily
            //dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let date = dateFormatter.date(from: time)!
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            dateFormatter.locale = tempLocale // reset the locale
            let dateString = dateFormatter.string(from: date)
            print("EXACT_DATE : \(dateString)")
            
            let  myDate = dateFormatter.date(from: dateString)
            //            let timeZone = NSTimeZone(name: "UTC")
            //            timeZone = NSTimeZone.local
            //            timeZone = NSTimeZone.default
            // dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
            
            var diff: Double = Date().timeIntervalSince(myDate!)
            diff = diff / 60
            if diff <= 60 {
                if diff < 2.0 {
                    return "a minute ago"
                }
                return "\(Int(diff)) minutes ago"
            }
            else if diff > 60 && diff <= (60 * 10) {
                if Int(diff / 60.0) < 2 {
                    return "1 hour ago"
                }
                return "\(Int(diff / 60.0)) hour ago"
            }
            else if diff > (60 * 10) && diff < (60 * 24) {
                let today = Date()
                let yesterday = Date(timeIntervalSinceNow: -86400)
                let todayString: String? = (today.description as? NSString)?.substring(to: 10)
                let yesterdayString: String? = (yesterday.description as? NSString)?.substring(to: 10)
                let refDateString: String? = (myDate?.description as NSString?)?.substring(to: 10)
                if (refDateString == todayString) {
                    dateFormatter.dateFormat = "hh:mm a"
                    return "Today \(dateFormatter.string(from: myDate!))"
                }
                else{
                    return "\(Int(diff / 60.0)) hours ago"
                }
                //                else if (refDateString == yesterdayString) {
                //                    dateFormatter.dateFormat = "E,d MMM yyyy hh:mm a"
                //                    return "\(dateFormatter.string(from: myDate!))"
                //                }
            }
            else if diff > (60 * 24) && diff < (60 * 24 * 30) {
                
                return "\(Int(diff / (60 * 24))) days ago"
                
            }
            else if diff > (60 * 24 * 30) && diff < (60 * 24 * 30 * 12) {
                
                return "\(Int(diff / (60 * 24 * 30))) month ago"
            }
            
            dateFormatter.dateFormat = "E,d MMM yyyy hh:mm a"
            return "\(dateFormatter.string(from: myDate!))"
        }
        return ""
    }
    class func getPostDirectionTime(_ time : String) -> String {
        
        
        if time != nil && time != "" {
            
            let dateFormatter = DateFormatter()
            
          //  2017-06-14 17:21:23 UTC
            dateFormatter.locale = NSLocale.current
            
            let timeArr = time.components(separatedBy: " ")
            let str  = String.init(format: "%@ %@",timeArr.first!,timeArr[1])
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let  myDate = dateFormatter.date(from: str)
//            let timeZone = NSTimeZone(name: "UTC")
//            timeZone = NSTimeZone.local
//            timeZone = NSTimeZone.default
            dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
            
            var diff: Double = Date().timeIntervalSince(myDate!)
            diff = diff / 60
            if diff <= 60 {
                if diff < 2.0 {
                    return "a minute ago"
                }
                return "\(Int(diff)) minutes ago"
            }
            else if diff > 60 && diff <= (60 * 10) {
                if Int(diff / 60.0) < 2 {
                    return "1 hour ago"
                }
                return "\(Int(diff / 60.0)) hours ago"
            }
            else if diff > (60 * 10) && diff < (60 * 24) {
                let today = Date()
                let yesterday = Date(timeIntervalSinceNow: -86400)
                let todayString: String? = (today.description as? NSString)?.substring(to: 10)
                let yesterdayString: String? = (yesterday.description as? NSString)?.substring(to: 10)
                let refDateString: String? = (myDate?.description as NSString?)?.substring(to: 10)
                if (refDateString == todayString) {
                    dateFormatter.dateFormat = "hh:mm a"
                    return "Today \(dateFormatter.string(from: myDate!))"
                }
                else{
                   return "\(Int(diff / 60.0)) hours ago" 
                }
//                else if (refDateString == yesterdayString) {
//                    dateFormatter.dateFormat = "E,d MMM yyyy hh:mm a"
//                    return "\(dateFormatter.string(from: myDate!))"
//                }
            }
            else if diff > (60 * 24) && diff < (60 * 24 * 30) {
                
                return "\(Int(diff / (60 * 24))) days ago"
                
            }
            else if diff > (60 * 24 * 30) && diff < (60 * 24 * 30 * 12) {
                
                return "\(Int(diff / (60 * 24 * 30))) month ago"
            }
            
            dateFormatter.dateFormat = "E,d MMM yyyy hh:mm a"
            return "\(dateFormatter.string(from: myDate!))"
        }
        return ""
    }

    class func validateEmail(_ candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        print(emailTest.evaluate(with: candidate))
        return emailTest.evaluate(with: candidate)
    }

    class func validateUrl(_ candidate: String) -> Bool {
        let urlRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let urlTest = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
        return urlTest.evaluate(with: candidate)
    }

    class func validateContact(_ mobileNo: String) -> Bool {
        let mobileNumberPattern = "[789][0-9]{9}"
        let mobileNumberPred = NSPredicate(format: "SELF MATCHES %@", mobileNumberPattern)
        let matched = mobileNumberPred.evaluate(with: mobileNo)
        return matched
    }
    
    class func validatePin(_ pinNo: String) -> Bool {
        let pinNoPattern = "[0-9]{4}"
        let pinNoPred = NSPredicate(format: "SELF MATCHES %@", pinNoPattern)
        let matched = pinNoPred.evaluate(with: pinNo)
        return matched
    }
 
    class func addFlashingOf(_ view: UIView) {
    }

    class func removeFlashingOf(_ view: UIView) {
    }

    class func resize(_ image: UIImage) -> UIImage {
        var actualHeight: CGFloat = CGFloat(image.size.height)
        var actualWidth: CGFloat = CGFloat(image.size.width)
        let maxHeight: CGFloat = 300.0
        let maxWidth: CGFloat = 300.0
        var imgRatio: CGFloat = actualWidth / actualHeight
        let maxRatio: CGFloat = maxWidth / maxHeight
        let compressionQuality: CGFloat = 0.25
      
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
               
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
     
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: actualWidth, height: actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        _ = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(image, 0.0)
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!)!
    }

    class func getheightForLabel(_ text:String, font:UIFont, width:CGFloat ,numberOfline : NSInteger) -> CGFloat
      {
        let label:UILabel = UILabel(frame:CGRect.init(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = numberOfline
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        print(label.frame.height)
        
        return label.frame.height
        
    }
    class func getheightForLabel(_ text:NSAttributedString, width:CGFloat ,numberOfline : NSInteger) -> CGFloat
    {
        let label:UILabel = UILabel(frame:CGRect.init(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = numberOfline
        label.lineBreakMode = .byWordWrapping
        label.attributedText = text
        
        label.sizeToFit()
        print(label.frame.height)
        
        return label.frame.height        
    }
    
    class func convertStringToDictionary(jsonText: String) -> [String:AnyObject]?
    {
        //let jsonText = "{\"first_name\":\"Sergey\"}"
        var dictonary:NSDictionary?
        
        if let data = jsonText.data(using: String.Encoding.utf8) {
            
            do {
                dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary?
                
                if let myDictionary = dictonary
                {
                    print(" First name is: \(myDictionary["first_name"]!)")
                }
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}

