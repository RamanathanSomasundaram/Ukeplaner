//
//  weeklyScheduleViewController.swift
//  Ukeplaner
//
//  Created by Lakeba_26 on 12/08/17.
//  Copyright © 2017 lakeba. All rights reserved.
//

import UIKit

class weeklyScheduleViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,SWRevealViewControllerDelegate {
    var schoolWeekList : NSMutableArray!
    var school_id : Int!
    
    @IBOutlet var noweekLabel: UILabel!
    @IBOutlet var tbl_weeklyList: UITableView!
    var refreshControl : UIRefreshControl!
    
    @IBOutlet var refreshButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonAppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.title = "Ukeplanregler"
        self.noweekLabel.isHidden = true
        self.loadNavigationItem()
        school_id = commonAppDelegate.school_id
        schoolWeekList = NSMutableArray()
        self.revealViewController().delegate = self
        self.tbl_weeklyList.register(UINib.init(nibName: "SchoolInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "schoolInfo")
        self.loadInitialData()
        
        // Do any additional setup after loading the view.
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tbl_weeklyList.addSubview(refreshControl)
        // Do any additional setup after loading the view, typically from a nib. ic_school_search
    }

    @objc func refreshTableView()
    {
        self.tbl_weeklyList.reloadData()
        refreshControl.endRefreshing()
        
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
    
    @IBAction func refreshAction(_ sender: Any) {
        self.loadInitialData()
    }
    
    func loadInitialData()
    {
        if(Utilities.checkForInternet())
        {
            self.tbl_weeklyList.isUserInteractionEnabled = true
            self.refreshButton.isHidden = true
            Utilities.showLoading()
            Alamofire.request("\(CommonAPI)Ukeplanregler?schoolid=\(school_id!)").responseJSON { response in
                let error = response.result.error
                if error != nil
                {
                    Utilities.hideLoading()
                    Utilities.showAlert("\(error!)")
                    return
                }
                if let json = response.result.value {
                    if ((json as AnyObject).isKind(of: NSArray.self))
                    {
                        let jsonResponse = (json as! [Any])
                        for i in 0..<jsonResponse.count
                        {
                            self.schoolWeekList.add(jsonResponse[i])
                        }
                        self.tbl_weeklyList.reloadData()
                    }
                    else
                    {
                        let jsonError = (json as AnyObject).value(forKey: "ErrorMessage")!
                        self.noweekLabel.isHidden = false
                        self.noweekLabel.text = (jsonError as! String)
                        print(jsonError)
                    }
                    DispatchQueue.main.async {
                        
                        self.tbl_weeklyList.reloadData()
                        Utilities.hideLoading()
                    }
                }
            }
        }
        else
        {
            self.internetConnection()
        }
    }
    //Loss internet connection
    func internetConnection()
    {
        self.tbl_weeklyList.isUserInteractionEnabled = false
        Utilities.showAlert("Please check your internet connection!")
        schoolWeekList.removeAllObjects()
        self.tbl_weeklyList.reloadData()
        refreshButton.isHidden = false
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
        
        return schoolWeekList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : SchoolInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "schoolInfo") as! SchoolInfoTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.separatorInset = .zero
        let cellView = cell.viewWithTag(600)
        self.makeCardView(cellView!)
        let dictValues = self.schoolWeekList.object(at: indexPath.row) as! NSDictionary
        cell.schoolInfoTitle.textColor = TextColor
        cell.schoolInfoTitle.text = (dictValues.value(forKey: "Ukeplanregler") as! String)
        cell.schoolInfoTitle.sizeToFit()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    deinit {
        self.schoolWeekList.removeAllObjects()
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
