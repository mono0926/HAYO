//
//  FriendHayoCell.swift
//  Sheep
//
//  Created by mono on 8/8/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
class FriendHayoCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    var _hayo: PFObject? = nil
    var hayo: PFObject! {
        set {
            if !newValue {
                return
            }
            println(newValue.objectForKey("message"))
            _hayo = newValue
            let user = _hayo!.objectForKey("from") as PFUser
            self.profileImageView.sd_setImageWithURL((NSURL(string: user.imageURL!)), completed: {image, error, type, url -> () in
            })
            self.messageLabel.text = _hayo!.objectForKey("message") as String
        }
        get {
            return _hayo
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.configureAsCircle()
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = themeColor.CGColor
    }
}