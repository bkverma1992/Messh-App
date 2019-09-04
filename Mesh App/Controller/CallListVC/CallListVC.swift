//
//  CallListVC.swift
//  Mesh App
//
//  Created by Mac admin on 24/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class CallListVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnMissed: UIButton!
    @IBOutlet weak var btnUnknown: UIButton!
    @IBOutlet weak var viewUnknown: UIView!
    @IBOutlet weak var viewMissed: UIView!
    @IBOutlet weak var tblCall: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tblCall.estimatedRowHeight = 85.0
        self.tblCall.rowHeight = UITableViewAutomaticDimension
        
        self.tblCall.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnAll_Click(_ sender: Any)
    {
        
    }
    
    @IBAction func btnMissed_Click(_ sender: Any)
    {
        
    }
    
    @IBAction func btnUnknown_Click(_ sender: Any)
    {
        
    }
    
    // MARK: - Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
        
        //return ((tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath))?.contentView.frame.size.height)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CallListTableViewCell = self.tblCall.dequeueReusableCell(withIdentifier: "idCallListCell") as! CallListTableViewCell
        
        cell.imgCallProfile.layer.cornerRadius = cell.imgCallProfile.frame.size.height/2
        cell.imgCallProfile.layer.masksToBounds = true
        
//        cell.lblTitle.text = arrPrivacyTitleList[indexPath.row] as? String
//        cell.lblSubTitle.text = arrPrivacySubTitleList[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
}
