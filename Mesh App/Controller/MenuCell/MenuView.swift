//
//  MenuView.swift
//  Mesh App
//
//  Created by Mac admin on 04/10/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class MenuView: UIView, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var lblMenuTitle: UILabel!
    //@IBOutlet weak var tblMenuList: UITableView!
    var tblMenuList: UITableView!
    var arrMenuTitle = NSArray()
    
    weak var menuDelegate: menuViewDelegate?

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        let CellIdentifier = "idMenuCell"
        tblMenuList = UITableView(frame: CGRect(x: 0, y: 0, width:self.frame.size.width, height: self.frame.size.height))
        print("tblMenuList :",tblMenuList.frame)
        tblMenuList.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: CellIdentifier)
        tblMenuList.delegate = self
        tblMenuList.dataSource = self
        tblMenuList.backgroundColor = UIColor.white
        tblMenuList.layer.cornerRadius = 5
        tblMenuList.layer.masksToBounds = true

        self.addSubview(tblMenuList)

        arrMenuTitle = ["Home", "Profile", "Add New Group",  "Terms of Use"]

        self.tblMenuList.estimatedRowHeight = 85.0
        self.tblMenuList.rowHeight = UITableViewAutomaticDimension
        self.tblMenuList.separatorStyle = .none

        self.tblMenuList.tableFooterView = UIView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        //return UITableViewAutomaticDimension        
        return ((tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath))?.contentView.frame.size.height)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrMenuTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:MenuTableViewCell = self.tblMenuList.dequeueReusableCell(withIdentifier: "idMenuCell") as! MenuTableViewCell
        cell.selectionStyle = .none
        cell.lblMenuTitle.text = self.arrMenuTitle[indexPath.row] as? String       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        menuDelegate?.navigateToController(index: indexPath.row)
    }
}

protocol menuViewDelegate : class{
    func navigateToController(index: Int)
}

extension MenuView
{
    // OUTPUT 1
    func dropShadow(scale: Bool = true)
    {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 5
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
