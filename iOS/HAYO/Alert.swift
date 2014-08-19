//
//  Alert.swift
//  MagoCamera
//
//  Created by mono on 8/16/14.
//  Copyright (c) 2014 mono. All rights reserved.
//

import Foundation

struct TitleAction {
    var title: String
    var action: () -> ()
    init(title: String, action: () -> () = {}) {
        self.title = title
        self.action = action
    }
}

class Alert: NSObject, UIAlertViewDelegate {
    
    var cancelBlockOld: (() -> ())?
    var okBlockOld: (() -> ())!
    
    class var sharedInstance : Alert {
    struct Static {
        static let instance = Alert()
        }
        return Static.instance
    }
    
    // MARK: alert view
    func showAlertView(sourceViewController: UIViewController, title: String, message: String, okBlock: () -> (), cancelBlock: (() -> ())?) {
        if NSClassFromString("UIAlertController") != nil {
            showAlertViewImpl(sourceViewController, title: title, message: message, okBlock: okBlock, cancelBlock: cancelBlock)
            return
        }
        showAlertViewImplOld(sourceViewController, title: title, message: message, okBlock: okBlock, cancelBlock: cancelBlock)
    }
    
    private func showAlertViewImpl(sourceViewController: UIViewController, title: String, message: String, okBlock: () -> (), cancelBlock: (() -> ())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: okString, style: .Default) { action in
            okBlock()
            })
        if let cancel = cancelBlock {
            alert.addAction(UIAlertAction(title: cancelString, style: .Cancel) { action in
                cancel()
                })
        }
        sourceViewController.presentViewController(alert, animated: true) { }
    }
    
    private func showAlertViewImplOld(sourceViewController: UIViewController, title: String, message: String, okBlock: () -> (), cancelBlock: (() -> ())?) {
        self.okBlockOld = okBlock
        self.cancelBlockOld = cancelBlock
        let alert = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: cancelBlock == nil ? nil : cancelString, otherButtonTitles: okString)
        alert.show()
    }
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        if cancelBlockOld != nil && buttonIndex == 0 {
            cancelBlockOld?()
            return
        }
        okBlockOld()
    }
    
    func alertViewCancel(alertView: UIAlertView!) {
        cancelBlockOld?()
    }
    
    // MARK: action sheet
    func showActionSheet(sourceViewController: UIViewController, title: String, normalButtonActions: [TitleAction] = [], destructiveTitleAction: TitleAction? = nil, cancelBlock: () -> () = {}) {
        if NSClassFromString("UIAlertController") != nil {
            self.showActionSheetImpl(sourceViewController, title: title, normalButtonActions: normalButtonActions, destructiveTitleAction: destructiveTitleAction, cancelBlock: cancelBlock)
            return
        }
        self.showActionSheetImplOld(sourceViewController, title: title, normalButtonActions: normalButtonActions, destructiveTitleAction: destructiveTitleAction, cancelBlock: cancelBlock)
    }
    
    private func showActionSheetImpl(sourceViewController: UIViewController, title: String, normalButtonActions: [TitleAction] = [], destructiveTitleAction: TitleAction? = nil, cancelBlock: () -> () = {}) {
        let sheet = UIAlertController(title: nil, message: title, preferredStyle: .ActionSheet)
        
        for normal in normalButtonActions {
            sheet.addAction(UIAlertAction(title: normal.title, style: .Default, handler: { action in
                normal.action()
            }))
        }
        if let destructive = destructiveTitleAction {
            sheet.addAction(UIAlertAction(title: destructive.title, style: .Destructive, handler: { action in
                destructive.action()
            }))
        }
        sheet.addAction(UIAlertAction(title: cancelString, style: .Cancel, handler: { action in
            cancelBlock()
        }))
        sourceViewController.presentViewController(sheet, animated: true) { }
    }
    
    private func showActionSheetImplOld(sourceViewController: UIViewController, title: String, normalButtonActions: [TitleAction] = [], destructiveTitleAction: TitleAction? = nil, cancelBlock: () -> () = {}) {
        let sheet = UIActionSheet.bk_actionSheetWithTitle(title) as UIActionSheet
        
        for normal in normalButtonActions {
            sheet.bk_addButtonWithTitle(normal.title) {
                normal.action()
            }
        }
        if let destructive = destructiveTitleAction {
            sheet.bk_setDestructiveButtonWithTitle(destructive.title) {
                destructive.action()
            }
        }
        sheet.bk_setCancelButtonWithTitle(cancelString) {
            cancelBlock()
        }
        sheet.showInView(UIApplication.sharedApplication().delegate.window!)
    }
}