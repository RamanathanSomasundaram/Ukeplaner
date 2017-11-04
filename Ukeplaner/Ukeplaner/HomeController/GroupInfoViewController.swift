//
//  GroupInfoViewController.swift
//  Ukeplaner
//
//  Created by Lakeba_26 on 12/08/17.
//  Copyright © 2017 lakeba. All rights reserved.
//

import UIKit
import Firebase
class GroupInfoViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,internetConnectionDelegate,SWRevealViewControllerDelegate,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var collectionView: UICollectionView!
    var collectionviewFlowlayout : UICollectionViewFlowLayout!
    var schoolID : Int!
    var groupInfolist : NSMutableArray!
    @IBOutlet var refreshButton: UIButton!
    var refreshControl : UIRefreshControl!
    @IBOutlet var noGroupLabel: UILabel!
    @IBOutlet var SchoolName: UILabel!
    @IBOutlet var tbl_SchoolInfo: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonAppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.loadNavigationItem()
        self.title = "Klasser"
        //SchoolName.text = ((commonAppDelegate.SchoolDict.object(at: 0) as! NSDictionary).value(forKey: "Schoolname") as! String)
        //SchoolName.textColor = TextColor
        schoolID = commonAppDelegate.school_id
        //self.refreshButton.isHidden = true
        self.groupInfolist = NSMutableArray()
        self.revealViewController().delegate = self
        self.loadInitialData()
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.backgroundColor = UIColor.lightGray
        self.noGroupLabel.isHidden = true
        tbl_SchoolInfo.register(UINib.init(nibName: "SchoolTableViewCell", bundle: nil), forCellReuseIdentifier: "schoolCell")
        tbl_SchoolInfo.backgroundColor = UIColor.lightGray
        // Do any additional setup after loading the view.
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
    @objc func backHome()
    {
        commonAppDelegate.SchoolDict.removeAllObjects()
        self.navigationController?.popToRootViewController(animated: true)
    }
    @objc func refreshTableView()
    {
        self.collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    override func viewDidAppear(_ animated: Bool) {
        collectionviewFlowlayout = UICollectionViewFlowLayout()
        let size1 = (self.view.frame.size.width - 4 ) / 2
        collectionviewFlowlayout.itemSize = CGSize(width: size1, height: 50)
        collectionviewFlowlayout.minimumLineSpacing = 1
        collectionviewFlowlayout.minimumInteritemSpacing = 1
        collectionviewFlowlayout.scrollDirection = .vertical
        self.collectionView.collectionViewLayout = collectionviewFlowlayout
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        self.loadInitialData()
    }
    func loadInitialData()
    {
        if(Utilities.checkForInternet())
        {
            self.collectionView.isUserInteractionEnabled = true
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            //self.refreshButton.isHidden = true
            Utilities.showLoading()
            Alamofire.request("\(CommonAPI)groupList?schoolid=\(schoolID!)").responseJSON { response in
                let error = response.result.error
                if error != nil
                {
                    Utilities.hideLoading()
                    self.callIntertnetView()
                    return
                }
                if let json = response.result.value {
                    if ((json as AnyObject).isKind(of: NSArray.self))
                    {
                        let jsonResponse = (json as! [Any])
                        for i in 0..<jsonResponse.count
                        {
                            self.groupInfolist.add(jsonResponse[i])
                        }
                    }
                    else
                    {
                        let jsonError = (json as AnyObject).value(forKey: "ErrorMessage")!
                        self.noGroupLabel.isHidden = false
                        self.noGroupLabel.text = (jsonError as! String)
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
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
    //Loss internet connection
    func internetConnection()
    {
        self.collectionView.isUserInteractionEnabled = false
        self.noGroupLabel.isHidden = true
        //Utilities.showAlert("Please check your internet connection!")
        groupInfolist.removeAllObjects()
        self.loadInitialData()
        self.tbl_SchoolInfo.reloadData()
        //collectionView.reloadData()
        //refreshButton.isHidden = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }

    //MARK: - Tableview Datasource and Deleagate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    //MARK: - Collection view datasource and delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupInfolist.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath)
        let view = (cell?.viewWithTag(2001)!)
        Utilities.makeCardView(view!)
        cell?.backgroundColor = UIColor.lightGray
        let infoTitle : UILabel = (cell?.viewWithTag(500) as! UILabel)
        infoTitle.textColor = TextColor
        let dicLoad = groupInfolist.object(at: indexPath.row) as! NSDictionary
        infoTitle.text = (dicLoad.value(forKey: "group_name") as! String)
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dicLoad = groupInfolist.object(at: indexPath.row) as! NSDictionary
        commonAppDelegate.group_id = (dicLoad.value(forKey: "group_id") as! NSString).integerValue
        let dicGroup = ["Groupname" : (dicLoad.value(forKey: "group_name")! as! String)]
        commonAppDelegate.SchoolDict.add(dicGroup)
        let weekList = self.storyboard?.instantiateViewController(withIdentifier: "weekdayViewController") as! weekdayViewController
        self.navigationController?.pushViewController(weekList, animated: true)
         Analytics.logEvent("Ukeplaner", parameters: ["Group_name" : "\((dicLoad.value(forKey: "group_name")! as! NSString))" as NSObject , "Group_ID" :"\((dicLoad.value(forKey: "group_id")! as! NSString))" as NSObject , "Group_Description" : "\((dicLoad.value(forKey: "group_name")! as! NSString)) is selected to show weeklist"])
    }
    deinit {
        self.groupInfolist.removeAllObjects()
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
