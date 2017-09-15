//
//  schoolLinksViewController.swift
//  Ukeplaner
//
//  Created by Lakeba_26 on 12/08/17.
//  Copyright © 2017 lakeba. All rights reserved.
//

import UIKit

class schoolLinksViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var schoolLinksList : NSMutableArray!
    var school_id : Int!
    @IBOutlet var refreshButton: UIButton!
    var refreshControl : UIRefreshControl!
    @IBOutlet var tbl_schoolLinks: UITableView!
    var schoolWebLink : NSMutableArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        commonAppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.title = "lenker"
        self.loadNavigationItem()
        school_id = commonAppDelegate.school_id
        self.refreshButton.isHidden = true
        schoolLinksList = ["Melsom vgs","It's Learning","NDLA","Læreplaner","VKT (Bussen)","Ungt Entreprenørskap","Vestfold fylkeskommune","Eksamenskontoret"]
        schoolWebLink = ["https://www.vfk.no/Melsom-vgs/","https://vfk.itslearning.com/Index.aspx","https://ndla.no/","https://www.udir.no/laring-og-trivsel/lareplanverket/finn-lareplan/","https://www.vkt.no/","http://www.ukeplaner.com/school_info/groupinfo/www.ue.no","http://www.ukeplaner.com/school_info/groupinfo/www.vfk.no","https://www.vfk.no/Tema-og-tjenester/Utdanning/Eksamen/"]
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = TextColor
        let attr = [NSForegroundColorAttributeName:UIColor.white]
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes:attr)
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tbl_schoolLinks.addSubview(refreshControl)
        self.tbl_schoolLinks.tableFooterView = UIView()
        // Do any additional setup after loading the view, typically from a nib. ic_school_search
    }
    func refreshTableView()
    {
        self.tbl_schoolLinks.reloadData()
        refreshControl.endRefreshing()
        
    }
    func loadNavigationItem()
    {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = ThemeColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
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
        self.refreshButton.isHidden = false
        Utilities.showAlert("Please check your internet connection!")
        schoolLinksList.removeAllObjects()
        tbl_schoolLinks.reloadData()
        
    }
    //Make card view on cell View
    func makeCardView (_ cell : UIView)
    {
        cell.layer.cornerRadius = 8
        cell.layer.shadowRadius = 2.5
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 0.2)
        cell.layer.masksToBounds  = false
        let shadowPath = UIBezierPath(rect: cell.bounds)
        cell.layer.shadowPath = shadowPath.cgPath
        cell.layer.shadowOpacity = 0.9
    }
    //MARK: - tableview datasource and delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return schoolLinksList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "schoolinfo") as? SchoolInfoTableViewCell
        if(cell == nil)
        {
            //Load the top-level objects from the custom cell XIB.
            var topLevelObjects = Bundle.main.loadNibNamed("SchoolInfoTableViewCell", owner: self, options: nil)
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = topLevelObjects?[0] as! SchoolInfoTableViewCell?
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        cell?.separatorInset = .zero
        let cellView = (cell?.viewWithTag(600)!)
        
        cellView?.layer.cornerRadius = 25
        //self.makeCardView(cellView!)
        cell?.schoolInfoTitle.textColor = TextColor
        cell?.schoolInfoTitle.textAlignment = .center
        cell?.schoolInfoTitle.text = (self.schoolLinksList.object(at: indexPath.row) as! String)
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(Utilities.checkForInternet())
        {
            let weblink = self.storyboard!.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            weblink.URLString = (self.schoolWebLink.object(at: indexPath.row) as! String)
            self.navigationController?.pushViewController(weblink, animated: true)
        }
        else
        {
            self.internetConnection()
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

