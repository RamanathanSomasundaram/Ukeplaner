//
//  schoolLinksViewController.swift
//  Ukeplaner
//
//  Created by Lakeba_26 on 12/08/17.
//  Copyright © 2017 lakeba. All rights reserved.
//

import UIKit
import Firebase
class schoolLinksViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SWRevealViewControllerDelegate,internetConnectionDelegate {
    var schoolLinksList : NSMutableArray!
    var school_id : Int!
    @IBOutlet var refreshButton: UIButton!
   // var refreshControl : UIRefreshControl!
    @IBOutlet var tbl_schoolLinks: UITableView!
    var schoolWebLink : NSMutableArray!
    @IBOutlet var tbl_SchoolInfo: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        commonAppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.title = "lenker"
        self.loadNavigationItem()
        school_id = commonAppDelegate.school_id
        //self.refreshButton.isHidden = true
        self.revealViewController().delegate = self
        schoolLinksList = ["Melsom vgs","It's Learning","NDLA","Læreplaner","VKT (Bussen)","Ungt Entreprenørskap","Vestfold fylkeskommune","Eksamenskontoret"]
        schoolWebLink = ["https://www.vfk.no/Melsom-vgs/","https://vfk.itslearning.com/Index.aspx","https://ndla.no/","https://www.udir.no/laring-og-trivsel/lareplanverket/finn-lareplan/","https://www.vkt.no/","http://www.ukeplaner.com/school_info/groupinfo/www.ue.no","http://www.ukeplaner.com/school_info/groupinfo/www.vfk.no","https://www.vfk.no/Tema-og-tjenester/Utdanning/Eksamen/"]
       self.tbl_schoolLinks.register(UINib.init(nibName: "SchoolInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "schoolInfo")
        tbl_SchoolInfo.register(UINib.init(nibName: "SchoolTableViewCell", bundle: nil), forCellReuseIdentifier: "schoolCell")
        self.tbl_schoolLinks.tableFooterView = UIView()
        tbl_SchoolInfo.backgroundColor = UIColor.lightGray
        tbl_schoolLinks.backgroundColor = UIColor.lightGray
        self.view.backgroundColor = UIColor.lightGray
        // Do any additional setup after loading the view, typically from a nib. ic_school_search
    }
    
    func loadNavigationItem()
    {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = ThemeColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "slidemenu.png"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
    }
    @IBAction func refershAction(_ sender: Any) {
        schoolLinksList = ["Melsom vgs","It's Learning","NDLA","Læreplaner","VKT (Bussen)","Ungt Entreprenørskap","Vestfold fylkeskommune","Eksamenskontoret"]
        tbl_schoolLinks.reloadData()
    }
    //Loss internet connection
    func internetConnection()
    {
        //self.refreshButton.isHidden = false
        //Utilities.showAlert("Please check your internet connection!")
        schoolLinksList.removeAllObjects()
        self.tbl_SchoolInfo.reloadData()
        //self.loadInitialData()
        tbl_schoolLinks.reloadData()
    }
    //MARK: - tableview datasource and delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == tbl_SchoolInfo)
        {
            return 1
        }
        else
        {
        return schoolLinksList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == tbl_SchoolInfo)
        {
            let cell: SchoolTableViewCell = tableView.dequeueReusableCell(withIdentifier: "schoolCell") as! SchoolTableViewCell
                let view : UIView = (cell.viewWithTag(2000))!
                Utilities.makeCardView(view)
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.separatorInset = .zero
                cell.contentView.backgroundColor = UIColor.lightGray
                let dictValues = commonAppDelegate.SchoolDict.object(at: indexPath.row) as! NSDictionary
                DispatchQueue.main.async {
                   cell.configureCell(dictValues: dictValues)
                    cell.setNeedsDisplay()
                }
                tbl_SchoolInfo.isUserInteractionEnabled = false
            return cell
        }
        else
        {
        let cell : SchoolInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "schoolInfo") as! SchoolInfoTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.separatorInset = .zero
        let cellView = (cell.viewWithTag(600)!)
        cell.contentView.backgroundColor = UIColor.lightGray
        cellView.layer.cornerRadius = 25
        cell.configureCell(schoolinfo: (self.schoolLinksList.object(at: indexPath.row) as! String))
        cell.schoolInfoTitle.textAlignment = .center
        return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == tbl_SchoolInfo)
        {
            return 130
        }
        else
        {
        return 60
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(Utilities.checkForInternet())
        {
            let weblink = self.storyboard!.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            weblink.titleString = (self.schoolLinksList.object(at: indexPath.row) as! String)
            weblink.URLString = (self.schoolWebLink.object(at: indexPath.row) as! String)
            self.navigationController?.pushViewController(weblink, animated: true)
            Analytics.logEvent("Ukeplaner", parameters: ["Weblink_name" : "\(self.schoolLinksList.object(at: indexPath.row) as! String)" , "Website_URL" : "\(self.schoolWebLink.object(at: indexPath.row) as! String)", "Description" : "User visit this URL"])
        }
        else
        {
            self.callIntertnetView()
           // self.internetConnection()
        }
    }
    func callIntertnetView()
    {
        let internet = InternetConnectionViewController.init(nibName: "InternetConnectionViewController", root: self)
        internet.internetDelegate = self
        internet.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(internet, animated: true, completion: nil)
    }
    func internetconnection() {
        self.internetConnection()
    }
    //MARK: - REVEAL VIEW CONTROLLER DELEGATE
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        if(position == FrontViewPositionLeft){
            self.view.isUserInteractionEnabled = true
            //   self.navigationItem.rightBarButtonItem?.isEnabled = true
            
        } else {
            self.view.isUserInteractionEnabled = false
            //  self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if(position == FrontViewPositionLeft)
        {
            self.view.isUserInteractionEnabled = true
            
        } else {
            self.view.isUserInteractionEnabled = false
        }
    }
    //** End of reveal view controller delegate **//
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

