//
//  SearchFriendsViewController.swift
//  Sheep
//
//  Created by mono on 8/1/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
class SearchFriendsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Account.searchFacebookFriends()
    }
}