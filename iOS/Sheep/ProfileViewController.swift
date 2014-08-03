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
    class func create() -> UINavigationController {
        let sb = UIStoryboard(name: "Profile", bundle: nil)
        return sb.instantiateInitialViewController() as UINavigationController
    }
    @IBAction func closeDidTap(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    @IBAction func logoutDidTap(sender: UIButton) {
        Account.deleteInstance()
        self.appDelegate().navigate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureBackgroundTheme()
        self.designButton(logoutButton)
        imageView.configureAsMyCircle()
        
        let account = Account.instance()
        imageView.image = account.image
        nameLabel.text = account.nickname
    }
}