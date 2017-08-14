//
//  informationSchoolViewController.swift
//  Ukeplaner
//
//  Created by Lakeba_26 on 12/08/17.
//  Copyright © 2017 lakeba. All rights reserved.
//

import UIKit

class informationSchoolViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var schoolinfoList : NSMutableArray!
    var school_id : Int!
    
    @IBOutlet var noInfoLabel: UILabel!
    @IBOutlet var tbl_schoolinfo: UITableView!
    var refreshControl : UIRefreshControl!

    @IBOutlet var refreshButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonAppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.noInfoLabel.isHidden = true
        self.title = "Informasjon fra skolen"
        self.school_id = commonAppDelegate.school_id
        self.loadNavigationItem()
        schoolinfoList = NSMutableArray()
        self.loadInitialData()
        // Do any additional setup after loading the view.
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tbl_schoolinfo.addSubview(refreshControl)
        // Do any additional setup after loading the view, typically from a nib. ic_school_search
    }
    func refreshTableView()
    {
        self.tbl_schoolinfo.reloadData()
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
            self.tbl_schoolinfo.isUserInteractionEnabled = true
           self.refreshButton.isHidden = true
            Utilities.showLoading()
            let url = URL(string: "http://ukeplaner.com/api/GroupMsg_1?schoolid=\(school_id!)")
            DispatchQueue.main.async {
                let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                    guard error == nil else {
                        print(error!)
                        Utilities.hideLoading()
                        Utilities.showAlert("\(error!)")
                        return
                    }
                    guard let data = data else {
                        print("Data is empty")
                        Utilities.hideLoading()
                        self.noInfoLabel.isHidden = false
                        return
                    }
                    let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [Any]
                    for i in 0..<json.count
                    {
                        self.schoolinfoList.add(json[i])
                    }
                    DispatchQueue.main.sync {
                        self.tbl_schoolinfo.reloadData()
                            Utilities.hideLoading()
                    }
                }
                task.resume()
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
        self.tbl_schoolinfo.isUserInteractionEnabled = false
        Utilities.showAlert("Please check your internet connection!")
        schoolinfoList.removeAllObjects()
        tbl_schoolinfo.reloadData()
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

        return schoolinfoList.count
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
        self.makeCardView(cellView!)
        let dictValues = self.schoolinfoList.object(at: indexPath.row) as! NSDictionary
        cell?.schoolInfoTitle.textColor = TextColor
        cell?.schoolInfoTitle.text = (dictValues.value(forKey: "schoolinfo") as! String)
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
