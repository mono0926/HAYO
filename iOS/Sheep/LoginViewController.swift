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
    var facebookUser: TypedFacebookUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackgroundTheme()
        designButton(facebookButton)
        designButton(twitterButton)
        designButton(emailButton)
    }
    
    @IBAction func twitterDidTap(sender: UIButton) {
        PFTwitterUtils.logInWithBlock {
            (user: PFUser!, error: NSError!) in
            if !user {
                println("Uh oh. The user cancelled the Twitter login.")
                return
            }
            if user.isNew {
                println("User signed up and logged in with Twitter!")
            } else {
                println("User logged in with Twitter!")
            }
        }
    }
    
    @IBAction func facebookDidTap(sender: UIButton) {
        SVProgressHUD.showWithMaskType(UInt(SVProgressHUDMaskTypeGradient))
        Account.loginToFacebook() { user in
            
            if Account.instance() {                
                (UIApplication.sharedApplication().delegate as AppDelegate).navigate()
            }
            
            self.facebookUser = user
            SVProgressHUD.dismiss()
            self.performSegueWithIdentifier("Registration", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "Registration" {
            let vc = segue.destinationViewController.topViewController as RegistrationViewController
            vc.user = facebookUser
        }
    }
}