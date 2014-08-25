//
//  HayoReply.swift
//  HAYO
//
//  Created by mono on 8/25/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
class HayoReply: NSManagedObject {
    class func MR_entityName() -> String {
        return "HayoReply"
    }
    @NSManaged var message: String
    @NSManaged var parseObjectId: String
    @NSManaged var at: NSDate
    @NSManaged var hayo: Hayo
    
    
    func updateWithPFObject(object: PFObject) {
        self.at = object.createdAt
        self.message = object.objectForKey("message") as String
        self.parseObjectId = object.objectId
    }
}