//
//  BuzzPostsVC.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 13/12/2018.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit
import SwiftMessageBar
import SwiftLinkPreview
import AlamofireImage
import ImageSlideshow
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore
import SDWebImage
import JGProgressHUD
import MessageUI

class BuzzPostsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, MFMailComposeViewControllerDelegate, menuViewDelegate {
    
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnContact: UIButton!
    
    var viewMenuXib : MenuView!
    @IBOutlet weak var btnMenu: UIButton!
    var viewTransparent : UIView!
    var arrBuzzPostsList = NSMutableArray()
    var strBuzzPostType : String = ""
    
    var txtBuzzPostText: UITextField!
    var txtBuzzPostUrl: UITextField!
    var viewBuzzPost : BuzzPostsView!
    var viewCoverView: UIView!
    var arrSearchData = NSMutableArray()
    
    // MARK: - Properties
 
    @IBOutlet weak var tblBuzzPosts: UITableView!
    @IBOutlet weak var btnMenu_Click: UIButton!

    var dictBuzzPostsData = NSMutableDictionary()
    
    // MARK: - Vars
    private var result = Response()
    private let placeholderImages = [ImageSource(image: UIImage(named: "gallery1")!)]
    private let slp = SwiftLinkPreview(cache: InMemoryCache())
    
    //private var result = SwiftLinkPreview.Response()
    //private let placeholderImages = [ImageSource(image: UIImage(named: "gallery1")!)]
    //private let slp = SwiftLinkPreview(cache: InMemoryCache())
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.showHideAll(hide: true)
        //self.setUpSlideshow()
        self.tblBuzzPosts.isHidden = true
        
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        //let deadlineTime = DispatchTime.now() + .seconds(2)
        //DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            connectedRef.observe(.value, with: { snapshot in
                if snapshot.value as? Bool ?? false {
                    self.getAllBuzzPosts()
                    print("Connected")
                }
                else
                {
                    /*let otherAlert = UIAlertController(title: "Network Issue", message: "Please check you internet connection", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                    otherAlert.addAction(okAction)
                    otherAlert.addAction(cancelAction)
                    self.present(otherAlert, animated: true, completion: nil)*/
                }
            })
        //})
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if (viewMenuXib != nil)
        {
            viewCoverView.removeFromSuperview()
            viewMenuXib.removeFromSuperview()
        }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Menu Action
    
    func navigateToController(index: Int)
    {
        if index == 0
        {
            let objChatListVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idChatListVC") as! ChatListVC
            self.navigationController?.pushViewController(objChatListVC, animated: false)
        }
        else if index == 1
        {
            let objViewProfileVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idViewProfileVC") as! ViewProfileVC
            self.navigationController?.pushViewController(objViewProfileVC, animated: true)
        }
        else if index == 2
        {
            //            let objCreateGroupVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idCreateGroupVC") as! CreateGroupVC
            //            self.navigationController?.pushViewController(objCreateGroupVC, animated: true)
            let objAddGroupSubjectVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idAddGroupSubjectVC") as! AddGroupSubjectVC
            //objAddGroupSubjectVC.arrParticipantsData = self.arrSelectedData.mutableCopy() as! NSMutableArray
            self.navigationController?.pushViewController(objAddGroupSubjectVC, animated: true)
        }
        else if index == 3
        {
            let objTermsAndPoliciesVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idTermsAndPoliciesVC") as! TermsAndPoliciesVC
            self.navigationController?.pushViewController(objTermsAndPoliciesVC, animated: true)
        }
    }
    
    //MARK:- Get All Buzz Posts
    
    @IBAction func btnMenu_Click(_ sender: Any) {
        
        viewMenuXib = MenuView(frame: CGRect(x: self.btnContact.frame.origin.x - 80, y: self.btnMenu.frame.origin.y + 10, width: 150, height: 200))
        viewCoverView = UIView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height))
        viewCoverView.backgroundColor = UIColor.black
        viewCoverView.alpha = 0.6
        //self.view.addSubview(viewTransparent)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.delegate = self as? UIGestureRecognizerDelegate // This is not required
        viewCoverView.addGestureRecognizer(tap)
        self.view.addSubview(viewCoverView)
        
        self.view.addSubview(viewMenuXib)
        viewMenuXib.layer.cornerRadius = 5
        viewMenuXib.layer.masksToBounds = true
        viewMenuXib.backgroundColor = UIColor.white
        viewMenuXib.menuDelegate = self
        viewMenuXib.dropShadow()
    }
    
    @IBAction func btnBuzzPosts_Click(_ sender: Any) {
    }
    
    @IBAction func btnRelevant_Click(_ sender: Any) {
        
        let objSearchRelevantVC = Constant.chatStoryboard.instantiateViewController(withIdentifier: "idSearchRelevantVC") as! SearchRelevantVC
        objSearchRelevantVC.arrSearchData = self.arrSearchData
        self.navigationController?.pushViewController(objSearchRelevantVC, animated: false)
    }
    
    @IBAction func btnAll_Click(_ sender: Any)
    {
        let objChatListVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idChatListVC") as! ChatListVC
        self.navigationController?.pushViewController(objChatListVC, animated: false)
        //self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnSearch_Click(_ sender: Any)
    {
        if self.arrSearchData.count > 0
        {
            let objSearchFromChatListVC = Constant.chatStoryboard.instantiateViewController(withIdentifier: "idSearchFromChatListVC") as! SearchFromChatListVC
            objSearchFromChatListVC.arrSearchData = self.arrSearchData
            self.navigationController?.present(objSearchFromChatListVC, animated: true, completion: nil)
            //self.navigationController?.pushViewController(objSearchFromChatListVC, animated: false)
        }
        else
        {
            SwiftMessageBar.showMessage(withTitle: "No data is available to search", type: .error)
        }
    }
    
    @IBAction func btnContactList_Click(_ sender: Any) {
        let objContactListVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idContactListVC") as! ContactListVC
        self.navigationController?.pushViewController(objContactListVC, animated: true)
    }
    
    func getAllBuzzPosts()
    {
        //self.dictFriendData.setValue(self.dictFriendData.value(forKey: "friend_name"), forKey: "friend_name")
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        
        //self.tblBuzzPosts.isHidden = true
        
        self.arrBuzzPostsList = NSMutableArray()
        //let loginUserId = Auth.auth().currentUser?.uid
        let refBuzzPosts = ChatConstants.refs.databaseBuzzPostsInfo
        //let allMessages = self.refDatabase.child("OneToOneMessages").child(loginUserId!).child(strFriendId as! String)
        let arrBuzz = NSMutableArray()
        refBuzzPosts.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let msgDict = snap.value as? [String: AnyObject]
                arrBuzz.add(msgDict!)
                //self.arrBuzzPostsList.sorted(by: { ($0 as AnyObject).msgDict.value(forKey: "post_time") > $1.msgDict.value(forKey: "post_time")})
            }
            let arrrr = NSArray.init(array: arrBuzz)
            let filArray = arrrr.descendingArrayWithKeyValue(key: "post_time")
            self.arrBuzzPostsList = filArray.mutableCopy() as! NSMutableArray
            
            //let deadlineTime = DispatchTime.now() + .seconds(2)
            //DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                hud.dismiss()
                self.tblBuzzPosts.isHidden = false
                self.tblBuzzPosts.reloadData()
            //})
        })
    }
    
    //MARK:- Textfield Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == txtBuzzPostText
        {
            self.strBuzzPostType = "0"
            txtBuzzPostUrl?.becomeFirstResponder()
        }
        else if textField == txtBuzzPostUrl
        {
            self.strBuzzPostType = "1"
        }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
//        if textField == txtBuzzPostText
//        {
//            self.strBuzzPostType = "0"
//            txtBuzzPostUrl?.becomeFirstResponder()
//        }
//        else
        if textField == viewBuzzPost.txtPostUrl
        {
            self.strBuzzPostType = "1"
        }
        return true
    }
    
    //MARK:- TextView Delegate Methods
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView == viewBuzzPost.txtViewPostText
        {
            if viewBuzzPost.txtViewPostText.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.black
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if textView == viewBuzzPost.txtViewPostText
        {
            self.strBuzzPostType = "0"
            if viewBuzzPost.txtViewPostText.text.isEmpty
            {
                textView.text = "Post your text here...."
                textView.textColor = UIColor.lightGray
            }
        }
    }
    
    //MARK:- Add  A New View On Buzz Section
    
    func addNewViewForBuzzPost()
    {
        /*let viewTransparent = UIView()
        viewTransparent.translatesAutoresizingMaskIntoConstraints = false
        viewTransparent.backgroundColor = UIColor.blue
        viewTransparent.alpha = 0.95
        self.view.addSubview(viewTransparent)
    
        let horConstraint = NSLayoutConstraint(item: viewTransparent, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let verConstraint = NSLayoutConstraint(item: viewTransparent, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        let widConstraint = NSLayoutConstraint(item: viewTransparent, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: 0.0)
        let heiConstraint = NSLayoutConstraint(item: viewTransparent, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1.0, constant: 0.0)
        
        view.addConstraints([horConstraint, verConstraint, widConstraint, heiConstraint])*/
        
        let loadXibView = Bundle.main.loadNibNamed("BuzzPostsView", owner: self, options: nil)
        
        //If you only have one view in the xib and you set it's class to MyView class
        viewBuzzPost = loadXibView!.first as? BuzzPostsView
        
        //Set wanted position and size (frame)
        //myView.frame = self.view.bounds
        //        myView.frame = CGRect(x:  (self.view.frame.size.width / 2), y: (self.view.frame.size.height / 2), width: self.view.frame.size.width - 20, height: 270)
        
        viewBuzzPost.center = CGPoint(x: self.view.frame.size.width  / 2,
                                        y: self.view.frame.size.height / 2)
        
         /*viewTransparent = UIView.init(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height))
        viewTransparent.backgroundColor = UIColor.black
        viewTransparent.alpha = 0.96
        self.view.addSubview(viewTransparent)*/
        
        //var viewBuzzPost = BuzzPostsView()
        //viewBuzzPost = BuzzPostsView.init(frame: CGRect(x: viewTransparent.frame.origin.x + 50, y: 40, width: self.view.frame.size.width-40, height: self.view.frame.size.height-40))
        
        //viewBuzzPost = Bundle.main.loadNibNamed("BuzzPostsView", owner: self, options: nil)![0] as? BuzzPostsView
        //viewTransparent.addSubview(viewBuzzPost)
        
        viewBuzzPost.txtViewPostText.layer.borderColor = UIColor.lightGray.cgColor
        viewBuzzPost.txtViewPostText.layer.borderWidth = 1.0
        viewBuzzPost.txtViewPostText.layer.cornerRadius = 4.0
        viewBuzzPost.txtViewPostText.delegate = self
        viewBuzzPost.txtViewPostText.textColor = UIColor.lightGray
        
        viewBuzzPost.txtPostUrl.layer.borderColor = UIColor.lightGray.cgColor
        viewBuzzPost.txtPostUrl.layer.borderWidth = 1.0
        viewBuzzPost.txtPostUrl.layer.cornerRadius = 4.0
        viewBuzzPost.txtPostUrl.delegate = self
        
        viewBuzzPost.btnBuzzPost.layer.cornerRadius = 4.0
        viewBuzzPost.btnBuzzPost.addTarget(self, action:#selector(btnPost_Click(sender:)), for: .touchUpInside)
        
        let screenRect = UIScreen.main.bounds
        viewTransparent = UIView(frame: screenRect)
        viewTransparent.backgroundColor = UIColor.black.withAlphaComponent(0.86)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.delegate = self as? UIGestureRecognizerDelegate // This is not required
        viewTransparent.addGestureRecognizer(tap)
        self.view.addSubview(viewTransparent)
        self.view.addSubview(viewBuzzPost)
        
        //viewBuzzPost.
        
        /*viewBuzzPost.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: viewBuzzPost, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewTransparent, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 0.9, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: viewBuzzPost, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewTransparent, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 0.9, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: viewBuzzPost, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 0.9, constant: 200)
        let heightConstraint = NSLayoutConstraint(item: viewBuzzPost, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 0.9, constant: 200)
        viewTransparent.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])*/
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
     //bk
        self.viewBuzzPost.removeFromSuperview()
        self.viewTransparent.removeFromSuperview()
        self.viewBuzzPost = nil
        self.viewTransparent = nil
//        viewCoverView.removeFromSuperview()
//        viewMenuXib.removeFromSuperview()
        // handling code
    }
    
    @objc func btnPost_Click(sender: UIButton)
    {
        if viewBuzzPost.txtPostUrl.text == "" && viewBuzzPost.txtViewPostText.text == "Post your text here...."
        {
            SwiftMessageBar.showMessage(withTitle: "Please enter either text or url to post", type: .error)
        }
        else
        {
            if self.strBuzzPostType == "0"
            {
                self.postUrlOrText()
            }
            else if self.strBuzzPostType  == "1"
            {
                self.getUrlFullData(strTextfieldData: viewBuzzPost.txtPostUrl.text!)
                /*let deadlineTime = DispatchTime.now() + .seconds(3)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                    //self.postUrlOrText()
                })*/
            }
        }
    }
    // UseLess Function
    func addNewViewForBuzzsdfgjhgffghjhbvhjgfdtfdfyfdghjfgfdrdgfhj()
    {
        //let viewBuzzPost = UIView()
        viewTransparent = UIView.init(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height))
        viewTransparent.backgroundColor = UIColor.black
        viewTransparent.alpha = 0.98
        self.view.addSubview(viewTransparent)
        
        //var viewBuzzPost = BuzzPostsView.init(frame: CGRect(x: viewTransparent.frame.origin.x + 50, y: 40, width: self.view.frame.size.width-40, height: self.view.frame.size.height-40))
        
        var viewBuzzPost = BuzzPostsView()
        
        viewBuzzPost = Bundle.main.loadNibNamed("BuzzPostsView", owner: self, options: nil)![0] as! BuzzPostsView
        viewBuzzPost.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: viewBuzzPost, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: viewBuzzPost, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: viewBuzzPost, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300)
        let heightConstraint = NSLayoutConstraint(item: viewBuzzPost, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        viewTransparent.addSubview(viewBuzzPost)
    }
    
    //MARK:- Button Actions
    
    @IBAction func btnAddBuzzPosts_Click(_ sender: Any)
    {
        self.addNewViewForBuzzPost()
    }
    
    // MARK: - Post The URL Or Text On Buzz
    
    func postUrlOrText()
    {
        let refBuzzPosts = ChatConstants.refs.databaseBuzzPostsInfo
        //let userId = Auth.auth().currentUser?.uid
        
        let userDetails = DefaultsValues.getCustomObjFromUserDefaults_(forKey: kUserDetails) as! UserDetailsModel
        //let strCurrentTime = Utils.getCurrentDateAndTimeInFormatWithSeconds()
        let keyAutoId = refBuzzPosts.childByAutoId().key
        
        
        self.dictBuzzPostsData.setValue(keyAutoId, forKey: "post_id")
        self.dictBuzzPostsData.setValue(ServerValue.timestamp() as! [String: AnyObject], forKey: "post_time")
        self.dictBuzzPostsData.setValue(self.strBuzzPostType, forKey: "post_type")
        self.dictBuzzPostsData.setValue(userDetails.companyName!, forKey: "user_company")
        self.dictBuzzPostsData.setValue(userDetails.designation!, forKey: "user_designation")
        self.dictBuzzPostsData.setValue(userDetails.userId!, forKey: "user_id")
        self.dictBuzzPostsData.setValue(userDetails.userImage!, forKey: "user_image")
        self.dictBuzzPostsData.setValue(userDetails.userName!, forKey: "user_name")
        
        if self.strBuzzPostType == "0"
        {
             self.dictBuzzPostsData.setValue(viewBuzzPost.txtViewPostText.text!, forKey: "post_text")
             self.dictBuzzPostsData.setValue("", forKey: "post_description")
             self.dictBuzzPostsData.setValue("", forKey: "post_image")
            self.dictBuzzPostsData.setValue("", forKey: "post_title")
            self.dictBuzzPostsData.setValue("", forKey: "post_url")
        }
        else if self.strBuzzPostType == "1"
        {
            self.dictBuzzPostsData.setValue("", forKey: "post_text")
        }
        let childUpdates = ["\(String(describing: keyAutoId!))": self.dictBuzzPostsData]
        refBuzzPosts.updateChildValues(childUpdates)
        
        if self.viewBuzzPost != nil
        {
            self.viewBuzzPost.removeFromSuperview()
            self.viewTransparent.removeFromSuperview()
            self.viewBuzzPost = nil
            self.viewTransparent = nil
            self.arrBuzzPostsList = NSMutableArray.init()
            self.getAllBuzzPosts()
        }
    }
    
    func getUrlFullData(strTextfieldData: String )
    {
        print("self.txtBuzzPostUrl: ", viewBuzzPost.txtPostUrl.text!)
        guard viewBuzzPost.txtPostUrl?.text?.isEmpty == false else {
            
            SwiftMessageBar.showMessage(withTitle: "Please enter the url", type: .error)

            return
            
        }
        
        //self.startCrawling()
        
        let textFieldText = viewBuzzPost.txtPostUrl?.text ?? String()
        
        if let url = self.slp.extractURL(text: textFieldText),
            let cached = self.slp.cache.slp_getCachedResponse(url: url.absoluteString) {
            
            self.result = cached
            self.setData()
            
            //result.forEach { print("\($0):", $1) }
            
        }
        else {
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Loading"
            hud.show(in: self.view)
            self.slp.preview(textFieldText, onSuccess: { result in
                print("result: ", result)
                    //result.forEach { print("\($0):", $1) }
                    self.result = result
                //self.result = String(data: result, encoding: String.Encoding.utf8)
                    hud.dismiss()
                    self.setData()
                
            },
                onError: { error in
                    
                    print(error)
                    //self.endCrawling()
                    SwiftMessageBar.showMessage(withTitle: error.description, type: .error)
            }
            )
        }
    }
    
    private func setData() {
        if let value = self.result.images {
            
            if !value.isEmpty {
                
                var images: [InputSource] = []
                self.dictBuzzPostsData.setValue(value[0], forKey: "post_image")
                for image in value {
                    
                    if let source = AlamofireSource(urlString: image) {
                        
                        images.append(source)
                        
                    }
                    
                }
                self.dictBuzzPostsData.setValue(self.result.image, forKey: "post_image")
                //self.setImage(images: images)
                
            } else {
                self.dictBuzzPostsData.setValue(self.result.image, forKey: "post_image")
                //self.setImage(image: self.result.image)
                
            }
            
        } else {
            self.dictBuzzPostsData.setValue(self.result.image, forKey: "post_image")
            //self.setImage(image: self.result.image)
            
        }
        
        if let value: String = self.result.title {
            
            let strTitle = value.isEmpty ? "No Title" : value
            self.dictBuzzPostsData.setValue(strTitle, forKey: "post_title")
            
        } else {
            
            self.dictBuzzPostsData.setValue("No Title", forKey: "post_title")
            
        }
        if self.result.finalUrl != nil
        {
            //let url = URL(string: self.result.finalUrl!.path)
            if let value: String = self.result.finalUrl?.absoluteString {
                self.dictBuzzPostsData.setValue(String(format: "%@", value), forKey: "post_url")
                //self.dictBuzzPostsData.setValue(String(format: "https://%@", value), forKey: "post_url")
            }
        }
        
        if let value: String = self.result.description {
            
            let strDescription = value.isEmpty ? "No description" : value
            self.dictBuzzPostsData.setValue(strDescription, forKey: "post_description")
            
        } else {
            self.dictBuzzPostsData.setValue("No description", forKey: "post_description")
            
        }
        self.postUrlOrText()
        
    }
    
    /*func setData() {
        
        if let value: [String] = self.result[.images] as? [String] {

            if !value.isEmpty {
                self.dictBuzzPostsData.setValue(value[0], forKey: "post_image")
                var images: [InputSource] = []
                for image in value {
                    if let source = AlamofireSource(urlString: image) {
                        images.append(source)
                    }
                }
                //self.setImage(images: images)
            }
            else
            {
                //self.setImage(image: self.result[.image] as? String)
                let strImage = self.result[.image] as! String
                self.dictBuzzPostsData.setValue(strImage, forKey: "post_image")
            }
        }
        else {
            
            //self.setImage(image: self.result[.image] as? String)
            let strImage = self.result[.image] as! String
            self.dictBuzzPostsData.setValue(strImage, forKey: "post_image")
        }
        
        if let value: String = self.result[.title] as? String
        {
            
            let strTitle = value.isEmpty ? "No title" : value
            
            self.dictBuzzPostsData.setValue(strTitle, forKey: "post_title")
            
        }
        else
        {
            let strTitle = "No title" as String
            self.dictBuzzPostsData.setValue(strTitle, forKey: "post_title")
        }
        print(self.result[.canonicalUrl]!)
        print(self.result[.finalUrl]!)
        print(self.result[.url]!)
        if let value: String = self.result[.canonicalUrl] as? String
        { //self.result[.canonicalUrl] as? String
            
            self.dictBuzzPostsData.setValue(String(format: "https://%@", value), forKey: "post_url")
            //self.dictBuzzPostsData.setValue(value, forKey: "post_url")
            
            //self.previewCanonicalUrl?.text = value
            
        }
        //self.dictBuzzPostsData.setValue(strUrl, forKey: "post_url")
        if let value: String = self.result[.description] as? String
        {
            let strDescription = value.isEmpty ? "No description" : value
            self.dictBuzzPostsData.setValue(strDescription, forKey: "post_description")
        }
    }*/

    
    // MARK: - Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let objBuzzPosts = BuzzPosts.init(dictionary: self.arrBuzzPostsList[indexPath.row] as! NSDictionary)!
        let strPostType = objBuzzPosts.buzzPostType!
        
        if strPostType == "0"
        {
            return 250
        }
        else
        {
            return ((tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath))?.contentView.frame.size.height)!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrBuzzPostsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellReuseIdentifier = "idBuzzPostsCell"
        let cell:BuzzPostsTableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! BuzzPostsTableViewCell?)!
        cell.selectionStyle = .none
        
        let objBuzzPosts = BuzzPosts.init(dictionary: self.arrBuzzPostsList[indexPath.row] as! NSDictionary)!
        
        let strPostType = objBuzzPosts.buzzPostType!
        
        cell.lblUserName.text! = objBuzzPosts.buzzPostUserName!
        cell.lblUserProfession.text! = String(format: "%@, %@", objBuzzPosts.buzzPostUserDesignation!, objBuzzPosts.buzzPostUserCompany!)
        cell.imgUserProfile.sd_setImage(with: URL(string: (objBuzzPosts.buzzPostUserImage!)), placeholderImage: UIImage(named: "gallery1"))
        
        if strPostType == "0"
        {
            cell.lblBuzzPostText.text! = objBuzzPosts.buzzPostText!
            cell.viewPostText.isHidden = false
            cell.viewPreviewArea?.isHidden = true
            
        }
        else if strPostType == "1"
        {
           // cell.slideshow!.sd_setImageLoad(URL(string: (objBuzzPosts.buzzPostImage!)) as! SDWebImageOperation, forKey: UIImage(named: "gallery1"))
            
            //cell.slideshow!.sd_setImageLoad(SDWebImageOperation, forKey: objBuzzPosts.buzzPostImage)
           // cell.slideshow?.setImageInputs(images)
            
            cell.viewPostText.isHidden = true
            cell.viewPreviewArea?.isHidden = false
            if objBuzzPosts.buzzPostImage == nil
            {
                cell.imgBuzzPostPic.image = UIImage(named: "gallery1")
                //cell.imgBuzzPostPic.sd_setImage(with: URL(string: (objBuzzPosts.buzzPostImage!)), placeholderImage: UIImage(named: "gallery1"))
            }
            else
            {
                cell.imgBuzzPostPic.sd_setImage(with: URL(string: (objBuzzPosts.buzzPostImage!)), placeholderImage: UIImage(named: "gallery1"))
            }
            
            cell.lblBuzzPostTitle!.text! = objBuzzPosts.buzzPostTitle!
            cell.lblBuzzPostUrl!.text! = objBuzzPosts.buzzPostUrl!
            cell.lblBuzzPostDescription!.text! = objBuzzPosts.buzzPostDescription!
            cell.lblBuzzPostText.text! = objBuzzPosts.buzzPostText!
            cell.btnLink.tag = indexPath.row
            cell.btnLink.addTarget(self, action: #selector(btnLink_Click(sender:)), for: .touchUpInside)
        }
        cell.btnReportShare.tag = indexPath.row
        cell.btnReportShare.addTarget(self, action: #selector(btnReportShare_Click(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    
    @objc func btnLink_Click(sender: UIButton)
    {
        let objBuzzPosts = BuzzPosts.init(dictionary: self.arrBuzzPostsList[sender.tag] as! NSDictionary)!
        let strPostType = objBuzzPosts.buzzPostType!
        
        if strPostType == "1"
        {
            let strLink = objBuzzPosts.buzzPostUrl!
            
            if let url = URL(string: strLink) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],
                                              completionHandler: {
                                                (success) in
                                                print("Open \(strLink): \(success)")
                    })
                }
                else
                {
                    let success = UIApplication.shared.openURL(url)
                    print("Open \(strLink): \(success)")
                }
            }
        }
    }
    
    @objc func btnReportShare_Click(sender: UIButton)
    {
        let objBuzzPosts = BuzzPosts.init(dictionary: self.arrBuzzPostsList[sender.tag] as! NSDictionary)!
        
        let actionSheet = UIAlertController(title: "Choose any option", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Report", style: .default , handler:{ (UIAlertAction)in
            self.dismiss(animated: true, completion: nil)
            
            let toRecipients = ["mesh@miniventurelab.com"]
            let subject = "Report"
            let body = String(format: "%@ \n %@", "Reporting the following post: ", objBuzzPosts.buzzPostId!)
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(toRecipients)
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            self.present(mail, animated: true, completion: nil)
            
            /*let email = "mesh@miniventurelab.com"
             if let url = URL(string: "mailto:\(email)") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }  */
            //self.present(actionSheet, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Share", style: .default , handler:{ (UIAlertAction)in
            
            var shareAll = [Any]()
            
            if objBuzzPosts.buzzPostType == "0"
            {
                let strInviteUrl = String(format: "%@", objBuzzPosts.buzzPostText!)
                //let myWebsite = URL(string: strInviteUrl )
                shareAll = [strInviteUrl] as [Any]
            }
            else if objBuzzPosts.buzzPostType == "1"
            {
                let strInviteUrl = String(format: "%@", objBuzzPosts.buzzPostUrl!)
                let myWebsite = URL(string: strInviteUrl )
                shareAll = [myWebsite!] as [Any]
            }
            
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
            
            //self.dismiss(animated: true, completion: nil)
            //self.present(actionSheet, animated: true, completion: nil)
        }))
        
        self.present(actionSheet, animated: true, completion: {
            print("completion block")
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in
            self.dismiss(animated: true, completion: nil)
        }))
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}
