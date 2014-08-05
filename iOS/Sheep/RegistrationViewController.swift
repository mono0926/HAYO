//
//  RegistrationViewController.swift
//  Sheep
//
//  Created by mono on 7/29/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation

class RegistrationViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    var user: SNSUser!
    var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundTheme()
        designButton(registerButton)
        registerButton.alpha = 0.5
        profileImageView.configureAsMyCircle()
        
        let hoge = user.name
        println(hoge)
        let url = user.imageURL
        println(url)
        profileImageView.sd_setImageWithURL(NSURL(string: user.imageURL), completed: {image, error, type, url -> () in
            self.registerButton.alpha = 1
            self.registerButton.enabled = true
            })
        nameTextField.text = user.name
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        nameTextField.becomeFirstResponder()
    }
    
    @IBAction func registerDidTap(sender: UIButton) {
        nameTextField.resignFirstResponder()
        SVProgressHUD.showWithMaskType(UInt(SVProgressHUDMaskTypeGradient))
        processRegistration()
    }
    @IBAction func cancelDidTap(sender: UIBarButtonItem) {
        nameTextField.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func processRegistration() {
        Account.createAsync(nameTextField.text, imageURL: user.imageURL, image:profileImageView.image!, email: user.email, completed: { error in
            if nil == error {
                SVProgressHUD.dismiss()
                self.performSegueWithIdentifier("Friends", sender: self)
//                (UIApplication.sharedApplication().delegate as AppDelegate).navigate()
                return
            }
            self.showError()
            self.bk_performBlock({ obj in
                (UIApplication.sharedApplication().delegate as AppDelegate).navigate()
                }, afterDelay: 3)
        })
    }
}