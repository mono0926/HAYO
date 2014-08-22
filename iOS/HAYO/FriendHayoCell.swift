//
//  FriendHayoCell.swift
//  Sheep
//
//  Created by mono on 8/8/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
class FriendHayoCell: SWTableViewCell {
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profileImageButtonWidthConstraint: NSLayoutConstraint!
    private var _originalWidth: CGFloat = 0.0
    private var profileButtonDidTapHandler: ((user: User) -> ())?
    
    func setHayo(hayo: Hayo, imageHidden: Bool, profileButtonDidTapHandler: ((user: User) -> ())?) {
        _hayo = hayo
        messageLabel.text = NSString(format: localize("HayoFriendMessageFormat"), _hayo.message)
        self.profileButtonDidTapHandler = profileButtonDidTapHandler
        
        profileImageButtonWidthConstraint.constant = imageHidden ? 0 : _originalWidth
        
        if imageHidden {
            return
        }
        
        profileImageButton.sd_setImageWithURL((NSURL(string: _hayo.from.imageURL)), forState: .Normal, completed: {image, error, type, url -> () in
        })
    }
    
    var _hayo: Hayo! = nil
    var hayo: Hayo! {
        get {
            return _hayo
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageButton.configureAsMyCircle()
        self.rightUtilityButtons = rightButtons()
        profileImageButton.imageView.contentMode = .ScaleAspectFill;
    }
    
    func rightButtons() -> NSArray {
        _originalWidth = profileImageButtonWidthConstraint.constant
        var buttons = NSMutableArray()
        buttons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: localize("Dame"))
        buttons.sw_addUtilityButtonWithColor(UIColor.blueColor(), title: localize("OK"))
        return buttons
    }
    @IBAction func profileButtonDidTap(sender: UIButton) {
        profileButtonDidTapHandler?(user: _hayo.from)
    }
}