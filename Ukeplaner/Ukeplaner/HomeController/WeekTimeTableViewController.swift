//
//  WeekTimeTableViewController.swift
//  Ukeplaner
//
//  Created by Lakeba_26 on 14/08/17.
//  Copyright © 2017 lakeba. All rights reserved.
//

import UIKit
import TabPageViewController
class WeekTimeTableViewController: UIViewController{
    var dicvalue = NSMutableDictionary()
    let daysArray = NSMutableArray()
    var school_id : Int!
    var group_id : Int!
    var week_id : Int!
    var week_no : Int!
    var tc : TabPageViewController!
    @IBOutlet var prevBtn: UIButton!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var noHomeLabel: UILabel!
    @IBOutlet var refreshButton: UIButton!
    var currentIndex : Int!
    
    @IBOutlet var schoolInfo: UILabel!
    override func viewDidLoad() {
        commonAppDelegate = UIApplication.shared.delegate as! AppDelegate
        //Custom navigation controller
        self.navigationBarCustomButton()
        //load API access
        self.loadweekTimeTable()
        schoolInfo.text = Utilities.weekno_list(week_id: commonAppDelegate.currentWeek_id)
            NotificationCenter.default.addObserver(self, selector: #selector(loadweekTimeTable), name: NSNotification.Name(rawValue:"reload_timetable"), object: nil)
    }
    
    //Load navigation controller custom buttons
    func navigationBarCustomButton()
    {
        //Navigation BackButton hide
        self.title = "Ukeplan.com"
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = ThemeColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_back-40.png"), style: .plain, target: self, action: #selector(backHome))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
    }
    //Navigation controller custom back button action
    @objc func backHome()
    {
        self.navigationController?.popViewController(animated: true)
    }
    func EnableAction()
    {
        if(commonAppDelegate.weekid_first == commonAppDelegate.week_id)
        {
            prevBtn.isEnabled = false
            prevBtn.backgroundColor = UIColor.lightGray
            nextBtn.isEnabled = true
        }
        else if (commonAppDelegate.weekid_last == commonAppDelegate.week_id)
        {
            prevBtn.isEnabled = true
            nextBtn.isEnabled = false
            nextBtn.backgroundColor = UIColor.lightGray
        }
        else
        {
            prevBtn.isEnabled = true
            prevBtn.backgroundColor = UIColor(red: 0.0 / 255.0, green: 103.0 / 255.0, blue: 56.0 / 255.0, alpha: 1.0)
            nextBtn.isEnabled = true
            nextBtn.backgroundColor = UIColor(red: 0.0 / 255.0, green: 103.0 / 255.0, blue: 56.0 / 255.0, alpha: 1.0)
        }
    }
    @IBAction func previousAction(_ sender: Any) {
        commonAppDelegate.week_id = commonAppDelegate.week_id - 1
        commonAppDelegate.currentWeek_id = commonAppDelegate.currentWeek_id - 1
        schoolInfo.text = Utilities.weekno_list(week_id: commonAppDelegate.currentWeek_id)
       // print("week_id \(commonAppDelegate.week_id!)")
        self.loadweekTimeTable()
    }
    
    @IBAction func nextAction(_ sender: Any) {

        commonAppDelegate.week_id = commonAppDelegate.week_id + 1
        commonAppDelegate.currentWeek_id = commonAppDelegate.currentWeek_id + 1
        schoolInfo.text = Utilities.weekno_list(week_id: commonAppDelegate.currentWeek_id)
        //print("week_id \(commonAppDelegate.week_id!)")
        self.loadweekTimeTable()
    }
    
    //Load Week Time table API service to get value
    @objc func loadweekTimeTable()
    {
        if(Utilities.checkForInternet())
        {
            self.refreshButton.isHidden = true
        self.noHomeLabel.isHidden = true
        if(dicvalue.count > 0 && daysArray.count > 0)
        {
            tc.view.removeFromSuperview()
            dicvalue.removeAllObjects()
            daysArray.removeAllObjects()
        }
        self.EnableAction()
        school_id = commonAppDelegate.school_id!
        group_id = commonAppDelegate.group_id!
        week_id = commonAppDelegate.week_id!
        Utilities.showLoading()
        Alamofire.request("\(CommonAPI)weekplanner?schoolid=\(school_id!)&group_id=\(group_id!)&week_id=\(week_id!)").responseJSON { response in
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
                    let jsondic = (json as! [Any])
                    //Take subject wise add dictionary
                    for jsonresponse in jsondic
                    {
                        let key = (jsonresponse as AnyObject).value(forKey: "week_day") as! String
                        if(self.dicvalue.value(forKey: key) != nil)
                        {
                            let dicArray = self.dicvalue.value(forKey: key) as! NSMutableArray
                            dicArray.add(jsonresponse)
                            self.dicvalue.setValue(dicArray, forKey: key)
                        }
                        else
                        {
                            let dicArray = NSMutableArray()
                            dicArray.add(jsonresponse)
                            self.dicvalue.setValue(dicArray, forKey: key)
                        }
                    }
                   // print("DicValue : \(self.dicvalue)")
                    //Take date and day in dictionary
                    let mutArray = NSMutableArray()
                    for i in 0..<jsondic.count
                    {
                        let dicvalues = jsondic[i] as! NSDictionary
                        let week_days = dicvalues.value(forKey: "week_day") as! String
                        let week_date = dicvalues.value(forKey: "week_date") as! String
                        mutArray.add(["Week_day" : week_days, "Week_date" : week_date])
                    }
                    for obj in mutArray
                    {
                        if(!self.daysArray.contains(obj))
                        {
                            self.daysArray.add(obj)
                        }
                    }
                    Utilities.hideLoading()
                    self.noHomeLabel.isHidden = true
                    self.loadPageViewController()
                }
                else
                {
                    let jsonError = (json as AnyObject).value(forKey: "ErrorMessage")!
                    self.noHomeLabel.isHidden = false
                    self.noHomeLabel.text = (jsonError as! String)
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
        self.noHomeLabel.isHidden = true
        Utilities.showAlert("Please check your internet connection!")
        daysArray.removeAllObjects()
        dicvalue.removeAllObjects()
        refreshButton.isHidden = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @IBAction func RefreshAction(_ sender: Any) {
        self.loadweekTimeTable()
    }
    
    //Load page view controller - Tabpageviewcontroller class
    func loadPageViewController()
    {
        tc = TabPageViewController.create()
        //let commonArray = NSMutableArray()
        var tabItems:[(viewController: UIViewController, title: String)] = []
        for i in 0..<self.daysArray.count
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MondayViewController") as! MondayViewController
            let days = self.daysArray.object(at: i) as! NSDictionary
            let week_date = days.value(forKey: "Week_date") as! String
            let week_day = days.value(forKey: "Week_day") as! String
            if(WeekOfDate == week_date)
            {
                currentIndex = i
            }
            tabItems.append((viewController: vc, title: "\(week_day)\n\(week_date)"))
            vc.subjects = dicvalue.value(forKey: week_day) as? NSMutableArray
        }
        
        tc.tabItems = tabItems
        var option = TabPageOption()
        option.tabBackgroundColor = TextColor
        option.tabHeight = 50.0
        option.currentColor = UIColor.white
        option.tabMargin = 50.0
        tc.option = option
        if(currentIndex != nil)
        {
            tc.displayControllerWithIndex(currentIndex!, direction: .forward, animated: false)
        }
        
        self.addChildViewController(tc)
        self.view.insertSubview(tc.view, at: 0) // Insert the page controller view below the navigation buttons
        tc.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
