//
//  MondayViewController.swift
//  test
//
//  Created by Lakeba_26 on 01/09/17.
//  Copyright © 2017 lakeba. All rights reserved.
//

import UIKit
//import TabPageViewController
class MondayViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var Tbl_timetable: UITableView!
    var subjects:NSMutableArray?
    var subjDesc : NSMutableArray!
    
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var prevBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        commonAppDelegate = UIApplication.shared.delegate as! AppDelegate
        subjDesc = NSMutableArray()
        self.Tbl_timetable.tableFooterView = UIView()
        // Do any additional setup after loading the view.
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
    
    override func viewWillAppear(_ animated: Bool) {
        //load day waise Subjects and Description value
        let dicSubj = NSMutableArray()
        for subjectIems in subjects!
        {
            if(!dicSubj.contains(subjectIems))
            {
                dicSubj.add(subjectIems)
            }
        }
        //Load subject description without empty value
        for i in 0..<dicSubj.count
        {
            let dicValues = dicSubj.object(at: i) as! NSDictionary
            let desc = (dicValues.value(forKey: "description") as! String)
            if(desc != "")
            {
                subjDesc.add(dicSubj.object(at: i))
            }
        }
        print(subjDesc)
        self.EnableAction()
        self.Tbl_timetable.register(UINib.init(nibName: "WeekTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "weekTimeTable")
    }
    
    @IBAction func nextAction(_ sender: Any) {
        commonAppDelegate.week_id = commonAppDelegate.week_id + 1
        print("week_id \(commonAppDelegate.week_id!)")
          NotificationCenter.default.post(name: NSNotification.Name(rawValue:"reload_timetable"), object: self)
    }
    @IBAction func previousAction(_ sender: Any) {
        commonAppDelegate.week_id = commonAppDelegate.week_id - 1
        print("week_id \(commonAppDelegate.week_id!)")
          NotificationCenter.default.post(name: NSNotification.Name(rawValue:"reload_timetable"), object: self)
    }
    //MARK: - Tableview Delegate and Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjDesc.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : WeekTimeTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "weekTimeTable") as! WeekTimeTableViewCell
        let dictValues = self.subjDesc.object(at: indexPath.row) as! NSDictionary
        cell.subjectName.text = (dictValues.value(forKey: "subject_name") as! String)
        cell.subjectDesc.text = (dictValues.value(forKey: "description") as! String)
        cell.isUserInteractionEnabled = false
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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

