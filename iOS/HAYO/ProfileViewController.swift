//
//  ProfileViewController.swift
//  Sheep
//
//  Created by mono on 8/3/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation

class ProfileViewController: UIViewController, UIActionSheetDelegate {
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
        
        let actionSheet = UIActionSheet(title: localize("ConfirmUnregister"), delegate: self, cancelButtonTitle: localize("Cancel"), destructiveButtonTitle: localize("Ok"))
        
        actionSheet.showInView(self.view.window)
        
    }
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == 0 {
            Account.unregister() {
                self.appDelegate().navigate()
            }
        }
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