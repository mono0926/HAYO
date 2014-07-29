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
    @IBOutlet weak var nameLabel: UITextField!
    var user: TypedFacebookUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.sd_setImageWithURL(NSURL(string: user.imageURL))
        nameLabel.text = user.name
    }
}