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
    
    func hayo(user: User, message: String, category: String, completed: (success: Bool, error: NSError!) -> ()) {
        let me = Account.instance()
        
        PFCloud.callFunctionInBackground("hayo", withParameters: ["fromId": me.parseObjectId, "toId": user.parseObjectId, "message": message, "category": category], block: { result, error in
            completed(success: true, error: error)
        })
    }


    
    func reply(hayo: Hayo, message: String, completed: (success: Bool, error: NSError!) -> ()) {
        let me = Account.instance()
        
        PFCloud.callFunctionInBackground("reply", withParameters:  ["hayoId": hayo.parseObjectId, "message": message], block: { result, error in
            completed(success: true, error: error)
        })
    }
    
    func searchFriends(facebookIds: [String], twitterIds: [String], completed: (users: [PFUser], error: NSError!) -> ()) {
        PFCloud.callFunctionInBackground("searchFriends", withParameters: ["facebookIds": facebookIds, "twitterIds": twitterIds]) { result, error in
            let users = result as [PFUser]
            let friendParseIds = (User.MR_findAll() as [User]).map() { u in return u.parseObjectId } as [String]
            let filtered = users.filter() { u in
                return !contains(friendParseIds, u.objectId)
            } as [PFUser]
            completed(users: filtered, error: error)
        }
    }
    
    func makeFriends(users: [PFUser], completed: (success: Bool, error: NSError!) -> ()) {
        let me = Account.instance()
        let toIds = users.map { u in
            return u.objectId
        } as [String]
        PFCloud.callFunctionInBackground("makeFriends", withParameters: ["fromId": me.parseObjectId, "toIds": toIds], block: { result, error in
            completed(success: true, error: error)
        })
    }
    
    func friendList(completed: (friendList: [PFUser], error: NSError!) -> ()) {
        let me = Account.instance()
        println(me.parseObjectId)
        PFCloud.callFunctionInBackground("friendList", withParameters: ["userId": me.parseObjectId], block: { result, error in
            let friendList = result as [PFUser]
            completed(friendList: friendList, error: error)
        })
    }
    
    func hayoList(fromUser: User, completed: (hayoList: [PFObject], error: NSError!) -> ()) {
        let me = Account.instance()
        PFCloud.callFunctionInBackground("hayoList", withParameters: ["fromId": fromUser.parseObjectId, "toId": me.parseObjectId], block: { result, error in
            completed(hayoList: result as [PFObject], error: error)
        })
    }
    
    func hayoList(completed: (hayoList: [PFObject], error: NSError!) -> ()) {
        let me = Account.instance()
        PFCloud.callFunctionInBackground("hayoListAll", withParameters: ["userId": me.parseObjectId], block: { result, error in
            completed(hayoList: result as [PFObject], error: error)
        })
    }
}