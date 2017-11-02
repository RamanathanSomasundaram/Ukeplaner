//
//  ViewController.swift
//  Ukeplaner
//
//  Created by Lakeba_26 on 11/08/17.
//  Copyright © 2017 lakeba. All rights reserved.
//

import UIKit
import Foundation
import Firebase
let ThemeColor : UIColor = UIColor(red: 30.0/255.0, green: 34.0/255.0, blue: 39.0/255.0, alpha: 1.0)
let TextColor : UIColor = UIColor(red: 140.0/255.0, green: 198.0/255.0, blue: 62.0/255.0, alpha: 1.0)
class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,internetConnectionDelegate,UISearchBarDelegate {
    
    
    @IBOutlet var searchbarConstraint: NSLayoutConstraint!
    @IBOutlet var tableviewConstraint: NSLayoutConstraint!
    @IBOutlet var searchBarController: UISearchBar!
    @IBOutlet var tbl_schoolList: UITableView!
    var schoolListArray : NSMutableArray!
    @IBOutlet var refreshButton: UIButton!
    var isFiltered : Bool = false
    var arrayForSearchFiles : NSMutableArray!
    var searchString: String!
    var refreshControl : UIRefreshControl!
    @IBOutlet var noSchoolInfo: UILabel!
    var searchBarBool : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.refreshButton.isHidden = true
        self.noSchoolInfo.isHidden = true
        commonAppDelegate = UIApplication.shared.delegate as! AppDelegate
        schoolListArray = NSMutableArray()
        self.searchbarConstraint.constant = -40
        self.tbl_schoolList.tableFooterView = UIView()
        self.navigationBarItems()
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = TextColor
        let attr = [NSAttributedStringKey.foregroundColor:UIColor.white]
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes:attr)
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tbl_schoolList.addSubview(refreshControl)
        self.loadInitialData()
        // Do any additional setup after loading the view, typically from a nib. ic_school_search
    }
    @objc func refreshTableView()
    {
        self.tbl_schoolList.reloadData()
        refreshControl.endRefreshing()
    }
    func navigationBarItems()
    {
        self.navigationController?.navigationBar.barTintColor = ThemeColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        commonAppDelegate.recordController = self
        let flipRightButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_school_search.png"), style: .plain, target: self, action: #selector(search))
        flipRightButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = flipRightButton
        let slideMenu : SlideMenuList? = (self.revealViewController().rearViewController as? SlideMenuList)
        slideMenu?.tbl_schoolMenu.selectRow(at: [0,1], animated: true, scrollPosition: .none)
        self.title = "SKOLER"
        isFiltered = false

    }
    @objc func search()
    {
        if(!searchBarBool)
        {
        searchBarBool = true
        searchbarConstraint.constant = 0
        tableviewConstraint.constant = 40
        searchBarController.showsCancelButton = true
        searchBarController.delegate = self
        searchBarController.returnKeyType = .search
        searchBarController.becomeFirstResponder()
        }
        else
        {
            searchBarBool = false
            searchbarConstraint.constant = -40
            tableviewConstraint.constant = 0
            searchBarController.resignFirstResponder()
            searchBarController.text = ""
            searchString = ""
            isFiltered = false
            self.tbl_schoolList.reloadData()
        }
    }
    //MARK: - user click on the search icon to search the items in the tables list
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBarController.resignFirstResponder()
        self.tbl_schoolList.reloadData()
        //self.searchBarController.endEditing(true)
    }
    // user can change the text
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
           // searchBar.resignFirstResponder()
            //searchBarController.resignFirstResponder()
            isFiltered = false
            self.tbl_schoolList.reloadData()
            searchString = ""
        }
        else {
            arrayForSearchFiles = NSMutableArray()
            searchString = searchText
            for i in 0 ..< schoolListArray.count
            {
               // let rec = (schoolListArray.object(at: i) as AnyObject).value(forKey: "school_name") as! String
                let rec = schoolListArray.object(at: i) as! NSDictionary
                let finalName = (rec.value(forKey: "school_name") as! String)
                let stringMatch = finalName.lowercased().range(of:searchText.lowercased())
                if(stringMatch != nil)
                {
                    //print("success")
                    let dicAudioTypeDetails = rec
                    arrayForSearchFiles.add(dicAudioTypeDetails)
                }
                else
                {
                    // print("failure")
                }
                
            }
            isFiltered = true
            self.tbl_schoolList.reloadData()
        }
    }
    
    // user finished editing the search text
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
       // searchBar.resignFirstResponder()
        searchBarController.resignFirstResponder()
        //self.searchBarController.endEditing(true)
        //searchBar.endEditing(true)
    }
    
    // Search bar cancel button clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //print("search cancel click")
        searchBar.resignFirstResponder()
        searchBarController.resignFirstResponder()
        searchBar.text = ""
        searchBarBool = false
        searchbarConstraint.constant = -40
        self.tableviewConstraint.constant = 0
        isFiltered = false
        self.searchBarController.endEditing(true)
        self.tbl_schoolList.reloadData()
    }

    @IBAction func refreshData(_ sender: Any) {
        self.loadInitialData()
    }
    
    func loadInitialData()
    {
        tbl_schoolList.register(UINib.init(nibName: "SchoolTableViewCell", bundle: nil), forCellReuseIdentifier: "schoolCell")
        if(Utilities.checkForInternet())
        {
            tbl_schoolList.isUserInteractionEnabled = true
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.noSchoolInfo.isHidden = true
            //self.refreshButton.isHidden = true
            Utilities.showLoading()
            Alamofire.request("\(CommonAPI)schoolList").responseJSON { response in
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
                            self.schoolListArray.add(jsonResponse[i])
                        }
                    }
                    else
                    {
                        let jsonError = (json as AnyObject).value(forKey: "ErrorMessage")!
                        self.noSchoolInfo.isHidden = false
                        self.noSchoolInfo.text = (jsonError as! String)
                        print(jsonError)
                    }
                    DispatchQueue.main.async {
                        self.tbl_schoolList.reloadData()
                        Utilities.hideLoading()
                    }
                }
            }
        }
        else
        {
            self.callIntertnetView()
            //self.internetConnection()
        }
    }
    //MARK: - Tableview Datasource and Delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        if(isFiltered)
        {
            return arrayForSearchFiles.count
        }
        else
        {
        return schoolListArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: SchoolTableViewCell = tableView.dequeueReusableCell(withIdentifier: "schoolCell") as! SchoolTableViewCell
        if(Utilities.checkForInternet())
        {
        let view : UIView = (cell.viewWithTag(2000))!
        Utilities.makeCardView(view)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.separatorInset = .zero
        var dictValues : NSDictionary!
        if(isFiltered)
        {
            dictValues = self.arrayForSearchFiles.object(at: indexPath.row) as! NSDictionary
            for subview: UIView in (cell.contentView.subviews){
                if (subview is UIButton) {
                    subview.removeFromSuperview()
                }
            }
        }
        else
        {
            dictValues = self.schoolListArray.object(at: indexPath.row) as! NSDictionary
        }
        DispatchQueue.main.async {
        cell.configureCell(dictValues: dictValues)
        cell.setNeedsDisplay()
            }
        
        }
        else
        {
            refreshControl.endRefreshing()
            self.callIntertnetView()
            //self.internetConnection()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            var dicSelected : NSDictionary!
            if(isFiltered)
            {
                dicSelected = self.arrayForSearchFiles.object(at: indexPath.row) as! NSDictionary
            }
            else
            {
                dicSelected = self.schoolListArray.object(at: indexPath.row) as! NSDictionary
            }
            let groupInfo = self.storyboard?.instantiateViewController(withIdentifier: "GroupInfoViewController") as! GroupInfoViewController
            commonAppDelegate.school_id = (dicSelected.value(forKey: "school_id") as! NSString).integerValue
            //let Dic = ["Schoolname" : (dicSelected.value(forKey: "school_name") as! String)]
            commonAppDelegate.SchoolDict.add(dicSelected)
            self.navigationController?.pushViewController(groupInfo, animated: true)
            Analytics.logEvent("Ukeplaner", parameters: ["School_name" : "\((dicSelected.value(forKey: "school_name")! as! NSString))" as NSObject , "School_ID" :"\((dicSelected.value(forKey: "school_id")! as! NSString))" as NSObject , "Description" : "\((dicSelected.value(forKey: "school_name")! as! NSString)) is selected"])
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
    //Loss internet connection
    func internetConnection()
    {
        //Utilities.showAlert("Please check your internet connection!")
        tbl_schoolList.isUserInteractionEnabled = false
        self.noSchoolInfo.isHidden = true
        schoolListArray.removeAllObjects()
        self.loadInitialData()
        //tbl_schoolList.reloadData()
        //self.refreshButton.isHidden = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

