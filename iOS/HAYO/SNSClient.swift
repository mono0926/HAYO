//
//  SNSClient.swift
//  Sheep
//
//  Created by mono on 7/29/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
class ParseClient {
    class var sharedInstance : ParseClient {
    struct Static {
        static let instance = ParseClient()
        }
        return Static.instance
    }
    
    func hayo(user: User, message: String, completed: (success: Bool, error: NSError!) -> ()) {
        
        let me = PFUser.currentUser()
        
        PFCloud.callFunctionInBackground("hayo", withParameters: ["fromId": me.objectId, "toId": user.parseObjectId, "message": message], block: { result, error in
            completed(success: true, error: error)
        })
    }
    
    func searchFriends(mails: [String], screenNames: [String], completed: (users: [PFUser], error: NSError!) -> ()) {
        PFCloud.callFunctionInBackground("searchFriends", withParameters: ["mails": mails, "screenNames": screenNames]) { result, error in
            let users = result as [PFUser]
            completed(users: users, error: error)
        }
    }
    
    func makeFriends(users: [PFUser], completed: (success: Bool, error: NSError!) -> ()) {
        let me = PFUser.currentUser()
        let toIds = users.map { u in
            return u.objectId
        } as [String]
        PFCloud.callFunctionInBackground("makeFriends", withParameters: ["fromId": me.objectId, "toIds": toIds], block: { result, error in
            completed(success: true, error: error)
        })
    }
    
    func friendList(completed: (friendList: [PFUser], error: NSError!) -> ()) {
        let me = PFUser.currentUser()
        println(me.objectId)
        PFCloud.callFunctionInBackground("friendList", withParameters: ["userId": me.objectId], block: { result, error in
            let friendList = result as [PFUser]
            completed(friendList: friendList, error: error)
        })
    }
}