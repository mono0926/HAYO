//
//  LoginViewController.swift
//  Sheep
//
//  Created by mono on 7/28/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation

class LoginViewController: UIViewController {
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    var snsUser: SNSUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackgroundTheme()
        designButton(facebookButton)
        designButton(twitterButton)
    }
    
    @IBAction func twitterDidTouchUpOutside(sender: UIButton) {
        twitterButton.backgroundColor = UIColor.clearColor()
    }
    @IBAction func twitterDidTouchDown(sender: UIButton) {
        twitterButton.backgroundColor = UIColor(white: 1, alpha: 0.35)
    }
    @IBAction func twitterDidTap(sender: UIButton) {
        SVProgressHUD.showWithMaskType(UInt(SVProgressHUDMaskTypeGradient))
        Account.loginToTwitter() { user in
            self.handleResponse(user)
        }
    }
    @IBAction func facebookDidTouchDown(sender: UIButton) {
        facebookButton.backgroundColor = UIColor(white: 1, alpha: 0.35)
    }
    @IBAction func facebookDidTouchUpOutside(sender: UIButton) {
        facebookButton.backgroundColor = UIColor.clearColor()
    }
    @IBAction func facebookDidTap(sender: UIButton) {
        
        facebookButton.backgroundColor = UIColor.clearColor()

        SVProgressHUD.showWithMaskType(UInt(SVProgressHUDMaskTypeGradient))
        Account.loginToFacebook() { user in
            self.handleResponse(user)
        }
    }
    
    func handleResponse(user: SNSUser?) {
        if Account.instance() != nil {
            SVProgressHUD.dismiss()
            (UIApplication.sharedApplication().delegate as AppDelegate).navigate()
            return
        }
        
        if user == nil {
            showError()
            return;
        }
        
        self.snsUser = user
        SVProgressHUD.dismiss()
        self.performSegueWithIdentifier("Registration", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "Registration" {
            let vc = segue.destinationViewController.topViewController as RegistrationViewController
            vc.user = snsUser
        }
    }
}