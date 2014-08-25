//
//  MyReplyCell.swift
//  HAYO
//
//  Created by mono on 8/25/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
class MyReplyCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    var _reply: HayoReply! = nil
    var reply: HayoReply! {
        set {
            if nil == newValue {
                return
            }
            _reply = newValue
            profileImageView.image = (Account.instance() as User).image
            messageLabel.text = NSString(format: localize("HayoMyMessageFormat"), _reply.message);
        }
        get {
            return _reply
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.configureAsMyCircle()
    }
}