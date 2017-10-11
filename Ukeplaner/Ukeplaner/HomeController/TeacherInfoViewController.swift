//
//  TeacherInfoViewController.swift
//  Ukeplaner
//
//  Created by Lakeba_26 on 13/09/17.
//  Copyright © 2017 lakeba. All rights reserved.
//

import UIKit

class TeacherInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate {
    @IBOutlet var webTableView: UITableView!
    var refreshControl : UIRefreshControl!
    var school_id : Int!
    var group_id : Int!
    var teacherInfoArray : NSMutableArray!
    var tbl_height : CGFloat!
    var contentHeights : [CGFloat] = [0.0, 0.0]
    override func viewDidLoad() {
        super.viewDidLoad()
        commonAppDelegate = UIApplication.shared.delegate as! AppDelegate
        school_id = commonAppDelegate.school_id
        group_id = commonAppDelegate.group_id
        teacherInfoArray = NSMutableArray()
        self.webTableView.register(UINib.init(nibName: "WebViewTableViewCell", bundle: nil), forCellReuseIdentifier: "WebViewCell")
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        webTableView.addSubview(refreshControl)
        tbl_height = 50
        self.loadNavigationItem()
        self.loadInitialData()
        self.webTableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    @objc func refreshTableView()
    {
        self.webTableView.reloadData()
        refreshControl.endRefreshing()
    }
    func loadNavigationItem()
    {
        //Navigation BackButton hide
        self.title = "Week TimeTable"
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
        //schoolWeekList.removeAllObjects()
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadInitialData()
    {
        if(Utilities.checkForInternet())
        {
//            self.weekCollectionView.isUserInteractionEnabled = true
//            self.refreshButton.isHidden = true
            Utilities.showLoading()
            Alamofire.request("\(CommonAPI)Informasjonstavla?schoolid=\(school_id!)&group_id=\(group_id!)").responseJSON { response in
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
                            self.teacherInfoArray.add(jsonResponse[i])
                        }
                        //self.webTableView.reloadData()
                    }
                    else
                    {
                        let jsonError = (json as AnyObject).value(forKey: "ErrorMessage")!
                       // self.noWeekLabel.isHidden = false
                        print(jsonError)
                    }
                    DispatchQueue.main.async {
                        self.webTableView.reloadData()
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
       // self.weekCollectionView.isUserInteractionEnabled = false
        Utilities.showAlert("Please check your internet connection!")
//        schoolWeekList.removeAllObjects()
//        weekCollectionView.reloadData()
//        refreshButton.isHidden = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    //MARK: - TableView Datasource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teacherInfoArray.count
    }
    //Make card view on cell View
    func makeCardView (_ cell : UIView)
    {
        cell.layer.cornerRadius = 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : WebViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WebViewCell") as! WebViewTableViewCell
        let htmlHeight = contentHeights[indexPath.row]
        let dicValue = self.teacherInfoArray.object(at: indexPath.row) as! NSDictionary
        let teacher_name = (dicValue.value(forKey: "Teacher Name")! as! String)
        let message = (dicValue.value(forKey: "message")! as! String)
        let image_string = (dicValue.value(forKey: "Image")! as! String)
        cell.webViewContent.tag  = indexPath.row
        if(image_string != "")
        {
            
            cell.webViewContent.loadHTMLString("<html><body>\(message)</body></html>", baseURL: nil)
        }
        else
        {
            cell.webViewContent.loadHTMLString("<html><body>\(message)</body></html>", baseURL: nil)
        }
        cell.teacherName.text = teacher_name
        cell.webViewContent.delegate = self
        cell.webViewContent.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: htmlHeight)
        cell.webViewContent.scrollView.bounces = false
        cell.webViewContent.scrollView.showsVerticalScrollIndicator = false
        cell.contentSize.constant = tbl_height
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return contentHeights[indexPath.row]
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if (contentHeights[webView.tag] != 0.0)
        {
            // we already know height, no need to reload cell
            return
        }
        contentHeights[webView.tag] = webView.scrollView.contentSize.height + 20
        webTableView.reloadRows(at: [NSIndexPath(row: webView.tag, section: 0) as IndexPath] , with: .automatic)
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
