//
//  ViewController.swift
//  Ukeplaner
//
//  Created by Lakeba_26 on 11/08/17.
//  Copyright © 2017 lakeba. All rights reserved.
//

import UIKit
import Foundation
let ThemeColor : UIColor = UIColor(red: 30.0/255.0, green: 34.0/255.0, blue: 39.0/255.0, alpha: 1.0)
let TextColor : UIColor = UIColor(red: 140.0/255.0, green: 198.0/255.0, blue: 62.0/255.0, alpha: 1.0)
class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshButton.isHidden = true
        self.noSchoolInfo.isHidden = true
        commonAppDelegate = UIApplication.shared.delegate as! AppDelegate
        schoolListArray = NSMutableArray()
        self.searchbarConstraint.constant = -40
        self.tbl_schoolList.tableFooterView = UIView()
        self.navigationBarItems()
        self.loadInitialData()
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = TextColor
        let attr = [NSForegroundColorAttributeName:UIColor.white]
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes:attr)
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tbl_schoolList.addSubview(refreshControl)
        // Do any additional setup after loading the view, typically from a nib. ic_school_search
    }
    func refreshTableView()
    {
        self.tbl_schoolList.reloadData()
        refreshControl.endRefreshing()

    }
    func navigationBarItems()
    {
        self.navigationController?.navigationBar.barTintColor = ThemeColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        commonAppDelegate.recordController = self
        let flipRightButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_school_search.png"), style: .plain, target: self, action: #selector(search))
        flipRightButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = flipRightButton
        let slideMenu : SlideMenuList? = (self.revealViewController().rearViewController as! SlideMenuList)
        slideMenu?.tbl_schoolMenu.selectRow(at: [0,1], animated: true, scrollPosition: .none)
        self.title = "SKOLER"
        isFiltered = false

    }
    func search()
    {
        searchbarConstraint.constant = 0
        tableviewConstraint.constant = 40
        searchBarController.showsCancelButton = true
        searchBarController.delegate = self
        searchBarController.returnKeyType = .search
    }
    //MARK: - user click on the search icon to search the items in the tables list
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBarController.resignFirstResponder()
        self.tbl_schoolList.reloadData()
        self.searchBarController.endEditing(true)
    }
    
    // user can change the text
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            searchBar.resignFirstResponder()
            searchBarController.resignFirstResponder()
            isFiltered = false
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
        searchBar.resignFirstResponder()
        searchBarController.resignFirstResponder()
        self.searchBarController.endEditing(true)
        searchBar.endEditing(true)
    }
    
    // Search bar cancel button clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //print("search cancel click")
        searchBar.resignFirstResponder()
        searchBarController.resignFirstResponder()
        searchBar.text = ""
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
        if(Utilities.checkForInternet())
        {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.refreshButton.isHidden = true
        Utilities.showLoading()
        let url = URL(string: "http://ukeplaner.com/api/schoolList")
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
                self.noSchoolInfo.isHidden = false
                return
            }
            let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [Any]
            for i in 0..<json.count
            {
            self.schoolListArray.add(json[i])
            }
            DispatchQueue.main.sync {
                self.tbl_schoolList.reloadData()
                let  dispatchTime = DispatchTime.now() +  .seconds(1)
                DispatchQueue.main.asyncAfter(deadline: dispatchTime , execute: {
                    Utilities.hideLoading()
                })
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: "schoolCell") as? SchoolTableViewCell
        if(cell == nil)
        {
            //Load the top-level objects from the custom cell XIB.
            var topLevelObjects = Bundle.main.loadNibNamed("SchoolTableViewCell", owner: self, options: nil)
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = topLevelObjects?[0] as! SchoolTableViewCell?
        }
        if(Utilities.checkForInternet())
        {
        let view : UIView = (cell?.viewWithTag(2000))!
        self.makeCardView(view)
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        cell?.separatorInset = .zero
            var dictValues : NSDictionary!
            var image : UIImage!

        if(isFiltered)
        {
            dictValues = self.arrayForSearchFiles.object(at: indexPath.row) as! NSDictionary
            for subview: UIView in (cell?.contentView.subviews)!{
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
       if(self.checkImageUrl(imageUrl: (dictValues.value(forKey: "school_logo") as! String)))
       {
        if(Utilities.checkForInternet())
        {
            do
            {
                let imageData = try Data.init(contentsOf: URL(string: (dictValues.value(forKey: "school_logo") as! String))!)
                image = UIImage.init(data: imageData)
            }
            catch
            {
                print(error.localizedDescription)
            }
        
        }
        else
        {
            self.internetConnection()
        }
       }
        else
       {
        image = UIImage(named: "sampleImage.png")
        }
        cell?.schoolLogo.image = image
        cell?.schoolName.text = (dictValues.value(forKey: "school_name") as! String)
        cell?.schoolEmailID.text = (dictValues.value(forKey: "school_email") as! String)
        cell?.schoolPhoneNo.text = (dictValues.value(forKey: "phone_number") as! String)
        cell?.setNeedsDisplay()
            }
        
        }
        else
        {
            self.internetConnection()
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(Utilities.checkForInternet())
        {
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
            //groupInfo.schoolID = (dicSelected.value(forKey: "school_id") as! NSString).integerValue
            commonAppDelegate.school_id = (dicSelected.value(forKey: "school_id") as! NSString).integerValue
            self.navigationController?.pushViewController(groupInfo, animated: true)
        }
        else
        {
            self.internetConnection()
        }
    }
    //Loss internet connection
    func internetConnection()
    {
        Utilities.showAlert("Please check your internet connection!")
        schoolListArray.removeAllObjects()
        tbl_schoolList.reloadData()
        self.refreshButton.isHidden = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    //Check image URL
    func checkImageUrl (imageUrl : String) -> Bool
    {
        var success : Bool = false
        let urlString = (imageUrl as NSString).lastPathComponent
        if(urlString != "school")
        {
            if (urlString != "0")
            {
            success = true
            }
        }
        else
        {
        success = false
        }
        return success
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

