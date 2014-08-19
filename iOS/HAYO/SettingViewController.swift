//
//  SettingViewController.swift
//  HAYO
//
//  Created by mono on 8/19/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
class SettingViewController: UITableViewController {
    
    class func create() -> UINavigationController {
        let sb = UIStoryboard(name: "Setting", bundle: nil)
        let navVC = sb.instantiateInitialViewController() as UINavigationController
        return navVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureBackgroundTheme()
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        if indexPath.row == 3 {
            let accountVc = AccountSettingViewController.create()
            self.navigationController.pushViewController(accountVc, animated: true)
            return
        }
        
        notImplemented()
    }
    @IBAction func doneDidTap(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true) {}
    }
}
