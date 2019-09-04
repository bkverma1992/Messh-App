//
//  FirstVC.swift
//  Mesh App
//
//  Created by Mac admin on 25/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class FirstVC: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource
{
    @IBOutlet weak var viewWalkThrough: UIView!
    
    @IBOutlet weak var imgPage3: UIImageView!
    @IBOutlet weak var imgPage2: UIImageView!
    @IBOutlet weak var imgPage1: UIImageView!
    
    var pageViewController : UIPageViewController?
    var arrPageImages = NSArray()
    var arrPageTitles = NSArray()
    var arrPageNewSubTitle = NSArray()
    
    @IBOutlet weak var pageControl: UIPageControl!
    //private var pageControl = UIPageControl(frame: .zero)

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        arrPageTitles = ["Silent","Relevant","Business On Chat"]
        arrPageImages = ["messages_image", "contacts_image", "calls_image"]
        
        arrPageNewSubTitle = ["Mesh is designed to be non-intrusive. No notifications, no unread message counts.", "Interests based message filtering. Easily catch up on conversations important only to you.", "All new, made for business, chat messaging based networking platform to help reach trusted contacts now."]

        //arrPageImages = ["pic1", "pic2", "pic1"]
        print("arrImage Count: ", arrPageImages.count)
        
        var pageControl = UIPageControl()
        pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.backgroundColor = UIColor.darkGray
        pageControl.numberOfPages = arrPageImages.count
        pageControl.center = view.center
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController!.dataSource = self
        
        let startingViewController: PageControlVC = viewControllerAtIndex(index: 0)!
        let viewControllers = [startingViewController]
        pageViewController!.setViewControllers(viewControllers , direction: .forward, animated: false, completion: nil)
        pageViewController!.view.frame = CGRect(x: 0, y: 0, width: self.viewWalkThrough.frame.size.width, height: self.viewWalkThrough.frame.size.height);
        
        addChildViewController(pageViewController!)
        viewWalkThrough.addSubview(pageViewController!.view)
        pageViewController!.didMove(toParentViewController: self)
        
        pageControl.layer.position.y = self.view.frame.height - 200;
        //self.setupPageControlNew()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        // Check for Location Services
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupPageControlNew()
    {
        pageControl.numberOfPages = self.arrPageImages.count
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        pageControl.pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.8)
        
        let leading = NSLayoutConstraint(item: pageControl, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: pageControl, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: pageControl, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        
        view.insertSubview(pageControl, at: 0)
        view.bringSubview(toFront: pageControl)
        view.addConstraints([leading, trailing, bottom])
    }
    
    //MARK:- UIPageViewController Delegate Method
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! PageControlVC).pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
       
//        if index == 2
//        {
//            self.imgPage1.image = UIImage(named: "gray")
//            self.imgPage2.image = UIImage(named: "gray")
//            self.imgPage3.image = UIImage(named: "app_blue")
//        }
        if index == 1
        {
            self.imgPage1.image = UIImage(named: "gray")
            self.imgPage2.image = UIImage(named: "app_blue")
            self.imgPage3.image = UIImage(named: "gray")
        }
        else if index == 0
        {
            self.imgPage1.image = UIImage(named: "app_blue")
            self.imgPage2.image = UIImage(named: "gray")
            self.imgPage3.image = UIImage(named: "gray")
        }
        
        index = index! - 1
        
        return viewControllerAtIndex(index: index!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! PageControlVC).pageIndex
        print("index: ", index!)
        
        if index == NSNotFound {
            return nil
        }
        
        if index == 0
        {
            self.imgPage1.image = UIImage(named: "app_blue")
            self.imgPage2.image = UIImage(named: "gray")
            self.imgPage3.image = UIImage(named: "gray")
        }
        else if index == 1
        {
            self.imgPage1.image = UIImage(named: "gray")
            self.imgPage2.image = UIImage(named: "app_blue")
            self.imgPage3.image = UIImage(named: "gray")
        }
        else if index == 2
        {
            self.imgPage1.image = UIImage(named: "gray")
            self.imgPage2.image = UIImage(named: "gray")
            self.imgPage3.image = UIImage(named: "app_blue")
        }
        
        
        index = index! + 1
        
        if (index == self.arrPageImages.count) {
            return nil
        }
        
        return viewControllerAtIndex(index: index!)
    }
    
    func viewControllerAtIndex(index: Int) -> PageControlVC?
    {
        if arrPageImages.count == 0 || index >= arrPageImages.count
        {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let objPageControl = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idPageControlVC") as! PageControlVC
        objPageControl.strImgName = arrPageImages[index] as? String
        objPageControl.strTitle = arrPageTitles[index] as? String
        objPageControl.strSubTitle = arrPageNewSubTitle[index] as? String
        objPageControl.pageIndex = index
        //currentIndex = index
        
        return objPageControl
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.gray
        appearance.currentPageIndicatorTintColor = UIColor.white
        appearance.backgroundColor = UIColor.darkGray
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        setupPageControlNew()
        //setupPageControl()
        return arrPageImages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    //MARK:- Button Action
    
    @IBAction func btnSkip_Click(_ sender: Any)
    {
        let objWelcomeScreenVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idWelcomeScreenVC") as! WelcomeScreenVC
        self.navigationController?.pushViewController(objWelcomeScreenVC, animated: true)
    }
}
