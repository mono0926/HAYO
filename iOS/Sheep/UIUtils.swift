//
//  ViewUtils.swift
//  Sheep
//
//  Created by mono on 7/29/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
import QuartzCore

extension UIViewController {
    func configureBackgroundTheme() {       
        
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        let startColor = UIColor(hue: 162/360.0, saturation: 0.67, brightness: 0.82, alpha: 1).CGColor
        let endColor = UIColor(hue: 205/360.0, saturation: 0.76, brightness: 0.93, alpha: 1).CGColor
        gradient.colors = NSArray(objects: startColor, endColor)
        self.view.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    func designButton(button: UIButton) {        
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
    }
    
    func localize(key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}