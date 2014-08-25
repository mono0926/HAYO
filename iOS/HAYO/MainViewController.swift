//
//  ViewController.swift
//  Sheep
//
//  Created by mono on 7/24/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import UIKit
import AVFoundation
import PromiseKit

let sideMenuWidth = CGFloat(200)

class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, iCarouselDelegate, iCarouselDataSource, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var hayoButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var carouselContainerView: UIView!
    private var _needReload = false
    var carousel: iCarousel!
    var users: NSFetchedResultsController!
    let hayoMessages = ["HAYO!!", "進捗どうですか？","返信まだですか？","納品まだですか？","HAYO理由を追加"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        users = User.fetchUserList(self)
        
        carousel = iCarousel()
        carouselContainerView.addSubview(carousel)
        let padding = UIEdgeInsetsMake(0, 0, 0, 0);
        carousel.mas_makeConstraints() {make in
            make.edges.equalTo()(self.carouselContainerView).with().insets()(padding)
            return ()
        }
        carousel.delegate = self
        carousel.dataSource = self
        carousel.type = .CoverFlow
    
        self.configureBackgroundTheme()
        
        let account = Account.instance()!
        let image = account.barButtonImage.imageWithRenderingMode(.AlwaysOriginal)
        let profileButtonItem = UIBarButtonItem(image: image, style: .Plain, target: self, action: "profileDidTap")
        self.navigationItem.rightBarButtonItem = profileButtonItem
        
        
    }
    @IBAction func hayoDidTap(sender: UIButton) {
        let user = users.fetchedObjects[carousel.currentItemIndex] as User
        let message = hayoMessages[pickerView.selectedRowInComponent(0)]
        ParseClient.sharedInstance.hayo(user, message: message, category: "HAYO") { result, error in
            if nil != error {
                self.showError()
                return
            }
            let message = NSString(format: localize("SentHayoFormat"), user.username)
            self.showSuccess(message)
        }
    }
    
    func profileDidTap() {
        let vc = MenuViewController.create()
        self.navigationController.modalPresentationStyle = .CurrentContext // iOS7用
        self.presentViewController(vc, animated: isIOS8OrLater(), completion: {})
    }
    
    @IBAction func homeButtonDidTap(sender: UIBarButtonItem) {
        let hayoVC = HayoListViewController.create()
        self.navigationController.presentViewController(hayoVC, animated: true, completion: {})
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        User.updateUsers()        
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
        let count = users.fetchedObjects.count
        self.hayoButton.enabled = count != 0
        return count
    }
    
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, reusingView view: UIView!) -> UIView! {
     
        var friendView: FriendView! = view as? FriendView
        if nil == friendView {
            friendView = FriendView.create()
//            friendView.frame = CGRectMake(0, 0, 130, 150)
        } else {
            println("view resused")
        }
        let user = users.fetchedObjects[Int(index)] as User
        friendView.user = user
        return friendView
    }
    
    func carouselItemWidth(carousel: iCarousel!) -> CGFloat {
        return 140
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func carousel(carousel: iCarousel!, didSelectItemAtIndex index: Int) {
        
        if carousel.currentItemIndex != index {
            return
        }
        
        let vc = FriendViewController.create()
        let user = users.fetchedObjects[index] as User
        let friendVC = vc.topViewController as FriendViewController
        friendVC.user = user
        self.presentViewController(vc, animated: true, completion: {})
    }
    
    func pickerView(pickerView: UIPickerView!, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString! {
        
        var title = ""
        switch row {
        case 0:
            title = "とにかくHAYO!!"
        default:
            title = hayoMessages[row]
        }
        
        return NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        if row == 4 {
            showError("追加画面へ？(未実装)")
            return
        }
        SVProgressHUD.dismiss()
    }

    // MARK: FetchedResultsControllerDelegate
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        if _needReload {
            carousel.reloadData()
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

}

