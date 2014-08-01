//
//  ViewUtils.swift
//  Sheep
//
//  Created by mono on 7/29/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
import QuartzCore

let themeColor = UIColor(red: 62/255.0, green: 182/255.0, blue: 208/255.0, alpha: 1)

extension UIViewController {
    func configureBackgroundTheme() {       
        self.view.configureBackgroundTheme()
    }
    
    func designButton(button: UIButton) {        
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
    }
    
    func localize(key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    func appDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }
}

extension UIView {
    func configureBackgroundTheme() {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        let startColor = UIColor(hue: 162/360.0, saturation: 0.67, brightness: 0.82, alpha: 1).CGColor
        let endColor = UIColor(hue: 205/360.0, saturation: 0.76, brightness: 0.93, alpha: 1).CGColor
        gradient.colors = NSArray(objects: startColor, endColor)
        layer.insertSublayer(gradient, atIndex: 0)
    }
    func configureAsCircle() {
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
}