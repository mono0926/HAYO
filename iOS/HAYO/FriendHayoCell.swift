//
//  FriendHayoCell.swift
//  Sheep
//
//  Created by mono on 8/8/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
class FriendHayoCell: SWTableViewCell, SWTableViewCellDelegate {
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profileImageButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var atLabel: UILabel!
    private var _originalWidth: CGFloat = 0.0
    private var profileButtonDidTapHandler: ((user: User) -> ())!
    private var rightButtonsDidTapHandler: ((index: Int, message: String) -> ())!
    
    func setHayo(hayo: Hayo, imageHidden: Bool, profileButtonDidTapHandler: ((user: User) -> ())?, rightButtonsDidTapHandler: (index: Int, message: String) -> ()) {
        _hayo = hayo
        atLabel.text = _hayo.at.monthDateHourMinFormatString()
        messageLabel.text = NSString(format: localize("HayoFriendMessageFormat"), _hayo.message)
        self.profileButtonDidTapHandler = profileButtonDidTapHandler
        self.rightButtonsDidTapHandler = rightButtonsDidTapHandler
        
        profileImageButtonWidthConstraint.constant = imageHidden ? 0 : _originalWidth
        
        if imageHidden {
            return
        }
        
        profileImageButton.sd_setImageWithURL((NSURL(string: _hayo.from.imageURL)), forState: .Normal, completed: {image, error, type, url -> () in
        })
    }
    
    private var _hayo: Hayo! = nil
    var hayo: Hayo! {
        get {
            return _hayo
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        profileImageButton.configureAsMyCircle()
        rightUtilityButtons = rightButtons()
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
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        rightButtonsDidTapHandler(index: index, message: "OK")
        self.hideUtilityButtonsAnimated(true)
    }
}