//
//  ProfileViewController.swift
//  Sheep
//
//  Created by mono on 8/3/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation

class ProfileViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var unregisterButton: UIButton!
    
    class func create() -> UINavigationController {
        let sb = UIStoryboard(name: "Profile", bundle: nil)
        let navVC = sb.instantiateInitialViewController() as UINavigationController
        return navVC
    }
    @IBAction func closeDidTap(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    @IBAction func logoutDidTap(sender: UIButton) {
        Account.deleteInstance()
        self.appDelegate().navigate()
    }
    
    @IBAction func unregisterDidTap(sender: UIButton) {
        
        let actionSheet = UIActionSheet.bk_actionSheetWithTitle(localize("ConfirmUnregister")) as UIActionSheet
        actionSheet.bk_setDestructiveButtonWithTitle(localize("Ok")) {
        Account.unregister() {
            self.appDelegate().navigate()
        }
        }
        actionSheet.bk_setCancelButtonWithTitle(localize("Cancel")) {
            
        }
        actionSheet.showInView(self.view.window)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureBackgroundTheme()
        self.designButton(logoutButton)
        self.designButton(unregisterButton)
        imageView.configureAsMyCircle()
        
        let account = Account.instance()
        imageView.image = account.image
        nameLabel.text = account.nickname
    }
}