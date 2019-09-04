//
//  MediaVC.swift
//  Mesh App
//
//  Created by Mac admin on 27/09/18.
//  Copyright © 2018 Swati. All rights reserved.
//

import UIKit

class MediaVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SelectedMediaCellDelegate
{
    @IBOutlet weak var tblMedia: UITableView!
    
    var arrSectionData = NSArray()
    var arrRowData = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        arrSectionData = ["July","August","Last Week", "Recent"]
        arrRowData = [["1", "2", "3"], ["1", "2"],["1", "2","3"],["1"]]
        print("arrRowData: ", arrRowData)
        
        self.tblMedia.estimatedRowHeight = 100.0
        self.tblMedia.rowHeight = UITableViewAutomaticDimension
        
        self.tblMedia.tableFooterView = UIView()
        
       // self.tblMedia.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnBack_Click(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }    
    
    // MARK: - Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return ((tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath))?.contentView.frame.size.height)!
        //return UITableViewAutomaticDimension
        
       /*if indexPath.section == 0
        {
            //return UITableViewAutomaticDimension
            return 300
        }
        else
        {
            return ((tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath))?.contentView.frame.size.height)!
        }*/
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (self.arrRowData[section] as AnyObject).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:MediaTableViewCell = self.tblMedia.dequeueReusableCell(withIdentifier: "idMediaNewCell") as! MediaTableViewCell
        cell.cellSelectedMediaDelegate = self
        cell.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.arrSectionData.count
    }
    
//    func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String?
//    {
//        return self.arrSectionData[section] as? String
////        switch(section)
////         {
////         case 1:return "Hang Trinh"
////         default :return ""
////         }
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        view.backgroundColor = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1) //UIColor.white
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.bounds.width - 30, height: 30))
        label.font = UIFont(name: "TitilliumWeb-SemiBold", size: 18.0)      //UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.text = self.arrSectionData[section] as? String
        view.addSubview(label)
        return view
    }
    
    func didSelectMedia_Click(_ tag: Int, _strImage: String)
    {
        print("I have pressed a button with a tag: \(tag)")
        let objSelectedImageVC = Constant.mainStoryboard.instantiateViewController(withIdentifier: "idSelectedImageVC") as! SelectedImageVC
        objSelectedImageVC.strSelectedImage = _strImage
        self.navigationController?.pushViewController(objSelectedImageVC, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 20
//    }
}
