//
//  weekdayViewController.swift
//  Ukeplaner
//
//  Created by Lakeba_26 on 14/08/17.
//  Copyright © 2017 lakeba. All rights reserved.
//

import UIKit

class weekdayViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet var weekCollectionView: UICollectionView!
    var collectionViewFlowLayout : UICollectionViewFlowLayout!
    var refreshControl : UIRefreshControl!
    @IBOutlet var noWeekLabel: UILabel!
    @IBOutlet var refreshButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBarCustomButton()
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        weekCollectionView.addSubview(refreshControl)
        // Do any additional setup after loading the view.
    }
    func navigationBarCustomButton()
    {
        //Navigation BackButton hide
        self.title = "Week List"
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = ThemeColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_back-40.png"), style: .plain, target: self, action: #selector(backHome))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
        weekCollectionView.backgroundColor = UIColor.lightGray
        collectionViewFlowLayout = UICollectionViewFlowLayout()
        let size1 = (self.view.frame.size.width - 4 ) / 1
        collectionViewFlowLayout.itemSize = CGSize(width: size1, height: 80)
        collectionViewFlowLayout.minimumLineSpacing = 1
        collectionViewFlowLayout.minimumInteritemSpacing = 1
        collectionViewFlowLayout.scrollDirection = .vertical
        self.weekCollectionView.collectionViewLayout = collectionViewFlowLayout
    }
    //Navigation controller custom back button action
    func backHome()
    {
        self.navigationController?.popViewController(animated: true)
    }
    func refreshTableView()
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
            Utilities.showLoading()
            let url = URL(string: "http://ukeplaner.com/api/GroupRoules?schoolid=\(0)")
            DispatchQueue.main.async {
                let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                    guard error == nil else {
                        print(error!)
                        Utilities.hideLoading()
                        Utilities.showAlert("\(error!)")
                        return
                    }
                    guard let data = data else {
                        print("Data is empty")
                        Utilities.hideLoading()
                        self.noWeekLabel.isHidden = false
                        return
                    }
                    let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [Any]
//                    for i in 0..<json.count
//                    {
//                        self.schoolRulesList.add(json[i])
//                    }
                    DispatchQueue.main.sync {
                        self.weekCollectionView.reloadData()
                        Utilities.hideLoading()
                    }
                }
                task.resume()
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
        Utilities.showAlert("Please check your internet connection!")
       // schoolRulesList.removeAllObjects()
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
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
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
        infoTitle.textColor = UIColor(red: 255.0 / 255.0, green: 165.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
        infoTitle.text = "34"
        let infoweekTitle : UILabel = (cell?.viewWithTag(700) as! UILabel)
        infoweekTitle.textColor = TextColor //255,165
        infoweekTitle.text = "31-12-2107 til 31-12-2017"
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let weekTime = self.storyboard?.instantiateViewController(withIdentifier: "WeekTimeTableViewController") as! WeekTimeTableViewController
        self.navigationController?.pushViewController(weekTime, animated: true)
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
