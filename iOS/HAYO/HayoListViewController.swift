//
//  HayoListViewController.swift
//  Sheep
//
//  Created by mono on 8/3/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
class HayoListViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var hayoList: NSFetchedResultsController!
    @IBOutlet weak var tableView: UITableView!
    
    class func create() -> UINavigationController {
        let sb = UIStoryboard(name: "HayoList", bundle: nil)
        return sb.instantiateInitialViewController() as UINavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hayoList = Hayo.fetchHayoList(self)
        
        self.tableView.backgroundView = nil
        self.configureBackgroundTheme()
        tableView.registerNib(UINib(nibName: "MyReplyCell", bundle: nil)!, forCellReuseIdentifier: "MyReplyCell")
        tableView.registerNib(UINib(nibName: "FriendHayoCell", bundle: nil)!, forCellReuseIdentifier: "FriendHayoCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Hayo.updateHayoList()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let count = hayoList.fetchedObjects!.count
        println(count)
        return count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let hayo = hayoList.fetchedObjects![section] as Hayo
        return 1 + hayo.replies.count
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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor.clearColor()
        return v
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let hayo = hayoList.fetchedObjects![indexPath.section] as Hayo
        
        let row = indexPath.row
        if row != 0 {
            let reply = hayo.orderedReply[row - 1]
            let cell = tableView.dequeueReusableCellWithIdentifier("MyReplyCell", forIndexPath: indexPath) as MyReplyCell
            cell.reply = reply
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendHayoCell", forIndexPath: indexPath) as FriendHayoCell
        cell.setHayo(hayo, imageHidden: false, profileButtonDidTapHandler: { user in
            let vc = FriendViewController.createWithoutNavigation()
            vc.user = user
            self.navigationController!.pushViewController(vc, animated: true)
            }) { index, messageId in
                hayo.reply(messageId) {
                    self.showSuccess(NSString(format: localize("HayoRepliedFormat"), hayo.from.username))
                }
        }
        return cell
    }
    
    // MARK: FetchedResultsControllerDelegate
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        tableView.reloadData()
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController!)  {
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
    }
    
    @IBAction func closeDidTap(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
}