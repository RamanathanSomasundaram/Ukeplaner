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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Tbl_timetable.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        print("data \(subjects!)")
        self.Tbl_timetable.register(UINib.init(nibName: "WeekTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "weekTimeTable")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (subjects?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : WeekTimeTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "weekTimeTable") as! WeekTimeTableViewCell
        let dictValues = self.subjects!.object(at: indexPath.row) as! NSDictionary
        cell.subjectName.text = (dictValues.value(forKey: "subject_name") as! String)
        cell.subjectDesc.text = (dictValues.value(forKey: "description") as! String)
        return cell
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

