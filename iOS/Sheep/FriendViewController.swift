//
//  FriendViewController.swift
//  Sheep
//
//  Created by mono on 8/6/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
class FriendViewController: UITableViewController {
    
    var user: PFUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = user.nickname
    }
    @IBAction func closeDidTap(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    class func create() -> UINavigationController {
        let sb = UIStoryboard(name: "Friend", bundle: nil)
        let navVC = sb.instantiateInitialViewController() as UINavigationController
        return navVC
    }
}