//
//  HayoListViewController.swift
//  Sheep
//
//  Created by mono on 8/3/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
class HayoListViewController: UITableViewController {
    class func create() -> UINavigationController {
        let sb = UIStoryboard(name: "HayoList", bundle: nil)
        return sb.instantiateInitialViewController() as UINavigationController
    }
    @IBAction func closeDidTap(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
}