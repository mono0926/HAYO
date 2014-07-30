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
    @IBOutlet weak var emailButton: UIButton!
    var snsUser: SNSUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackgroundTheme()
        designButton(facebookButton)
        designButton(twitterButton)
        designButton(emailButton)
    }
    
    @IBAction func twitterDidTap(sender: UIButton) {
        SVProgressHUD.showWithMaskType(UInt(SVProgressHUDMaskTypeGradient))
        Account.loginToTwitter() { user in
            self.handleResponse(user)
        }
    }
    
    @IBAction func facebookDidTap(sender: UIButton) {
        SVProgressHUD.showWithMaskType(UInt(SVProgressHUDMaskTypeGradient))
        Account.loginToFacebook() { user in
            self.handleResponse(user)
        }
    }
    
    func handleResponse(user: SNSUser?) {
        if Account.instance() {
            (UIApplication.sharedApplication().delegate as AppDelegate).navigate()
            return
        }
        
        if !user {
            SVProgressHUD.showErrorWithStatus("エラーが発生しました。Twitter認証で再度お願いします。")
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