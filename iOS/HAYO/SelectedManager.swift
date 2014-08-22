//
//  SelectedManager.swift
//  HAYO
//
//  Created by mono on 8/22/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
class SelectedManager {
    var set = NSMutableSet()
    
    func toggle(obj: AnyObject) -> Bool {
        if isSelected(obj) {
            set.removeObject(obj)
            return false
        }
        set.addObject(obj)
        return true
    }
    
    func isSelected(obj: AnyObject) -> Bool {
        return set.containsObject(obj)
    }
}