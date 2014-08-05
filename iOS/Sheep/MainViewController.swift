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

class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, iCarouselDelegate, iCarouselDataSource {
    @IBOutlet weak var hayoButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var carouselContainerView: UIView!
    var carousel: iCarousel!
    var sideMenuViewController: SideMenuViewController?
    var users: [PFUser]?
    let hayoMessages = ["HAYO!!", "返信まだですか？", "到着まだですか？", "ご飯行きましょう"]
    let hayoMessages2 = ["進捗どうですか？","納品まだですか？","リリースまだですか？","会議まだ終わらないんですか？"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hayoButton.enabled = false
        
        carousel = iCarousel()
        carouselContainerView.addSubview(carousel)
        let padding = UIEdgeInsetsMake(0, 0, 0, 0);
        carousel.mas_makeConstraints() {make in
            make.edges.equalTo()(self.carouselContainerView).with().insets()(padding)
            return ()
        }
        carousel.delegate = self
        carousel.dataSource = self
        carousel.type = iCarouselTypeCoverFlow
    
        self.configureBackgroundTheme()
        designButton(hayoButton)
        
        let account = Account.instance()!
        let image = account.barButtonImage.imageWithRenderingMode(.AlwaysOriginal)
        let profileButtonItem = UIBarButtonItem(image: image, style: .Plain, target: self, action: "profileDidTap")
        self.navigationItem.rightBarButtonItem = profileButtonItem
        
        self.loadUsers()
        
    }
    @IBAction func hayoDidTap(sender: UIButton) {
        let user = users![carousel.currentItemIndex]
        let message = hayoMessages[pickerView.selectedRowInComponent(0)]
        SNSClient.sharedInstance.hayo(user, message: message) { success, error in
            if error {
                self.showError()
                return
            }
            let message = NSString(format: localize("SentHayoFormat"), user.getNickname())
            self.showSuccess(message)
            }
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
                self.notImplemented()
                let hayoVC = HayoListViewController.create()
                self.navigationController.presentViewController(hayoVC, animated: true, completion: {})
            case .SearchFrinds:
                self.notImplemented()
                let searchVC = SearchFriendsViewController.create()
                let navVC = UINavigationController(rootViewController: searchVC)
                self.navigationController.presentViewController(navVC, animated: true, completion: {})
                return
            case .EditHayoMessage:
                self.notImplemented()
            case .NotificationSound:
                self.notImplemented()
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
        query.findObjectsInBackgroundWithBlock({objects, error in
            if error {
                self.showError()
                return
            }
            self.hayoButton.enabled = true
            self.users = objects as? [PFUser]
            println(self.users)
            self.carousel.reloadData()
            self.carousel.currentItemIndex = min(self.users!.count, 1)
            })
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> UInt {
        let count = users?.count
        return count != nil ? UInt(count!) : 0
    }
    
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: UInt, reusingView view: UIView!) -> UIView! {
     
        var friendView: FriendView! = view as? FriendView
        if !friendView {
            friendView = FriendView.create()
//            friendView.frame = CGRectMake(0, 0, 130, 150)
        } else {
            println("view resused")
        }
        let user = users![Int(index)]
        user.fetchIfNeeded()
        friendView.user = user
        return friendView
    }
    
    func carouselItemWidth(carousel: iCarousel!) -> CGFloat {
        return 140
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return 2
        case 1: return 4
        default: return 0
        }
    }
    
    func carousel(carousel: iCarousel!, didSelectItemAtIndex index: Int) {
        
    }
    
    func pickerView(pickerView: UIPickerView!, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return 80
        case 1:
            return 240
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView!, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString! {
        
        
        var title = ""
        switch component {
        case 0:
            switch row {
            case 0:
                title = "標準"
            case 1:
                title = "開発"
            default:
                break
            }
        case 1:
            switch row {
            case 0:
                if pickerView.selectedRowInComponent(0) == 0 {
                    title = "とにかくHAYO!!"
                } else {
                    
                    title = hayoMessages2[row]
                }
            default:
                if pickerView.selectedRowInComponent(0) == 0 {
                    title = hayoMessages[row]
                } else {
                    
                    title = hayoMessages2[row]
                }
            }
        default:
            break
        }
        return NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName:UIFont.systemFontOfSize(9)])
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        
        pickerView.reloadAllComponents()
        
        if row == 4 {
            SVProgressHUD.showErrorWithStatus("追加画面へ？(未実装)")
            return
        }
        SVProgressHUD.dismiss()
    }
}

