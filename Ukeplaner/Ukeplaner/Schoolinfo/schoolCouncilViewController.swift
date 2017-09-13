//
//  schoolCouncilViewController.swift
//  Ukeplaner
//
//  Created by Lakeba_26 on 12/08/17.
//  Copyright © 2017 lakeba. All rights reserved.
//

import UIKit

class schoolCouncilViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var studentCouncilList : NSMutableArray!
    var school_id : Int!
    
    @IBOutlet var nocouncilLabel: UILabel!
    @IBOutlet var tbl_schoolcouncil: UITableView!
    var refreshControl : UIRefreshControl!

    @IBOutlet var refreshButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonAppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.nocouncilLabel.isHidden = true
        self.title = "Informasjon fra elevrådet"
        self.loadNavigationItem()
        school_id = commonAppDelegate.school_id
        studentCouncilList = NSMutableArray()
        self.loadInitialData()
        // Do any additional setup after loading the view.
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tbl_schoolcouncil.addSubview(refreshControl)
        // Do any additional setup after loading the view, typically from a nib. ic_school_search
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tbl_schoolcouncil.reloadData()
    }
    func refreshTableView()
    {
        self.tbl_schoolcouncil.reloadData()
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
    
    
    @IBAction func refreshAction(_ sender: Any) {
        self.loadInitialData()
    }
    
    func loadInitialData()
    {
        if(Utilities.checkForInternet())
        {
            self.tbl_schoolcouncil.isUserInteractionEnabled = true
            self.refreshButton.isHidden = true
            Utilities.showLoading()
            Alamofire.request("\(CommonAPI)Informasjon?schoolid=\(school_id!)").responseJSON { response in
                if let json = response.result.value {
                    if ((json as AnyObject).isKind(of: NSArray.self))
                    {
                        let jsonResponse = (json as! [Any])
                        for i in 0..<jsonResponse.count
                        {
                            self.studentCouncilList.add(jsonResponse[i])
                        }

                    }
                    else
                    {
                        let jsonError = (json as AnyObject).value(forKey: "ErrorMessage")!
                        self.nocouncilLabel.isHidden = false
                        print(jsonError)
                    }
                    DispatchQueue.main.async {
                         self.tbl_schoolcouncil.register(UINib.init(nibName: "SchoolInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "schoolInfo")
                        self.tbl_schoolcouncil.reloadData()
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
        self.tbl_schoolcouncil.isUserInteractionEnabled = false
        Utilities.showAlert("Please check your internet connection!")
        studentCouncilList.removeAllObjects()
        self.tbl_schoolcouncil.reloadData()
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

        return studentCouncilList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : SchoolInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "schoolInfo") as! SchoolInfoTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.separatorInset = .zero
        let cellView = (cell.viewWithTag(600)!)
        self.makeCardView(cellView)
        let dictValues = self.studentCouncilList.object(at: indexPath.row) as! NSDictionary
        cell.schoolInfoTitle.textColor = TextColor
        cell.schoolInfoTitle.text = (dictValues.value(forKey: "studentinfo") as! String)
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
        self.studentCouncilList.removeAllObjects()
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
