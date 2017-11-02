//
//  AboutViewController.swift
//  Ukeplaner
//
//  Created by Lakeba_Adminstrator on 02/11/17.
//  Copyright © 2017 lakeba. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet var myWebView: UIWebView!
    var URLString : String!
    var titleString : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        commonAppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.navigationBarCustomButton()
        let url = URL (string: "http://inventuretechnology.com/overview.php")
        let requestObj = URLRequest(url: url!)
        myWebView.loadRequest(requestObj)
        // Do any additional setup after loading the view.
    }
    
    func navigationBarCustomButton()
    {
        //Navigation BackButton hide
        self.title = "Inventure Technology"
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = ThemeColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "slidemenu.png"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
