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
    
    
    var _hayo: Hayo! = nil
    var hayo: Hayo! {
        set {
            if nil == newValue {
                return
            }
            _hayo = newValue
            _hayo.getImageURL() { url in
                self.profileImageView.sd_setImageWithURL((NSURL(string: url)), completed: {image, error, type, url -> () in
                })
            }
            _hayo.getFriendMessage() { message in
                self.messageLabel.text = message
            }
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