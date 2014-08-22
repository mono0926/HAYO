//
//  AccountSettingViewController.swift
//  HAYO
//
//  Created by mono on 8/19/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
class AccountSettingViewController: UITableViewController {
    class func create() -> AccountSettingViewController {
        let sb = UIStoryboard(name: "AccountSetting", bundle: nil)
        let navVC = sb.instantiateInitialViewController() as AccountSettingViewController
        return navVC
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureBackgroundTheme()
        self.title = localize("AccountSetting")
        self.usernameLabel.text = Account.instance().username
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareDidTap")
        
        if self.navigationController.viewControllers[0] as UIViewController == self {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismiss")
        }
    }
    
    func shareDidTap() {
        self.shareMyId()
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true) {}
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            notImplemented()
        case (0, 1):
            notImplemented()
        case (1, 0):
            self.showActionSheet(localize("ConfirmUnregister"), destructiveTitleAction: TitleAction(title: localize("DoUnregister"), action: {
                Account.unregister() {
                    self.appDelegate().navigate()
                }
            }))
        default:
            assert(false)
            break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView! {
        return UIView()
    }
    
    override func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
}