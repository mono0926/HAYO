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
    
    @IBAction func facebookDidTap(sender: UIButton) {
        let permissions = ["user_about_me", "user_relationships", "user_birthday", "user_location"]
        PFFacebookUtils.logInWithPermissions(permissions, block: {user, error in
            if !user {
                if !error {
                    println("Uh oh. The user cancelled the Facebook login.")
                    return;
                }
                println("Uh oh. An error occurred: %@", error)
                return
            }
            if user.isNew {
                println("user.isNew, user: %@", user)
            } else {
                println("User with facebook logged in!, user: %@", user)
            }
           (UIApplication.sharedApplication().delegate as AppDelegate).navigateToMain()
            })
    }
}