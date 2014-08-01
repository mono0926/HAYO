//
//  SearchFriendsViewController.swift
//  Sheep
//
//  Created by mono on 8/1/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
class SearchFriendsViewController: UITableViewController {
    @IBOutlet weak var friendCandicateCountLabel: UILabel!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageBackgroundView: UIView!
    var friendsCandidates: [SNSUser]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageBackgroundView.configureBackgroundTheme()
        self.setEditing(true, animated: false)
        
        tableView.registerNib(UINib(nibName: "FriendCandidateCell", bundle: nil), forCellReuseIdentifier: "FriendCandidateCell")
        self.tableView.rowHeight = 70
        
        Account.searchFriendCandidates() { friendsCandidate in
            self.friendsCandidates = friendsCandidate
            self.friendCandicateCountLabel.text = NSString(format: self.localize("FriendCandidatesCountFormat"), self.friendsCandidates.count)
            self.tableView .reloadData()
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int
    {
        return friendsCandidates ? 1 : 0
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return friendsCandidates!.count
    }
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCandidateCell", forIndexPath: indexPath) as FriendCandidateCell
        cell.snsUser = friendsCandidates![indexPath.row]
        return cell
    }
    
    @IBAction func doneButtonDidTap(sender: UIBarButtonItem) {
        self.appDelegate().navigate()
    }
}