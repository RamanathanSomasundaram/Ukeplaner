//
//  weekdayViewController.swift
//  Ukeplaner
//
//  Created by Lakeba_26 on 14/08/17.
//  Copyright © 2017 lakeba. All rights reserved.
//

import UIKit
import Firebase
let date = Date()
let calendar = Calendar.current
let weekOfYear = calendar.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
let weekOfDay = calendar.dateComponents([.year, .month, .day], from: date)
let WeekOfDate = "\(weekOfDay.day!)-\(weekOfDay.month!)-\(weekOfDay.year!)"
class weekdayViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet var weekCollectionView: UICollectionView!
    var collectionViewFlowLayout : UICollectionViewFlowLayout!
    var refreshControl : UIRefreshControl!
    @IBOutlet var noWeekLabel: UILabel!
    @IBOutlet var refreshButton: UIButton!
    var school_id : Int!
    var group_id : Int!
    var schoolWeekList : NSMutableArray!
    var currentWeekIndex : Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBarCustomButton()
        commonAppDelegate = UIApplication.shared.delegate as! AppDelegate
        school_id = commonAppDelegate.school_id
        group_id = commonAppDelegate.group_id
        schoolWeekList = NSMutableArray()
        self.loadInitialData()
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        weekCollectionView.addSubview(refreshControl)
        // Do any additional setup after loading the view.
    }
    func navigationBarCustomButton()
    {
        //Navigation BackButton hide
        self.title = "Uker"
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = ThemeColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_back-40.png"), style: .plain, target: self, action: #selector(backHome))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
//        let flipRightButton = UIBarButtonItem.init(image: UIImage.init(named: "slidemenu.png"), style: .plain, target: self, action: #selector(teacherInfo))
//        flipRightButton.tintColor = UIColor.white
//        self.navigationItem.rightBarButtonItem = flipRightButton
        weekCollectionView.backgroundColor = UIColor.lightGray
        collectionViewFlowLayout = UICollectionViewFlowLayout()
        var size1 : CGFloat!
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
        {
            size1 = (self.view.frame.size.width - 4 ) / 2
        }
        else
        {
            size1 = (self.view.frame.size.width - 4 ) / 0.95
            
        }
        collectionViewFlowLayout.itemSize = CGSize(width: size1, height: 80)
        collectionViewFlowLayout.minimumLineSpacing = 1
        collectionViewFlowLayout.minimumInteritemSpacing = 1
        collectionViewFlowLayout.scrollDirection = .vertical
        self.weekCollectionView.collectionViewLayout = collectionViewFlowLayout
    }
    //Navigation controller custom back button action
    @objc func backHome()
    {
        //schoolWeekList.removeAllObjects()
        self.navigationController?.popViewController(animated: true)
    }
    @objc func teacherInfo()
    {
        let teacherInfo = self.storyboard?.instantiateViewController(withIdentifier: "TeacherInfoViewController") as! TeacherInfoViewController
        self.navigationController?.pushViewController(teacherInfo, animated: true)
    }
    @objc func refreshTableView()
    {
        self.weekCollectionView.reloadData()
        refreshControl.endRefreshing()
    }
    func loadInitialData()
    {
        if(Utilities.checkForInternet())
        {
            self.weekCollectionView.isUserInteractionEnabled = true
            self.refreshButton.isHidden = true
            self.noWeekLabel.isHidden = true
            Utilities.showLoading()
            Alamofire.request("\(CommonAPI)weekList?schoolid=\(school_id!)&group_id=\(group_id!)").responseJSON { response in
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
                        for i in 0..<self.schoolWeekList.count
                        {
                            let dicValues = self.schoolWeekList.object(at: i) as! NSDictionary
                            if((dicValues.value(forKey: "week_no") as! NSString).integerValue == weekOfYear)
                            {
                                self.currentWeekIndex = i
                            }
                        }
                    }
                    else
                    {
                        let jsonError = (json as AnyObject).value(forKey: "ErrorMessage")!
                        self.noWeekLabel.isHidden = false
                        self.noWeekLabel.text = (jsonError as! String)
                        print(jsonError)
                    }
                    DispatchQueue.main.async {
                        self.weekCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerSection")
                        self.collectionViewFlowLayout.headerReferenceSize = CGSize(width: 100, height: 40)
                        self.weekCollectionView.reloadData()
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
        self.weekCollectionView.isUserInteractionEnabled = false
        self.noWeekLabel.isHidden = true
        Utilities.showAlert("Please check your internet connection!")
        schoolWeekList.removeAllObjects()
        weekCollectionView.reloadData()
        refreshButton.isHidden = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @IBAction func refershAction(_ sender: Any) {
        self.loadInitialData()
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
    //MARK: - Collection view datasource and delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if(section == 0)
        {
            if(schoolWeekList.count == 0)
            {
                return 0
            }
            else
            {
            return 1
            }
        }
        else
        {
        return schoolWeekList.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerSection", for: indexPath)
        let label = (header.viewWithTag(510) as? UILabel)
        if(indexPath.section == 0)
        {
            label?.text = "Current Week"
        }
        else
        {
            label?.text = "Other weeks"
        }
        return header
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "weekcell", for: indexPath)
        if cell == nil {
            // print("empty value")
        }
        
        let view = (cell?.viewWithTag(5000)!)
        self.makeCardView(view!)
        cell?.backgroundColor = UIColor.lightGray
        let infoTitle : UILabel = (cell?.viewWithTag(701) as! UILabel)
        let infoweekTitle : UILabel = (cell?.viewWithTag(700) as! UILabel)
        var dicValues : NSDictionary!
        if(indexPath.section == 0)
        {
         dicValues = schoolWeekList.object(at: currentWeekIndex) as! NSDictionary
        }
        else
        {
        dicValues = schoolWeekList.object(at: indexPath.row) as! NSDictionary
        }
        infoTitle.text = (dicValues.value(forKey: "week_no") as! String)
        infoweekTitle.textColor = TextColor //255,165
        infoweekTitle.text = (dicValues.value(forKey: "week_date") as! String)
        infoweekTitle.numberOfLines = 1
        infoweekTitle.adjustsFontSizeToFitWidth = true
        if((dicValues.value(forKey: "week_no") as! NSString).integerValue == weekOfYear)
        {
            infoTitle.textColor = UIColor(red: 92.0 / 255.0, green: 0.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
        }
        else
        {
            infoTitle.textColor = UIColor(red: 255.0 / 255.0, green: 165.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
        }
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var dicValues : NSDictionary!
        if(indexPath.section == 0)
        {
            dicValues = schoolWeekList.object(at: currentWeekIndex) as! NSDictionary
        }
        else
        {
            dicValues = schoolWeekList.object(at: indexPath.row) as! NSDictionary
        }
        commonAppDelegate.week_id = (dicValues.value(forKey: "week_id") as! NSString).integerValue
        commonAppDelegate.weekid_first = ((schoolWeekList.object(at: 0) as! NSDictionary).value(forKey: "week_id") as! NSString).integerValue
        commonAppDelegate.weekid_last = ((schoolWeekList.object(at: schoolWeekList.count - 1) as! NSDictionary).value(forKey: "week_id") as! NSString).integerValue
        let weekTime = self.storyboard?.instantiateViewController(withIdentifier: "WeekTimeTableViewController") as! WeekTimeTableViewController
        self.navigationController?.pushViewController(weekTime, animated: true)
        Analytics.logEvent("Ukeplaner", parameters: ["Week_ID" : "\((dicValues.value(forKey: "week_id")! as! NSString))" as NSObject , "Week_Date" :"\((dicValues.value(forKey: "week_date")! as! NSString))" as NSObject , "Description" : "This week \((dicValues.value(forKey: "week_date")! as! NSString)) home work list"])
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
