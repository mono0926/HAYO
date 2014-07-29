//
//  LoginViewController.swift
//  Sheep
//
//  Created by mono on 7/28/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
import QuartzCore

class LoginViewController: UIViewController {
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    var facebookUser: TypedFacebookUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        let startColor = UIColor(hue: 162/360.0, saturation: 0.67, brightness: 0.82, alpha: 1).CGColor
        let endColor = UIColor(hue: 205/360.0, saturation: 0.76, brightness: 0.93, alpha: 1).CGColor
        gradient.colors = NSArray(objects: startColor, endColor)
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
        designButton(facebookButton)
        designButton(twitterButton)
        designButton(emailButton)
    }
    
    func designButton(button: UIButton) {
        
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
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
            (UIApplication.sharedApplication().delegate as AppDelegate).navigateToMain()
        }
    }
    
    @IBAction func facebookDidTap(sender: UIButton) {
        SVProgressHUD.showWithMaskType(UInt(SVProgressHUDMaskTypeGradient))
        SNSClient.sharedInstance.loginToFacebook() { user in
            self.facebookUser = user
            SVProgressHUD.dismiss()
            self.performSegueWithIdentifier("Registration", sender: self)
//            (UIApplication.sharedApplication().delegate as AppDelegate).navigateToMain()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "Registration" {
            let vc = segue.destinationViewController.topViewController as RegistrationViewController
            vc.user = facebookUser
        }
    }
}