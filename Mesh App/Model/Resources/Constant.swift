//
//  Constant.swift
//  4moles
//
//  Created by LST on 13/12/16.
//  Copyright © 2016 Techmobia. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class Constant: NSObject
{
    
    let kDateFormat_NodeJS : String = "yyyy-MM-dd HH:mm:ss"
    
    //static let GoogleAPIKey   =    "AIzaSyDSJv5ax--2PKf9zJB8HtjaQ_PEL3FN2D8"
    static let GoogleNearByMessageAPIKey   =    "AIzaSyC1YAUFIKJ0XHdUXCOgObUMOOzNewoTkOU"
    //static let GoogleSearchApiHost = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    
      static let CountryId:String = "99"
      static let StateId:String = "92"
    
    static let ServerFirebaseURL:String = "https://meshapp-96fbb-2db96.firebaseio.com/"//"https://meshchat-2ab0d.firebaseio.com" // This is production DB url "https://meshapp-96fbb.firebaseio.com/"
    
      static let ServerOldUrl:String = "http://203.92.41.131/locatem-backend/index.php/"
      static let ServerUrl :String = "http://203.92.41.131:4600/"
      static let ServerFolder:String = "users/"
    
     static let GooglePlaceAPIUrl: String = "https://maps.googleapis.com/maps/api/place/textsearch/json?key=AIzaSyAV7cM2GzdVxpVcqGTvAKYdImuqH_0CWc8&"
    
      //static let ServerUrl:String = String.init(format: "%@",mainURL)
      static let userLoginApi:String = String.init(format: "%@%@/signup", ServerUrl, ServerFolder)
      static let userNotificationsApi:String = String.init(format: "%@%@get_notification_list",ServerUrl ,ServerFolder)
    
    static let groupChildName = "TestingGroupIcons" //"TestingGroupIcons" //"GroupIcons"
    static let userChildName = "TestingUserProfileImages" //userProfileImages
    
    static let groupProfileStoragePath = Storage.storage().reference().child(groupChildName)
    static let userProfileStoragePath = Storage.storage().reference().child(userChildName)
    
     //MARK: - COLORS -
    
     static let _tableBackGroundColor: UIColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
     static let MESH_BLUE: UIColor = UIColor(red: 28.0/255.0, green: 191.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    
    static let VERY_LIGHT_GRAY: UIColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
    
     static let ORANGE: UIColor = UIColor(red: 239.0/255.0, green: 162.0/255.0, blue: 10.0/255.0, alpha: 1.0)
     static let LightGray: UIColor = UIColor(red: 231.0/255.0, green: 231.0/255.0, blue: 231.0/255.0, alpha: 1.0)
     static let CustomNavBarColor: UIColor = UIColor(red: 227.0/255.0, green: 200.0/255.0, blue: 74.0/255.0, alpha: 1.0)
     static let GREEN: UIColor = UIColor(red: 90.0/255.0, green: 187.0/255.0, blue: 57.0/255.0, alpha: 1.0)
     static let TEXTFIELD_COLOR : UIColor = UIColor(red: 104.0/255.0, green: 100.0/255.0, blue: 93.0/255.0, alpha: 1.0)
    
    static let BUTTON_COLOR : UIColor = UIColor(red: 177.0/255.0, green: 188.0/255.0, blue: 198.0/255.0, alpha: 1.0)

    
    static let primaryColor : UIColor = UIColor(red: 28.0/255.0, green: 191.0/255.0, blue: 250.0/255.0, alpha: 1.0) //UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
    
    static let DROPDOWNBUTTON_COLOR : UIColor = UIColor(red: 181.0/255.0, green: 181.0/255.0, blue: 181.0/255.0, alpha: 1.0)
    
    // https://itunes.apple.com/us/app/raffl-ticket/id1329931178?ls=1&mt=8
    
    static let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    static let chatStoryboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: nil)
    
    //MARK: - FONTS -
    
     static let Roboto_Medium_10 : UIFont  =  UIFont(name: "Roboto-Medium", size: 10.0)!
     static let Roboto_Medium_11 : UIFont  =  UIFont(name: "Roboto-Medium", size: 11.0)!
    
    static let Roboto_Thin_10 : UIFont  =  UIFont(name: "Roboto-Thin", size: 10.0)!
    static let Roboto_Thin_11 : UIFont  =  UIFont(name: "Roboto-Thin", size: 11.0)!
    
     static let Roboto_Regular_10 : UIFont  =  UIFont(name: "Roboto-Regular", size: 10.0)!
     static let Roboto_Regular_11 : UIFont  =  UIFont(name: "Roboto-Regular", size: 11.0)!
    
    static let Roboto_Bold_10 : UIFont  =  UIFont(name: "Roboto-Bold", size: 10.0)!
    static let Roboto_Bold_11 : UIFont  =  UIFont(name: "Roboto-Bold", size: 11.0)!
    
    static let Roboto_Light_10 : UIFont  =  UIFont(name: "Roboto-Light", size: 10.0)!
    static let Roboto_Light_11 : UIFont  =  UIFont(name: "Roboto-Light", size: 11.0)!
}
