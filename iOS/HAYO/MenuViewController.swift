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
        nameButton.setTitle(account.nickname, forState: .Normal)
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
    @IBAction func viewDidTap(sender: UITapGestureRecognizer) {
        self.dismissViewControllerAnimated(true) {}
    }
    func vibrancyEffectView(forBlurEffectView blurEffectView:UIVisualEffectView) -> UIVisualEffectView {
        let vibrancy = UIVibrancyEffect(forBlurEffect: blurEffectView.effect as UIBlurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancy)
        vibrancyView.userInteractionEnabled = false
        vibrancyView.frame = blurEffectView.bounds
        vibrancyView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        return vibrancyView
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