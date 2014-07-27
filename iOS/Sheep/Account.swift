//
//  Account.swift
//  Sheep
//
//  Created by mono on 7/25/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation

class Account: NSManagedObject {
    class func MR_entityName() -> String {
        return "Account"
    }
    
    @NSManaged
    var username: String
}