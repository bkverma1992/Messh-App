//
//  GroupParticipantsActionView.swift
//  Mesh App
//
//  Created by Yugasalabs-28 on 13/02/2019.
//  Copyright © 2019 Swati. All rights reserved.
//

import UIKit

class GroupParticipantsActionView: UIView, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var lblMenuTitle: UILabel!
    //@IBOutlet weak var tblMenuList: UITableView!
    var tblGroupActionList: UITableView!
    var arrGroupActionTitle = NSArray()
    
    var objParticipants : Participants?
    var isAdmin = Bool()
    
    weak var groupActionDelegate: groupActionViewDelegate?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        let CellIdentifier = "idGroupActionCell"
        tblGroupActionList = UITableView(frame: CGRect(x: 0, y: 0, width:self.frame.size.width, height: self.frame.size.height))
        tblGroupActionList.register(UINib(nibName: "GroupParticipantsActionCell", bundle: nil), forCellReuseIdentifier: CellIdentifier)
        tblGroupActionList.delegate = self
        tblGroupActionList.dataSource = self
        tblGroupActionList.backgroundColor = UIColor.white
        tblGroupActionList.layer.cornerRadius = 5
        tblGroupActionList.layer.masksToBounds = true
        tblGroupActionList.isScrollEnabled = false
        
        self.addSubview(tblGroupActionList)
        let dict = DefaultsValues.getUserValueFromUserDefaults_(forKey: "participants")
        
        let objParticipants =   Participants.init(dictionary: (dict)!)
        
        if isAdmin == true
        {
            arrGroupActionTitle = [String(format: "View %@",objParticipants!.participantsName!), String(format: "Message %@",objParticipants!.participantsName!)]
           // arrGroupActionTitle = [String(format: "View %@",objParticipants!.participantsName!), String(format: "Message %@",objParticipants!.participantsName!), String(format: "Remove %@",objParticipants!.participantsName!)]

        }
        else if isAdmin == false
        {
            arrGroupActionTitle = [String(format: "View %@",objParticipants!.participantsName!), String(format: "Message %@",objParticipants!.participantsName!), String(format: "Remove %@",objParticipants!.participantsName!)]
            print(arrGroupActionTitle)
        }
        
//        arrGroupActionTitle = [String(format: "View %@",objParticipants!.participantsName!), String(format: "Message %@",objParticipants!.participantsName!)]
        
        self.tblGroupActionList.estimatedRowHeight = 85.0
        self.tblGroupActionList.rowHeight = UITableViewAutomaticDimension
        self.tblGroupActionList.separatorStyle = .none
        
        self.tblGroupActionList.tableFooterView = UIView()
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
        return arrGroupActionTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:GroupParticipantsActionCell = self.tblGroupActionList.dequeueReusableCell(withIdentifier: "idGroupActionCell") as! GroupParticipantsActionCell
        cell.selectionStyle = .none
        cell.lblActionTitle.text = self.arrGroupActionTitle[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        groupActionDelegate?.navigateToGroupActionController(index: indexPath.row)
    }
}

protocol groupActionViewDelegate : class{
    func navigateToGroupActionController(index: Int)
}

extension GroupParticipantsActionView
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

