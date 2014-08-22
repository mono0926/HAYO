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
    private var _needReload = false
    
    class func create() -> UINavigationController {
        let sb = UIStoryboard(name: "HayoList", bundle: nil)
        return sb.instantiateInitialViewController() as UINavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hayoList = Hayo.fetchHayoList(self)
        
        self.tableView.backgroundView = nil
        self.configureBackgroundTheme()
        tableView.registerNib(UINib(nibName: "MyHayoCell", bundle: nil), forCellReuseIdentifier: "MyHayoCell")
        tableView.registerNib(UINib(nibName: "FriendHayoCell", bundle: nil), forCellReuseIdentifier: "FriendHayoCell")
        self.tableView.rowHeight = 60
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Hayo.updateHayoList()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        let count = hayoList.fetchedObjects.count
        println(count)
        return count
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    
    func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView! {
        let v = UIView()
        v.backgroundColor = UIColor.clearColor()
        return v
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let hayo = hayoList.fetchedObjects[indexPath.section] as Hayo
        if hayo.from.parseObjectId == Account.instance().parseObjectId {
            let cell = tableView.dequeueReusableCellWithIdentifier("MyHayoCell", forIndexPath: indexPath) as MyHayoCell
            cell.hayo = hayo
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendHayoCell", forIndexPath: indexPath) as FriendHayoCell
        cell.setHayo(hayo, imageHidden: false) { user in
            let vc = FriendViewController.createWithoutNavigation()
            vc.user = user
            self.navigationController.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    // MARK: FetchedResultsControllerDelegate
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        if _needReload {
            tableView.reloadData()
        }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController!)  {
        _needReload = false
    }
    
    func controller(controller: NSFetchedResultsController!, didChangeObject anObject: AnyObject!, atIndexPath indexPath: NSIndexPath!, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath!) {
        if type != .Update {
            _needReload = true
        }
    }
    
    @IBAction func closeDidTap(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
}