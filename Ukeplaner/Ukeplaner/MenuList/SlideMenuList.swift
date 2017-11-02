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
    var menuSecondArray : NSMutableArray!
    var menuSecondArrayIcon : NSMutableArray!
    var menuHighlightImage : NSMutableArray!
    var selectMenuIconList : NSMutableArray!
    override func viewDidLoad() {
        menuTitleList = NSMutableArray()
        menuIconList = NSMutableArray()
        menuSecondArray = NSMutableArray()
        menuSecondArrayIcon = NSMutableArray()
        selectMenuIconList = NSMutableArray()
        menuHighlightImage = NSMutableArray()
        menuTitleList = ["Skoler","Klasser","Informasjon fra skolen", "Informasjon fra elevrådet","Ukeplanregler","Lenker","Viktig beskjed"]
        menuIconList = ["gic_school","gic_group_info","gic_information_school","gic_student_council","gic_weekly_schedule","gic_student_links","gic_student_rules"]
        selectMenuIconList = ["ic_school","ic_group_info","ic_information_school","ic_student_council","ic_weekly_schedule","ic_student_links","ic_student_rules"]
        menuSecondArray = ["Vurder oss","Om oss","Del Ukeplaner"]
        menuSecondArrayIcon = ["ic_star","ic_about","ic_share"]
        menuHighlightImage = ["gic_star","gic_about","gic_share"]
    }
    //MARK: - Tableview Datasource and Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
        return menuTitleList.count
        }
        else
        {
            return menuSecondArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "RecordListCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        if cell == nil{
            cell = UITableViewCell.init(style: .default, reuseIdentifier:CellIdentifier )
        }
        cell?.textLabel?.font = UIFont(name: "Helvetica", size: 15.0)
        cell?.imageView?.tintColor = UIColor.lightGray
        if(indexPath.section == 0)
        {
        cell?.textLabel?.text = (menuTitleList.object(at: indexPath.row) as! String)
        cell?.imageView?.image = UIImage.init(named: (menuIconList.object(at: indexPath.row) as! String))
        cell?.imageView?.highlightedImage = UIImage.init(named: (selectMenuIconList.object(at: indexPath.row) as! String))
        }
        else
        {
            cell?.textLabel?.text = (menuSecondArray.object(at: indexPath.row) as! String)
            cell?.imageView?.image = UIImage.init(named: (menuHighlightImage.object(at: indexPath.row) as! String))
            cell?.imageView?.highlightedImage = UIImage.init(named: (menuSecondArrayIcon.object(at: indexPath.row) as! String))
        }        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0.5
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 1)
        {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0.5))
        headerView.backgroundColor = UIColor.darkGray
        return headerView
        }
        return nil
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0)
        {
        if(indexPath.row == 0)
        {
            self.performSegue(withIdentifier: "home", sender: nil)
            commonAppDelegate.SchoolDict.removeAllObjects()
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
        else
        {
            if(indexPath.row == 0)
            {
                //Ratenow
                self.rateApp(appId: "id1290367397", completion: { (success) in
                    print("Success")
                })
//                let ratenowAlert = UIAlertController(title: "Vurder denne appen", message: "Takk for at du bruker denne appen. Din tilbakemelding er viktig for oss!", preferredStyle: .alert)
//                let rateNow = UIAlertAction(title: "VURDER NÅ", style: .default, handler: { (action) ->Void in
//                    //Ratenow
//                    self.rateApp(appId: "1290367397", completion: { (success) in
//                        print("Success")
//                    })
//                })
//                let rateNotnow = UIAlertAction(title: "IKKE NÅ", style: .cancel, handler: nil)
//                ratenowAlert.addAction(rateNow)
//                ratenowAlert.addAction(rateNotnow)
//                self.present(ratenowAlert, animated: true, completion: nil)
            }
            else if(indexPath.row == 1)
            {
                UIApplication .shared.openURL(URL(string: "http://inventuretechnology.com/overview.php")!)
            }
            else
            {
                //Share Option
                self.sharewith()
            }
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

    //Rating a app
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    //MARK: - Share a file action
    func sharewith()
    {
        DispatchQueue.main.async(execute: {() -> Void in
            let currentFileName = "https://itunes.apple.com/us/app/ukeplaner/id1290367397?mt=8"
            let sharingText = "Liker å bruke Ukeplaner. Prøv du også!"
            let sharingImage = UIImage.init(named: "menu_logo.png")!
            let sharingURL = URL.init(string: currentFileName)
            //let sharingItems:[AnyObject?] = [ sharingText,sharingImage as AnyObject,sharingURL as AnyObject]
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [sharingText, sharingURL!, sharingImage], applicationActivities: nil)
            //let activityViewController = UIActivityViewController(activityItems: sharingItems.flatMap({$0}), applicationActivities: nil)
            if UIDevice.current.userInterfaceIdiom == .pad {
                activityViewController.popoverPresentationController?.sourceView = self.view
                let popup = UIPopoverController.init(contentViewController: activityViewController) as UIPopoverController
                popup.present(from: CGRect(x: CGFloat(self.view.frame.size.width / 2), y: CGFloat(self.view.frame.size.height / 4), width: CGFloat(0), height: CGFloat(0)), in: self.view, permittedArrowDirections: .any, animated: true)
            }
            else{
                self.present(activityViewController, animated: true, completion: nil)
            }
        })
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

