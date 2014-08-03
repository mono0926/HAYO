//
//  ViewController.swift
//  Sheep
//
//  Created by mono on 7/24/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import UIKit
import AVFoundation

let sideMenuWidth = CGFloat(200)

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
//    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var hayoButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    var sideMenuViewController: SideMenuViewController?
    var users: Array<PFUser>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerNib(UINib(nibName: "FriendCell", bundle: nil), forCellWithReuseIdentifier: "FriendCell")
    
        self.configureBackgroundTheme()
        designButton(hayoButton)
        
        let account = Account.instance()!
        let image = account.barButtonImage.imageWithRenderingMode(.AlwaysOriginal)
        let profileButtonItem = UIBarButtonItem(image: image, style: .Plain, target: self, action: "profileDidTap")
        self.navigationItem.rightBarButtonItem = profileButtonItem
        
        self.loadUsers()
        
    }
    
    func profileDidTap() {
        let vc = ProfileViewController.create()
        self.presentViewController(vc, animated: true, completion: {})
    }
    
    func closeMenu() {
    
        self.view.layoutIfNeeded()
        let vc = sideMenuViewController!
        vc.view.mas_updateConstraints({make in
            make.left.equalTo()(self.view.mas_left).with().offset()(-sideMenuWidth)
            return ()
        })
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: {finished in
            vc.view .removeFromSuperview()
            self.sideMenuViewController = nil
        })
    }
    
    @IBAction func homeButtonDidTap(sender: UIBarButtonItem) {
        
        if let vc = sideMenuViewController {
            closeMenu()
            return
        }
        
        sideMenuViewController = SideMenuViewController.create()
        sideMenuViewController!.selectedBlock = { type in
            self.closeMenu()
            switch type {
            case .HayoList:
                let hayoVC = HayoListViewController.create()
                self.navigationController.presentViewController(hayoVC, animated: true, completion: {})
            case .SearchFrinds:
                let searchVC = SearchFriendsViewController.create()
                let navVC = UINavigationController(rootViewController: searchVC)
                self.navigationController.presentViewController(navVC, animated: true, completion: {})
                return
            case .EditHayoMessage:
                return
            case .NotificationSound:
                return
            }
        }
        
        let view = sideMenuViewController!.view
        
        self.view.addSubview(view)
        
        view.mas_makeConstraints({make in
            make.bottom.equalTo()(self.view.mas_bottom).with().offset()(0)
            make.top.equalTo()(self.view.mas_top).with().offset()(0)
            make.left.equalTo()(self.view.mas_left).with().offset()(-sideMenuWidth)
            make.width.equalTo()(sideMenuWidth)
            return ()
            })
        
        self.view.layoutIfNeeded()
        
        view.mas_updateConstraints({make in
            make.left.equalTo()(self.view.mas_left).with().offset()(0)
            return ()
            })
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.layoutIfNeeded()
            }, completion: {finished in })
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
        // TODO:
        return count ? count!+5 : 0
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FriendCell", forIndexPath: indexPath) as FriendCell
        // TODO:
        let user = users![0]
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
        
        SNSClient.sharedInstance.hayo(user)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(pickerView: UIPickerView!, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString! {
        
        var title = ""
        switch row {
        case 0:
            title = "とにかくHAYO!!"
        case 1:
            title = "進捗どうですか？"
        case 2:
            title = "返信まだですか？"
        case 3:
            title = "納品まだですか？"
        case 4:
            title = "HAYO理由を追加"
        default:
            title = ""
        }
        
        return NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        if row == 4 {
            SVProgressHUD.showWithStatus("追加画面へ(未実装)")
            return
        }
        SVProgressHUD.dismiss()
    }
}

