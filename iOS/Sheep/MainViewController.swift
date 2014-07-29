//
//  ViewController.swift
//  Sheep
//
//  Created by mono on 7/24/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
                            
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
//    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    var users: Array<PFUser>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerNib(UINib(nibName: "FriendCell", bundle: nil), forCellWithReuseIdentifier: "FriendCell")
    
//        self.tableView.backgroundColor = UIColor.clearColor()
        
        self.configureBackgroundTheme()
        designButton(logoutButton)
        
        let account = Account.instance()!
        nameLabel.text = account.nickname
        profileImageView.image = account.image
        
        self.loadUsers()
        
    }
    @IBAction func logoutButtonDidTap(sender: UIButton) {
        Account.deleteInstance()
        (UIApplication.sharedApplication().delegate as AppDelegate).navigate()        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func loadUsers() {
        let query = PFUser.query()
        users = query.findObjects() as Array<PFUser>?
        println(users)
        collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        let count = users?.count
        return count ? count! : 0
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FriendCell", forIndexPath: indexPath) as FriendCell
        let user = users![indexPath.row]
        user.fetchIfNeeded()
        println(user)
        
        cell.imageView.sd_setImageWithURL(NSURL(string: user.getImageURL()), completed: {image, error, type, url -> () in
            })
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        UIView.animateWithDuration(0.3, animations: {
            cell.alpha = 0.5
            UIView.animateWithDuration(0.1, animations: {
                cell.alpha = 1
                })
            })
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
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
        let message = NSString(format: "%@ < HAYO!!", Account.instance().nickname)
        let data = ["alert": message, "sound": "sheep.caf"]
//        push.setMessage("(　´･‿･｀)")
        push.setData(data)
        push.sendPushInBackground()
    }
}

