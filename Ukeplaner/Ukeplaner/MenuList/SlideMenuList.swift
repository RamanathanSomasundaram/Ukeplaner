//
//  SlideMenuList.swift
//  MusixxiRecorder
//
//  Created by Lakeba-026 on 06/12/16.
//  Copyright © 2016 Lakeba Corporation Pty Ltd. All rights reserved.
//

import UIKit


class SlideMenuList: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet var tbl_schoolMenu: UITableView!
    var menuTitleList : NSMutableArray!
    var menuIconList : NSMutableArray!
    var selectMenuIconList : NSMutableArray!
    override func viewDidLoad() {
        menuTitleList = NSMutableArray()
        menuIconList = NSMutableArray()
        selectMenuIconList = NSMutableArray()
        menuTitleList = ["Skoler","Gruppeinfo","Informasjon fra skolen", "Informasjon fra elevrådet","Ukeplanregler","lenker","Rulleliste"]
        menuIconList = ["gic_school","gic_group_info","gic_information_school","gic_student_council","gic_weekly_schedule","gic_student_links","gic_student_rules"]
        selectMenuIconList = ["ic_school","ic_group_info","ic_information_school","ic_student_council","ic_weekly_schedule","ic_student_links","ic_student_rules"]
    }
    //MARK: - Tableview Datasource and Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitleList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "RecordListCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        if cell == nil{
            cell = UITableViewCell.init(style: .default, reuseIdentifier:CellIdentifier )
        }
        cell?.textLabel?.font = UIFont(name: "Helvetica", size: 15.0)
        cell?.imageView?.tintColor = UIColor.lightGray
        cell?.textLabel?.text = (menuTitleList.object(at: indexPath.row) as! String)
        cell?.imageView?.image = UIImage.init(named: (menuIconList.object(at: indexPath.row) as! String))
        cell?.imageView?.highlightedImage = UIImage.init(named: (selectMenuIconList.object(at: indexPath.row) as! String))
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0)
        {
            self.performSegue(withIdentifier: "home", sender: nil)
            self.tbl_schoolMenu.deselectRow(at: indexPath, animated: true)
        }
        else if(indexPath.row == 1)
        {
            self.performSegue(withIdentifier: "groupinfo", sender: nil)
        }
        else if(indexPath.row == 2)
        {
            self.performSegue(withIdentifier: "schoolinfo", sender: nil)
        }
        else if(indexPath.row == 3)
        {
            self.performSegue(withIdentifier: "schoolcouncil", sender: nil)
        }
        else if(indexPath.row == 4)
        {
            self.performSegue(withIdentifier: "weekly", sender: nil)
        }
        else if (indexPath.row == 5)
        {
            self.performSegue(withIdentifier: "links", sender: nil)
        }
        else
        {
            self.performSegue(withIdentifier: "rules", sender: nil)
        }
    }
    //MARK: - Prepare for segue action
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue .isKind(of: SWRevealViewControllerSegue.self)){
            let swSegue = (segue as! SWRevealViewControllerSegue)
            swSegue.performBlock = {(_ rvc_segue: SWRevealViewControllerSegue?, _ svc: UIViewController?, _ dvc: UIViewController?) -> Void in
                let navController = (self.revealViewController().frontViewController as! UINavigationController)
                navController.setViewControllers([dvc!], animated: false)
                self.revealViewController().setFrontViewPosition(FrontViewPositionLeft, animated: true)
            }
        }
    }

    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

