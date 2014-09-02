//
//  FriendViewController.swift
//  Sheep
//
//  Created by mono on 8/6/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation

class FriendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    var user: User!
    var hayoList: NSFetchedResultsController!
    
    class func create() -> UINavigationController {
        let sb = UIStoryboard(name: "Friend", bundle: nil)
        let navVC = sb.instantiateInitialViewController() as UINavigationController
        return navVC
    }
    class func createWithoutNavigation() -> FriendViewController {
        let sb = UIStoryboard(name: "Friend", bundle: nil)
        let navVC = sb.instantiateInitialViewController().topViewController as FriendViewController
        return navVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.navigationController!.viewControllers[0] as UIViewController != self {
            self.navigationItem.leftBarButtonItem = nil;
        }
        
        hayoList = Hayo.fetchHayoList(user, delegate: self)
        
        self.tableView.backgroundView = nil
        
        self.configureBackgroundTheme()
        profileImageView.configureAsMyCircle()
        
        tableView.registerNib(UINib(nibName: "MyHayoCell", bundle: nil), forCellReuseIdentifier: "MyHayoCell")
        tableView.registerNib(UINib(nibName: "FriendHayoCell", bundle: nil), forCellReuseIdentifier: "FriendHayoCell")
        tableView.registerNib(UINib(nibName: "MyReplyCell", bundle: nil), forCellReuseIdentifier: "MyReplyCell")
        tableView.registerNib(UINib(nibName: "FriendReplyCell", bundle: nil), forCellReuseIdentifier: "FriendReplyCell")
        
        println(user.username)
        self.title = user.username
        profileImageView.sd_setImageWithURL((NSURL(string: user.imageURL)), completed: {image, error, type, url -> () in
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Hayo.updateHayoList(user) {}        
    }
    
    @IBAction func closeDidTap(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func numberOfSectionsIntableView(tableView: UITableView) -> Int {
        return hayoList.fetchedObjects!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let hayo = hayoList.fetchedObjects![section] as Hayo
        return 1 + hayo.replies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let hayo = hayoList.fetchedObjects![indexPath.section] as Hayo
        
        let row = indexPath.row
        if row != 0 {
            let reply = hayo.orderedReply[row - 1]
            if reply.hayo.to.parseObjectId == Account.instance().parseObjectId {
                let cell = tableView.dequeueReusableCellWithIdentifier("MyReplyCell", forIndexPath: indexPath) as MyReplyCell
                cell.reply = reply
                return cell
            }
            let cell = tableView.dequeueReusableCellWithIdentifier("FriendReplyCell", forIndexPath: indexPath) as FriendReplyCell
            cell.reply = reply
            return cell
        }
        
        if hayo.from.parseObjectId == Account.instance().parseObjectId {
            let cell = tableView.dequeueReusableCellWithIdentifier("MyHayoCell", forIndexPath: indexPath) as MyHayoCell
            cell.hayo = hayo
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendHayoCell", forIndexPath: indexPath) as FriendHayoCell
        println(hayo.from.parseObjectId)
        cell.setHayo(hayo, imageHidden: true, profileButtonDidTapHandler: { user in
            }) { index, messageId in
                hayo.reply(messageId) {
                    self.showSuccess(NSString(format: localize("HayoRepliedFormat"), hayo.from.username))
                }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor.clearColor()
        return v
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        }
        return 44
    }
    
    // MARK: FetchedResultsControllerDelegate
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController)  {
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject!, atIndexPath indexPath: NSIndexPath, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath) {
    }
}