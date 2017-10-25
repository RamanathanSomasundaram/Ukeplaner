//
//  Utilities.swift
//  MusixxiRecorder
//
//  Created by Lakeba-026 on 06/12/16.
//  Copyright © 2016 Lakeba Corporation Pty Ltd. All rights reserved.
//

import UIKit
import SystemConfiguration
var commonAppDelegate : AppDelegate!
//macros
extension UIColor {
    convenience init(netHex:Int) {
        self.init(red: CGFloat((Float((netHex & 0xFF0000) >> 16)) / 255.0), green: CGFloat((Float((netHex & 0xFF00) >> 8)) / 255.0), blue: CGFloat((Float(netHex & 0xFF)) / 255.0), alpha: CGFloat(1.0))
    }
}
let CommonAPI = "http://ukeplaner.com/api/"
class Utilities: NSObject {
    
    
    //singleton Instance
    class func sharedInstance() -> Utilities {
        var UtilitiesClass: Utilities? = nil
        if(UtilitiesClass != nil)
        {
            UtilitiesClass = Utilities()
        }
        return UtilitiesClass!
    }
    
    //MARK: - Show alert
    //show an alert
    class func showAlert(_ alertMessage: String) {
        let alert = UIAlertController(title: "Ukeplaner", message: alertMessage, preferredStyle: .alert)
        let alertCancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(alertCancel)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    //MARK: - Loading, Hiding progress view
    //show Loading
    class func showLoading() {
        //let window = UIApplication.shared.windows.last! as UIWindow
        _ = MBProgressHUD.showAdded(to: commonAppDelegate.window, animated: true)
   //     hud?.isUserInteractionEnabled = false
        UIApplication.shared.beginIgnoringInteractionEvents()
//        hud?.labelText = "Loading ..."
//        hud?.labelColor = UIColor(netHex: 0x878787)
//        hud?.color = UIColor(netHex: 0xC3C3C3)
        //return hud!
    }
    
    class func showLoading(_ message: String) {
        //let window = UIApplication.shared.windows.last! as UIWindow
        _ = MBProgressHUD.showAdded(to: commonAppDelegate.window, animated: true)
        UIApplication.shared.beginIgnoringInteractionEvents()
//        hud?.labelText = message
//        hud?.labelColor = UIColor(netHex: 0x878787)
//        hud?.color = UIColor(netHex: 0xC3C3C3)
    }
    //To hide the loading
    class func hideLoading() {
        //let window = UIApplication.shared.windows.last! as UIWindow
        UIApplication.shared.endIgnoringInteractionEvents()
        MBProgressHUD.hide(for: commonAppDelegate.window, animated: true)
    }
    
    class func hideAllLoading()
    {
        UIApplication.shared.endIgnoringInteractionEvents()
        MBProgressHUD.hideAllHUDs(for: commonAppDelegate.window, animated: true)
    }

    
    //MARK: - Check Internet Connection
    //Checking the internet connection
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
    
    class func checkForInternet() -> Bool {
        
        if self.isConnectedToNetwork() == true
        {
           // print("Internet Connection Available!")
            return true
        }
        else
        {
            //print("Internet Connection not Available!")
            return false
        }
        
    }
    
    class func weekno_list(week_id : Int) -> String
    {
        let week_id_String = "\((commonAppDelegate.SchoolDict.object(at: 0) as! NSDictionary).value(forKey: "school_name") as! String)" + " - Ukeplan for \(((commonAppDelegate.SchoolDict.object(at: 1) as! NSDictionary).value(forKey: "Groupname") as! String))" + " - Uke \((commonAppDelegate.weekNoArray.object(at: week_id)as! String))"
        return week_id_String
    }
    //Check the Battery level
    class func checkBattertLevel() -> Bool {
        #if (TARGET_IPHONE_SIMULATOR)
            UIDevice.current.isBatteryMonitoringEnabled = true
            var batteryLevel = UIDevice.current.batteryLevel
            batteryLevel *= 100
            //change the minimum battery level
            if(batteryLevel > 3)
            {
                return true
            }
            else
            {
                self.showAlert("You need to have atleast 4% of battery to start recording!")
                return false
            }
        #else
            return true
        #endif
        
    }
   
}

