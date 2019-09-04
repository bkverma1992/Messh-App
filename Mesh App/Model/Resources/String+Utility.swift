

import Foundation
import UIKit
//import Constant

extension String
{
    var trimmed: String{
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    
    func properDate() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//kDateFormat_NodeJS
        
        guard let date = dateFormatter.date(from: self) else {
            return ""
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd"      // MMMM - January, MMM - Jan, MM - 01
        
        return dateFormatter.string(from: date)
    }
    
    func timeAgoString() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//kDateFormat_NodeJS
        
        let toDate = Date()
        guard let fromDate = dateFormatter.date(from: self) else {
            return ""
        }
        
        let secondsBetweenDates: Int = Int(toDate.timeIntervalSince(fromDate))
        let minsBetweenDates: Int = secondsBetweenDates / 60
        let hoursBetweenDates: Int = secondsBetweenDates / 3600
        let daysBetweenDates: Int = secondsBetweenDates / (24*3600)
        
        var returnString = ""
        
        if (daysBetweenDates > 7)
        {
            dateFormatter.dateFormat = "dd MMM, yyyy"      // MMMM - January, MMM - Jan, MM - 01
            return dateFormatter.string(from: fromDate)
        }
        else if (daysBetweenDates > 0 && daysBetweenDates <= 7)
        {
            if daysBetweenDates == 1 {
                returnString = "1d"
            }
            else
            {
                returnString = "\(daysBetweenDates)d"
            }
            
        }
        else if (hoursBetweenDates > 0)
        {
            if hoursBetweenDates == 1
            {
                returnString = "1h"
            }
            else
            {
                returnString = "\(hoursBetweenDates)h"
            }
            
        }
        else if (minsBetweenDates > 0)
        {
            if minsBetweenDates == 1 {
                returnString = "1m"
            }
            else
            {
                returnString = "\(minsBetweenDates)m"
            }
        }
            
        else
        {
            returnString = "just now"
        }
        
        return returnString;
    }
    
    
    
    //MARK:- Utility
    
    func dynamicSizeForWidth(width: CGFloat, font: UIFont) -> CGSize
    {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        label.text = self
        label.font = font
        if (self == "")
        {
            // for minimum one line
            label.text = "Test"
        }
        
        let newSize: CGSize = label.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        
        return newSize
    }
    
    
    
    
    func isValidEmail() -> Bool {
     
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self)
    }

    
    func isValidPhoneNumber() -> Bool {
        
        if self.trimmed.count == 10
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func isValidPassword() -> Bool {
        let Regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*_?&#])[A-Za-z\\d$@$!%_*?&#]{8,15}"
        
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", Regex)
        
        return passwordTest.evaluate(with: self)
    }
    
    
    //MARK:- URL 
    
    func urlByAddingPercentEncoding()-> URL
    {
        return URL(string:self.urlStringByAddingPercentEncoding())!
    }
    
    func urlStringByAddingPercentEncoding()-> String
    {
        let urlString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        return urlString!
    }

    
    func asHTML() -> String {
        let startTag = "<html><body><p>"
        let endTag = "</p></body></html>"
        
            return startTag + self + endTag
        }
    
        func isHtml() -> Bool {
            return self.localizedCaseInsensitiveContains("html")
        }
    
    
    //MARK:- AttributedString
    
//    func underLined() -> NSAttributedString
//    {
//        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
//
//        return NSAttributedString(string: self, attributes: underlineAttribute)
//    }
//
//    func strikedThrough() -> NSAttributedString
//    {
//        let strikedThroughAttribute = [NSStrikethroughStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue,
//                                  NSStrikethroughColorAttributeName : UIColor.lightGray] as [String : Any]
//
//        return NSAttributedString(string: self, attributes: strikedThroughAttribute)
//    }
    
}





extension NSMutableAttributedString
{
    @discardableResult func bold(_ text: String, font: UIFont) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: font]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String, font: UIFont) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}

