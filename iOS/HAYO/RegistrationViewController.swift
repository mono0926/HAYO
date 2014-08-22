//
//  RegistrationViewController.swift
//  Sheep
//
//  Created by mono on 7/29/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    var user: SNSUser!
    var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundTheme()
        profileImageView.configureAsMyCircle()
        
        let url = user.imageURL
        println(url)
        profileImageView.sd_setImageWithURL(NSURL(string: user.imageURL), completed: {image, error, type, url -> () in
            })
        nameTextField.text = user.username
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        nameTextField.becomeFirstResponder()
    }
    
    @IBAction func cancelDidTap(sender: UIBarButtonItem) {
        nameTextField.resignFirstResponder()
        showProgress()
        Account.unregister() {
            self.dismissProgress()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    @IBAction func registerDidTap(sender: UIBarButtonItem) {
        exesuteRegister()
    }
    
    func exesuteRegister() {
        nameTextField.resignFirstResponder()
        showProgress()
        processRegistration()
    }
    
    func processRegistration() {
        Account.createAsync(nameTextField.text, imageURL: user.imageURL, image:profileImageView.image!, snsUser: user, completed: { error in
            if nil == error {
                self.dismissProgress()
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
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        exesuteRegister()
        return true
    }
}