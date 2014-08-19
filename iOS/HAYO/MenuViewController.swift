//
//  ProfileViewController.swift
//  Sheep
//
//  Created by mono on 8/3/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation

class MenuViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var nameButton: UIButton!
    
    @IBOutlet weak var findFriendButton: UIButton!
    @IBOutlet weak var shareIdButton: UIButton!
    @IBOutlet weak var rankingButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MenuViewController.designMenuButton(findFriendButton)
        MenuViewController.designMenuButton(shareIdButton)
        MenuViewController.designMenuButton(rankingButton)
        MenuViewController.designMenuButton(settingButton)
        
        if !self.view.enableBlurEffect() {
            self.view.backgroundColor = UIColor(white: 0.05, alpha: 0.8)
            self.view.alpha = 0
            UIView.animateWithDuration(0.3) {
                self.view.alpha = 1
            }
        }
        
//        self.configureBackgroundTheme()
        imageButton.configureAsMyCircle()
        
        let account = Account.instance()
        imageButton.imageView.contentMode = .ScaleAspectFill
        imageButton .setImage(account.image, forState: .Normal)
        nameButton.setTitle(account.username, forState: .Normal)
    }
    
    class func designMenuButton(button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 1, alpha: 0.5).CGColor
    }
    
    class func create() -> MenuViewController {
        let sb = UIStoryboard(name: "Menu", bundle: nil)
        let navVC = sb.instantiateInitialViewController() as MenuViewController
        navVC.modalTransitionStyle = .CrossDissolve
        navVC.transitioningDelegate = navVC
        return navVC
    }
    @IBAction func findFriendDidTap(sender: UIButton) {
        let searchVC = SearchFriendsViewController.create()
        let navVC = UINavigationController(rootViewController: searchVC)
        self.presentViewController(navVC, animated: true, completion: {})
    }
    @IBAction func shareMyIdDidTap(sender: UIButton) {
        self.shareMyId()
    }
    @IBAction func hayoRankingDidTap(sender: UIButton) {
        notImplemented()
    }
    @IBAction func settingDidTap(sender: UIButton) {
        let sVC = SettingViewController.create()
        self.presentViewController(sVC, animated: true) {}
    }
    @IBAction func viewDidTap(sender: UITapGestureRecognizer) {
        self.dismissViewControllerAnimated(true) {}
    }
    @IBAction func profileImageDidTap(sender: UIButton) {
        showAccountSetting()
    }
    @IBAction func usernameDidTap(sender: UIButton) {
        showAccountSetting()
    }
    
    func showAccountSetting() {
        let vc = AccountSettingViewController.create()
        let navVC = UINavigationController(rootViewController: vc)
        self.presentViewController(navVC, animated: true) {}
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func presentationControllerForPresentedViewController(presented: UIViewController!, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController!) -> UIPresentationController! {
        
        return nil
    }
    
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        
        return nil
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        
        return nil
    }
}