//
//  schoolLinksViewController.swift
//  Ukeplaner
//
//  Created by Lakeba_26 on 12/08/17.
//  Copyright © 2017 lakeba. All rights reserved.
//

import UIKit

class schoolLinksViewController: UIViewController {
    var schoolLinksList : NSMutableArray!
    var school_id : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonAppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.title = "lenker"
        self.loadNavigationItem()
        school_id = commonAppDelegate.school_id
        schoolLinksList = NSMutableArray()
        // Do any additional setup after loading the view, typically from a nib. ic_school_search
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
    //Loss internet connection
    func internetConnection()
    {
        Utilities.showAlert("Please check your internet connection!")
        schoolLinksList.removeAllObjects()
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
