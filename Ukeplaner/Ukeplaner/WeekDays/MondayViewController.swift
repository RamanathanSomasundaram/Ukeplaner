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

    @IBOutlet var tbl_Height: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        commonAppDelegate = UIApplication.shared.delegate as! AppDelegate
        subjDesc = NSMutableArray()
        if(UIScreen.main.bounds.size.height == 812.0)
        {
            tbl_Height.constant = 190
        }
        else
        {
            tbl_Height.constant = 150
        }
        self.Tbl_timetable.tableFooterView = UIView()
        // Do any additional setup after loading the view.
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
            //let desc = (dicValues.value(forKey: "description") as! String)
           // if(desc != "")
            //{
                subjDesc.add(dicValues)
           // }
        }
        self.Tbl_timetable.register(UINib.init(nibName: "WeekTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "weekTimeTable")
    }

    //MARK: - Tableview Delegate and Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjDesc.count
    }
    //Make card view on cell View
    func makeCardView (_ cell : UIView)
    {
        cell.layer.cornerRadius = 8
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : WeekTimeTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "weekTimeTable") as! WeekTimeTableViewCell
        let viewCell = cell.viewWithTag(610)!
        self.makeCardView(viewCell)
        let dictValues = self.subjDesc.object(at: indexPath.row) as! NSDictionary
        cell.subjectName.text = (dictValues.value(forKey: "subject_name") as! String)
        cell.subjectName.layer.cornerRadius = 8
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

