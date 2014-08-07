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
    var hayoList: [Hayo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "MyHayoCell", bundle: nil), forCellReuseIdentifier: "MyHayoCell")
        tableView.registerNib(UINib(nibName: "FriendHayoCell", bundle: nil), forCellReuseIdentifier: "FriendHayoCell")
        self.tableView.rowHeight = 60
        
        self.title = user.nickname
        
        PFCloud.callFunctionInBackground("hayoList", withParameters: ["fromId": PFUser.currentUser().objectId, "toId": user.objectId], block: { result, error in
            println(result)
            let sources = result as [PFObject]
            self.hayoList = sources.map() { s in
                return Hayo(source: s)
            }
            self.tableView.reloadData()
        })
    }
    @IBAction func closeDidTap(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    class func create() -> UINavigationController {
        let sb = UIStoryboard(name: "Friend", bundle: nil)
        let navVC = sb.instantiateInitialViewController() as UINavigationController
        return navVC
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return hayoList == nil ? 0 : hayoList!.count
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let hayo = hayoList![indexPath.section]
        if hayo.fromUser.objectId == PFUser.currentUser().objectId {
            let cell = tableView.dequeueReusableCellWithIdentifier("MyHayoCell", forIndexPath: indexPath) as MyHayoCell
            cell.hayo = hayo
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendHayoCell", forIndexPath: indexPath) as FriendHayoCell
        cell.hayo = hayo
        return cell
    }
    
    override func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
}