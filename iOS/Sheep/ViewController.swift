//
//  ViewController.swift
//  Sheep
//
//  Created by mono on 7/24/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
                            
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var user: PFUser?
    var users: Array<PFUser>?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Account.MR_countOfEntities() > 0 {
            let account = Account.MR_findFirst() as Account
            nameTextField.text = account.username
            nameTextField.enabled = false
            registerButton.enabled = false
            PFUser.logInWithUsernameInBackground(account.username, password: "password", block: {user, error in
                
                self.user = user
                self.loadUsers()
                })
        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerButtonDidTap(sender: UIButton) {
        
        let user = PFUser()
        let username = nameTextField.text
        user.username = username
        user.password = "password"
        user.signUpInBackgroundWithBlock { succeeded, error in
         
            if error {
                println(error)
                return;
            }
            let account = Account.MR_createEntity() as Account
            account.username = username
            account.save()
            self.nameTextField.enabled = false
            self.registerButton.enabled = false
            
            let installation = PFInstallation.currentInstallation()
            installation["user"] = PFUser.currentUser()
            installation.saveInBackground()
            self.loadUsers()
        }
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
        cell.textLabel.text = user.username
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

