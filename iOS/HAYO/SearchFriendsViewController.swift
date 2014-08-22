//
//  SearchFriendsViewController.swift
//  Sheep
//
//  Created by mono on 8/1/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
class SearchFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var friendCandicateCountLabel: UILabel!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectAllButton: UIButton!
    var fromMain = false
    var friendsCandidates: [PFUser]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.configureBackgroundTheme()
        self.setEditing(true, animated: false)
        
        tableView.registerNib(UINib(nibName: "FriendCandidateCell", bundle: nil), forCellReuseIdentifier: "FriendCandidateCell")
        self.tableView.rowHeight = 70
        
        Account.searchFriendCandidates() { friendsCandidates in
            
            if friendsCandidates.count == 0 {
                self.showAlertView(confirmString, message: localize("RecommendShareMyID"), okBlock: {
                    self.shareMyId()
                    }, cancelBlock: {
                })
            }
            
            self.friendsCandidates = friendsCandidates
            self.updateCount()
            self.tableView .reloadData()
            self.selectAllImpl()
        }
    }
    
    func updateCount() {
        self.friendCandicateCountLabel.text = NSString(format: localize("FriendCandidatesCountFormat"), selectedPaths.count, self.friendsCandidates.count)
        updateSelectAllButton()
    }
    
    func updateSelectAllButton() {
        let key = selectedPaths.count == friendsCandidates.count ? "UnselectAll" : "SelectAll"
        selectAllButton.setTitle(localize(key), forState: .Normal)
    }
    
    class func create() -> SearchFriendsViewController {
        let sb = UIStoryboard(name: "Login", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("SearchFriends") as SearchFriendsViewController
        vc.fromMain = true
        return vc
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func selectAllImpl() {
        for i in 0..<friendsCandidates!.count {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as FriendCandidateCell
            cell.isSelected = true
        }
        updateCount()
    }
    
    @IBAction func selectAllDidTap(sender: UIButton) {
        if selectedPaths.count == friendsCandidates.count {
            for p in selectedPaths {
                tableView.deselectRowAtIndexPath(p, animated: false)
                let cell = tableView.cellForRowAtIndexPath(p) as FriendCandidateCell
                cell.isSelected = false
            }
            updateCount()
            return
        }
        selectAllImpl()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int
    {
        return friendsCandidates != nil ? 1 : 0
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as FriendCandidateCell
        cell.isSelected = true
        updateCount()
    }
    
    func tableView(tableView: UITableView!, didDeselectRowAtIndexPath indexPath: NSIndexPath!) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as FriendCandidateCell
        cell.isSelected = false
        updateCount()
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return friendsCandidates!.count
    }
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCandidateCell", forIndexPath: indexPath) as FriendCandidateCell
        cell.selectionStyle = .None
        let user = friendsCandidates![indexPath.row]
        let isSelected = contains(selectedPaths, indexPath)
        cell.setUser(user, isSelected: isSelected)
        return cell
    }
    
    var selectedPaths: [NSIndexPath] {
        get {
            let paths = tableView.indexPathsForSelectedRows()
            if paths == nil {
                return []
            }
            return paths as [NSIndexPath]
        }
    }
    
    @IBAction func doneButtonDidTap(sender: UIBarButtonItem) {
        
        if selectedPaths.count == 0 {
            self.navigate()
            return
        }
        
        let users = selectedPaths.map() { p in
            return self.friendsCandidates![p.row]
        } as [PFUser]
        
        ParseClient.sharedInstance.makeFriends(users) { success, error in
            self.navigate()
        }
    }
    
    private func navigate() {
        if fromMain {
            self.dismissViewControllerAnimated(true, completion: {})
        } else {
            self.appDelegate().navigate()
        }
    }
}