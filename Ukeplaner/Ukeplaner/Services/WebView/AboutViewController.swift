//
//  AboutViewController.swift
//  Ukeplaner
//
//  Created by Lakeba_Adminstrator on 02/11/17.
//  Copyright © 2017 lakeba. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController,SWRevealViewControllerDelegate {

    @IBOutlet var myWebView: UIWebView!
    var URLString : String!
    var titleString : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        commonAppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.navigationBarCustomButton()
        self.revealViewController().delegate = self
        let url = URL (string: "http://inventuretechnology.com/overview.php")
        let requestObj = URLRequest(url: url!)
        myWebView.loadRequest(requestObj)
        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        MBProgressHUD.hideAllHUDs(for: commonAppDelegate.window, animated: true)
    }
    func navigationBarCustomButton()
    {
        //Navigation BackButton hide
        self.title = "Om oss"
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = ThemeColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_back-40.png"), style: .plain, target: self, action: #selector(backGroupinfo))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
    }
    @objc func backGroupinfo()
    {
        let slideMenu : SlideMenuList? = (self.revealViewController().rearViewController as? SlideMenuList)
        slideMenu?.tbl_schoolMenu.selectRow(at: [0,1], animated: true, scrollPosition: .top)
        slideMenu?.performSegue(withIdentifier: "groupinfo", sender: nil)
        //self.performSegue(withIdentifier: "groupinfo", sender: nil)
    }
    //Navigation controller custom back button action
    @objc func backHome()
    {
        self.navigationController?.popViewController(animated: true)
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        //print("load start")
        MBProgressHUD.showAdded(to: commonAppDelegate.window, animated: true)
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //print("Load completed")
        MBProgressHUD.hideAllHUDs(for: commonAppDelegate.window, animated: true)
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        MBProgressHUD.hideAllHUDs(for: commonAppDelegate.window, animated: true)
        webView.reload()
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
    
    //MARK: - Prepare for segue action
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue .isKind(of: SWRevealViewControllerSegue.self)){
            let swSegue = (segue as! SWRevealViewControllerSegue)
            swSegue.performBlock = {(_ rvc_segue: SWRevealViewControllerSegue?, _ svc: UIViewController?, _ dvc: UIViewController?) -> Void in
                let navController = (self.revealViewController().frontViewController as! UINavigationController)
                navController.setViewControllers([dvc!], animated: false)
                self.revealViewController().setFrontViewPosition(FrontViewPositionLeft, animated: true)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
