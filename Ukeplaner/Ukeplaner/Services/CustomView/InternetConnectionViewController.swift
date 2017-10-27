//
//  InternetConnectionViewController.swift
//  Ukeplaner
//
//  Created by Lakeba_Adminstrator on 27/10/17.
//  Copyright © 2017 lakeba. All rights reserved.
//

import UIKit
protocol internetConnectionDelegate {
    func internetconnection()
}
class InternetConnectionViewController: UIViewController {
    var internetDelegate : internetConnectionDelegate?
    var rootVC : UIViewController!
    init(nibName nibNameOrNil: String, root parentViewController: UIViewController) {
        super.init(nibName: nibNameOrNil, bundle: nil)
        self.rootVC = parentViewController
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func retryAction(_ sender: Any) {
        rootVC.dismiss(animated: true, completion: nil)
        self.internetDelegate?.internetconnection()
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
