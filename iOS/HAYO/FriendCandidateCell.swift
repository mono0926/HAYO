//
//  FriendCandidateCell.swift
//  Sheep
//
//  Created by mono on 8/1/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
class FriendCandidateCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var _snsUser: SNSUser! = nil
    var snsUser: SNSUser! {
    set {
        if nil == newValue {
            return
        }
        println(newValue.name)
        _snsUser = newValue
        self.profileImageView.sd_setImageWithURL((NSURL(string: _snsUser.imageURL!)), completed: {image, error, type, url -> () in
            })
        self.nameLabel.text = _snsUser.name
    }
    get {
        return _snsUser
    }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.configureAsCircle()
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = themeColor.CGColor
    }
}