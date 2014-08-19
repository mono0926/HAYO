 //
//  Hayo.swift
//  Sheep
//
//  Created by mono on 8/8/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation

class Hayo {
    var source: PFObject
        
    init(source: PFObject) {
        self.source = source
    }
    
    var message: String {
        get{
        return source.objectForKey("message") as String
    }
    }
    var fromUser: PFUser { get { return self.source.objectForKey("from") as PFUser }}
    var toUser: PFUser { get { return self.source.objectForKey("to") as PFUser }}
    
    func getFriendMessage(completed: (message:String) -> ()) {
        
        self.getMessage(false, completed: completed)
    }
    
    func getMyMessage(completed: (message: String) -> ()) {
        self.getMessage(true, completed: completed)
    }
    
    private func getMessage(mine: Bool, completed: (message:String) -> ()) {
        let user = self.fromUser
        user.fetchIfNeededInBackgroundWithBlock(){ a in
            let result = mine ? NSString(format: localize("HayoMyMessageFormat"), self.message, user.username):
                NSString(format: localize("HayoFriendMessageFormat"), user.username, self.message)
            completed(message: result)
        }
    }
    
    func getImageURL(completed: (url: String) -> ()) {
        let user = source.objectForKey("from") as PFUser
        user.fetchIfNeededInBackgroundWithBlock(){ result, error in
            completed(url: user.getImageURL())
        }
    }
}