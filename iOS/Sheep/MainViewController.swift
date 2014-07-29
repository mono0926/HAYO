//
//  ViewController.swift
//  Sheep
//
//  Created by mono on 7/24/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
                            
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var user: PFUser?
    var users: Array<PFUser>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.tableView.backgroundColor = UIColor.clearColor()
        
        self.configureBackgroundTheme()
        
        let account = Account.instance()!
        nameLabel.text = account.nickname
        profileImageView.image = account.image
        
        self.loadUsers()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func loadUsers() {
        let query = PFUser.query()
        users = query.findObjects() as Array<PFUser>?
        println(users)
        self.tableView.reloadData()
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        let count = users?.count
        return count ? count! : 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as UITableViewCell
        let user = users![indexPath.row]
        user.fetchIfNeeded()
        println(user)
        cell.textLabel.text = user.valueForKey("nickname") as String
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        println(indexPath)
        let user = users![indexPath.row]
        let userQuery = PFUser.query()
        userQuery.whereKey("username", equalTo: user.username)
        let debug = userQuery.findObjects() as Array<PFUser>?
        println(debug)
        let pushQuery = PFInstallation.query()
        pushQuery.whereKey("user", matchesQuery: userQuery)
        
        let push = PFPush()
        push.setQuery(pushQuery)
        let data = ["alert": "(　´･‿･｀)", "sound": "sheep.caf"]
//        push.setMessage("(　´･‿･｀)")
        push.setData(data)
        push.sendPushInBackground()
    }
}

