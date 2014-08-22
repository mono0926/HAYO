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
    @IBOutlet weak var selectedIcon: UIButton!
    
    func setUser(user: PFUser!, isSelected: Bool) {
        if nil == user {
            return
        }
        println(user.username)
        _user = user
        self.profileImageView.sd_setImageWithURL((NSURL(string: _user.getImageURL())), completed: {image, error, type, url -> () in
        })
        self.nameLabel.text = _user.username
        self.isSelected = isSelected
        
    }
    
    var _isSelected: Bool = false
    
    var isSelected: Bool {
        get { return _isSelected }
        set {
            _isSelected = newValue
            selectedIcon.setImage(UIImage(named: _isSelected ? "selected" : "not_selected"), forState: .Normal)
        }
    }
    
    var _user: PFUser! = nil
    var snsUser: PFUser! {
    get {
        return _user
    }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.configureAsCircle()
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = themeColor.CGColor
    }
}