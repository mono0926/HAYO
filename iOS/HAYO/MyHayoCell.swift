//
//  MyHayoCell.swift
//  Sheep
//
//  Created by mono on 8/8/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
class MyHayoCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    var _hayo: Hayo! = nil
    var hayo: Hayo! {
        set {
            if nil == newValue {
                return
            }
            _hayo = newValue
            profileImageView.image = (Account.instance() as User).image
            messageLabel.text = NSString(format: localize("HayoMyMessageFormat"), _hayo.message);
        }
        get {
            return _hayo
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()        
        profileImageView.configureAsMyCircle()
    }
}