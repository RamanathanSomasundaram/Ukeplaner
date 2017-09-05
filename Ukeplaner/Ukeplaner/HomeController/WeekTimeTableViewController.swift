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
    
    override func viewDidLoad() {
        let tc = TabPageViewController.create()
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.red
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.blue
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor(red: 149/255, green: 218/255, blue: 252/255, alpha: 1.0)
        let vc4 = UIViewController()
        vc4.view.backgroundColor = UIColor(red: 149/255, green: 252/255, blue: 197/255, alpha: 1.0)
        let vc5 = UIViewController()
        vc5.view.backgroundColor = UIColor(red: 252/255, green: 182/255, blue: 106/255, alpha: 1.0)
        tc.tabItems = [(vc1, "Monday\n22-7-2017"), (vc2, "Tuesday\n23-7-2017"), (vc3, "Wednesday 27-3-2017"), (vc4, "Thursday 28-7-2017"), (vc5, "Friday 30-8-2017")]
        //tc.isInfinity = true
        var option = TabPageOption()
        option.tabBackgroundColor = UIColor.green
        option.tabHeight = 50.0
        option.currentColor = UIColor.white
        option.tabMargin = 50.0
        tc.option = option
        self.addChildViewController(tc)
        self.view.insertSubview(tc.view, at: 0) // Insert the page controller view below the navigation buttons
        tc.didMove(toParentViewController: self)
        self.navigationBarCustomButton()
    }
    
    func navigationBarCustomButton()
    {
        //Navigation BackButton hide
        self.title = "Week TimeTable"
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = ThemeColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_back-40.png"), style: .plain, target: self, action: #selector(backHome))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
    }
    //Navigation controller custom back button action
    func backHome()
    {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
