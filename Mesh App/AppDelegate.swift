//
//  AppDelegate.swift
//  Mesh App
//
//  Created by Mac admin on 20/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseAuth
import IQKeyboardManagerSwift
import CoreLocation
import CoreData
import SwiftMessageBar

extension Notification.Name {
    public static let fcmNotification = Notification.Name(rawValue: "fcmChatNotificationInfo")
    //public static let notificationCheckin = Notification.Name(rawValue: "checkin")
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var mainNavController: UINavigationController?
    var  userDetails : UserDetailsModel?
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    let gcmMessageIDKey = "gcm.message_id"
    var checkIfUserFirstTimeProfile = String()
    var ifFromChatVC = String()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        
        //registerForRemoteNotifications()
        /*if #available(iOS 10, *)
        {
            UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge], completionHandler: { (granted, error) in})
            application.registerForRemoteNotifications()
        }
        else
        {
            let notificationSettings = UIUserNotificationSettings(types:  [.sound, .alert, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
            UIApplication.shared.registerForRemoteNotifications()
        }*/
        
        //FCM Notification Ke Liye He Ye
        
        /*if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        }
        else
        {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }*/
        
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        //Messaging.messaging().shouldEstablishDirectChannel = true
        //Messaging.messaging().useMessagingDelegateForDirectChannel = true
       
        //self.getCurrentLocation()
        DefaultsValues.setStringValueToUserDefaults("India", forKey: kCurrentCountryName)
        
        self.navigateToViewController()
        return true
    }
    
    func getCurrentLocation()
    {
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            //locationManager.startMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        
        geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            guard let currentLocPlacemark = placemarks?.first else { return }
            print(currentLocPlacemark.country ?? "No country found")
            DefaultsValues.setStringValueToUserDefaults(currentLocPlacemark.country, forKey: kCurrentCountryName)
            print(currentLocPlacemark.isoCountryCode ?? "No country code found")
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    //MARK: - Notifications Delegate Methods
    
    func clearNotification() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    /*func registerForRemoteNotifications()
    {
        if #available(iOS 10.0, *)
        {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil
                {
                    runOnMainThreadWithoutDeadlock {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
        else
        {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        clearNotification()
    }*/
    
    /*func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }*/
    
    /*func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
         Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        
        print("userInfo: ", userInfo)
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
    }*/
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    /*func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }*/
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
//        let tempToken:String = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//        DefaultsValues.setStringValueToUserDefaults(tempToken, forKey: kPhoneDeviceToken)
//        print("Device Token: ", tempToken)
        
        Messaging.messaging().apnsToken = deviceToken
        print("deviceToken: ", deviceToken)
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error
            {
                print("Error fetching remote instange ID: \(error)")
            }
            else if let result = result
            {
                DefaultsValues.setStringValueToUserDefaults(result.token, forKey: kFCMPushDeviceToken)
                print("Remote instance ID token: \(result.token)")
            }
        }
    }
    
    /*func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(" Entire message \(userInfo)")
        //print("Article avaialble for download: \(userInfo["articleId"]!)")
        
        let state : UIApplicationState = application.applicationState
        switch state {
        case UIApplicationState.active:
            print("If needed notify user about the message")
        default:
            print("Run code to download content")
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }*/

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.window?.endEditing(true)
    }
    
    /*@available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return self.application(application, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: "")
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation) {
            return true
        }
        
        return Invites.handleUniversalLink(url) { invite, error in
            // ...
        }
    }*/
    
    // MARK:- Manage Screens Navigation
    
    func navigateToViewController()
    {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        if ((DefaultsValues.getCustomObjFromUserDefaults_(forKey: kUserDetails)) != nil)
        {
            let userDetails = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kUserDetails) as! UserDetailsModel
            if userDetails.isLogin == "0"
            {
                
                let objEditProfileVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idEditProfileVC") as! EditProfileVC
                self.mainNavController = UINavigationController(rootViewController: objEditProfileVC)
                checkIfUserFirstTimeProfile = "userFirstTime"
            }
            else if userDetails.isLogin == "1"
            {
                
                let objChatListVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idChatListVC") as! ChatListVC
                self.mainNavController = UINavigationController(rootViewController: objChatListVC)
                checkIfUserFirstTimeProfile = "userNotFirstTime"
            }
            else
            {
                let objSignUpScreenVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idSignUpScreenVC") as! SignUpScreenVC
                self.mainNavController = UINavigationController(rootViewController: objSignUpScreenVC)
                checkIfUserFirstTimeProfile = "userFirstTime"
            }
        }
        else
        {
            
            let objWelcomeScreenVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idWelcomeScreenVC") as! WelcomeScreenVC
            self.mainNavController = UINavigationController(rootViewController: objWelcomeScreenVC)
            
        }
        appdelegate.window?.rootViewController = self.mainNavController
    }
    
    func handleIncomingDynamicLink(_dynamicLink: DynamicLink)
    {
        guard let url = _dynamicLink.url else {
            print("Dynamic Link Object has no URL")
            return
        }
        print("Your incoming link parameter is \(url.absoluteString)")
    }
    
    func joinTheGroup(strGroupId : String)
    {
       // let arrGroupData = NSMutableArray()
        let arrPart = NSMutableArray()
        var dictData = NSMutableDictionary()
        
        let userDetail = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kUserDetails) as! UserDetailsModel
        let chatUserId = Auth.auth().currentUser?.uid
        
        
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
       // let msgDate = dateFormatter.string(from:date)
        
        let msgDate = NSDate().timeIntervalSince1970
        
        print(msgDate)
        
        
        dictData.setValue(false, forKey: "is_Admin")
        dictData.setValue(userDetail.userName!, forKey: "participant_name")
        dictData.setValue(userDetail.phone!, forKey: "phone_number")
        dictData.setValue(userDetail.fcmPushToken, forKey: "fcm_push_token")
        dictData.setValue(userDetail.userId!, forKey: "participant_id")
        dictData.setValue(userDetail.userImage!, forKey: "participant_image")
        dictData.setValue(userDetail.cityName!, forKey: "participant_location")
        dictData.setValue(userDetail.shortBio!, forKey: "short_bio")
        dictData.setValue(msgDate, forKey: "joining_time")
        arrPart.add(dictData)
                
        let refChatInfo = ChatConstants.refs.databaseChatInfo.child(strGroupId)
        refChatInfo.observeSingleEvent(of:.childAdded, with: {snapshot in
       // refChatInfo.observe(.childAdded, with: {snapshot in
                let msgGroupDict = snapshot.value as? NSDictionary
                print("msgGroupDict ", msgGroupDict!)
                //print("msgGroupDict: ", msgGroupDict!)
                let strType = msgGroupDict!.value(forKey: "type") as! String
                //let dict = msgGroupDict as! NSMutableDictionary
                dictData = msgGroupDict as! NSMutableDictionary
                //arrGroupData.add(msgGroupDict!)
                        
                if strType == "1"
                {
                    
                    var childrens = NSArray()
                    
                    
                    if msgGroupDict?.value(forKey: "participants") is NSMutableArray {
                        
                        childrens = msgGroupDict?.value(forKey: "participants") as! NSArray
                        
                    }else{
                        
                        let abc = msgGroupDict!.object(forKey: "participants") as! NSDictionary
                        
                        var abc2 = NSArray()
                        
                        abc2 = abc.allKeys as NSArray
                        
                        
                        let abc3 = NSMutableArray()
                        
                        
                        for indexx in abc2 {
                            
                            
                            // abc3.add(abc.object(forKey: abc[index as! Int]) as! [Any])
                            
                            
                            
                            abc3.add(abc[indexx])
                            
                        }
                        
                        childrens = abc3
                    }
                    
                    
                    
                  //  let childrens = msgGroupDict?.value(forKey: "participants") as! NSDictionary
                   
                    for child in  childrens {
                        let msgParticipantsDict = child as? NSDictionary
                        print(child)
                     //   let msgParticipantsDict = child
                        let strCheckKey = msgParticipantsDict?.value(forKey: "participant_id") as! String
                        
                        
                        arrPart.add(msgParticipantsDict as Any)
                        if strCheckKey == chatUserId
                        {
                            //SwiftMessageBar.showMessage(withTitle: "You are already the member of this group", type: .error)
                            return
                        }
                    }
                }
                
                dictData.setValue(arrPart, forKey: "participants")
                dictData.setValue(String(arrPart.count), forKey: "participant_count")
                
                let refDatabase = ChatConstants.refs.databaseChatInfo
                let childUpdates = ["\(String(describing: strGroupId))/groupInfo/": dictData] //key
                refDatabase.updateChildValues(childUpdates)
                
                let refLoginUserPath = ChatConstants.refs.databaseUserInfo.child(userDetail.userId!)
                let childUserInfo = ["/chats/\(String(describing: strGroupId))" : ""]
                refLoginUserPath.updateChildValues(childUserInfo)
                
                let refAllMsgDatabase = ChatConstants.refs.databaseMessagesInfo
                let allMsgKey = refAllMsgDatabase.childByAutoId().key
                let dictionaryAllMsg = NSMutableDictionary()
                dictionaryAllMsg.setValue("false", forKey: "is_reply")
                dictionaryAllMsg.setValue(allMsgKey, forKey: "message_id")
                //dictionaryAllMsg.setValue("", forKey: "reply_id")
                dictionaryAllMsg.setValue(ServerValue.timestamp() as! [String: AnyObject], forKey: "message_time")
                dictionaryAllMsg.setValue(userDetail.userId!, forKey: "sender_id")
                dictionaryAllMsg.setValue(userDetail.userName!, forKey: "sender_name")
                dictionaryAllMsg.setValue(userDetail.userImage!, forKey: "sender_image")
            dictionaryAllMsg.setValue(userDetail.cityName!, forKey: "sender_location")
            dictionaryAllMsg.setValue(msgDate, forKey: "joining_time")

                dictionaryAllMsg.setValue(String(format: "Joined"), forKey: "text_msg")
                
                dictionaryAllMsg.setValue(userDetail.fcmPushToken!, forKey: "sender_fcm_push_token")
                dictionaryAllMsg.setValue(userDetail.companyName!, forKey: "sender_company")
                dictionaryAllMsg.setValue(userDetail.designation!, forKey: "sender_designation")
                
                let childAllMsgUpdates = ["\(String(describing: strGroupId))/\(String(describing: allMsgKey!))/": dictionaryAllMsg] //key
                refAllMsgDatabase.updateChildValues(childAllMsgUpdates)

         }, withCancel: nil)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if let incomingURL = userActivity.webpageURL
        {
            print("Incoming URL is \(incomingURL)")
            DefaultsValues.setStringValueToUserDefaults("true", forKey: kInviteLink)
            
            let str = String(format: "%@", incomingURL as CVarArg)
            var strInviteIrl = str.components(separatedBy: "=")
            let strGroupId = String(format: "%@", strInviteIrl[1])
            self.joinTheGroup(strGroupId: strGroupId)
            
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamiclink, error) in
                //print(dynamiclink)
                guard error == nil else {
                    print("Found an error! \(error!.localizedDescription)")
                    return
                }
                if let dynamicLink = dynamiclink {
                    self.handleIncomingDynamicLink(_dynamicLink: dynamicLink)
                }
            }
            if linkHandled{
                return true
            }
            else
            {
                return false
            }
        }
        return false
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return application(app, open: url,
                           sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                           annotation: "")
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        print("My link parameters: ", url.absoluteString)
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            self.handleIncomingDynamicLink(_dynamicLink: dynamicLink)
            print("dynamicLink: ", dynamicLink)
            // Handle the deep link. For example, show the deep-linked content or
            // apply a promotional offer to the user's account.
            // ...
            return true
        }
        return false
    }
    
    //MARK: - Show Connectivity
    
    func showConnectivity(_ strTitle: String) {
        defer {
        }
        do {
            window?.viewWithTag(56768)?.removeFromSuperview()
            UIApplication.shared.endIgnoringInteractionEvents()
            UIApplication.shared.endIgnoringInteractionEvents()
            window?.viewWithTag(56768)?.removeFromSuperview()
        }
        //        catch let exception {
        //        }
        let vw = UIImageView(frame: UIScreen.main.bounds)
        vw.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.7)
        vw.alpha = 1.0
        vw.tag = 56768
        vw.isUserInteractionEnabled = false
        
        let whiteView = UIView(frame: CGRect(x: CGFloat((UIScreen.main.bounds.size.width - 50) / 2), y: CGFloat((UIScreen.main.bounds.size.height - 50) / 2), width: CGFloat(50), height: CGFloat(50)))
        whiteView.backgroundColor = UIColor.clear
        whiteView.layer.cornerRadius = 2.0
        whiteView.isUserInteractionEnabled = false
        vw.addSubview(whiteView)
        
        let act = UIActivityIndicatorView()
        act.activityIndicatorViewStyle = .whiteLarge
        act.center = vw.center
        vw.addSubview(act)
        act.color = Constant.LightGray
        act.startAnimating()
        window?.addSubview(vw)
        window?.bringSubview(toFront: vw)
    }
    
    func hideLoading() {
        removeLoadingView()
    }
    
    func removeLoadingView() {
        defer {
        }
        do {
            window?.viewWithTag(56768)?.removeFromSuperview()
        }
        //        catch let _ {
        //        }
    }
    
    func parseNewRemoteNotification(userNewInfo:[AnyHashable : Any])
    {
        print("userNewInfo", userNewInfo)
        //var strNotificationType: String = ""
        //strNotificationType  = userNewInfo["notification_type"] as! String
        
        //if strNotificationType == "Invitation"
        //{
        NotificationCenter.default.post(name: .fcmNotification, object: self, userInfo: userNewInfo)
        //}
    }
    
    //MARK: - Core Data Methods
    lazy var persistentContainer: NSPersistentContainer = {
        // The persistent container for the application. This implementation
        // creates and returns a container, having loaded the store for the
        // application to it. This property is optional since there are legitimate
        // error conditions that could cause the creation of the store to fail.
        let container = NSPersistentContainer(name: "MeshCoreDataModel") //Here it is the name of CoreData Model i.e (xcdatamodeld) not the name of the project
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                /// You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func CoreDataEntityIsEmpty(entityName: String)
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        //fetchRequest.predicate = NSPredicate(format: "user_id = nil")
         let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        let results = try? context.fetch(fetchRequest)
        if results == nil
        {
            print("Results: results is empty")
        }
        else
        {
            print("Result is not empty")
        }
    }
    
    /*func entityIsEmpty(entity: String) -> Bool
    {
        var appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        var error = NSErrorPointer.self
        //var error = NSErrorPointer()
        
        var results:NSArray? = context.execute(request)
            //context.executeFetchRequest(request, error: error)
        
        if let res = results
        {
            if res.count == 0
            {
                return true
            }
            else
            {
                return false
            }
        }
        else
        {
            print("Entity is empty")
            //print("Error: \(error.debugDescription)")
            return true
        }
        
    }*/
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        //Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
         self.parseNewRemoteNotification(userNewInfo: userInfo)
        DefaultsValues.setUserValueToUserDefaults(userInfo as NSDictionary, forKey: kFCMUserInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print("userInfo: ",userInfo)
       // self.parseNewRemoteNotification(userNewInfo: userInfo)
        DefaultsValues.setUserValueToUserDefaults(userInfo as NSDictionary, forKey: kFCMUserInfo)
        
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}

