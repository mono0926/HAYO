//
//  SNSClient.swift
//  Sheep
//
//  Created by mono on 7/29/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
import PromiseKit
class ParseClient {
    class var sharedInstance : ParseClient {
    struct Static {
        static let instance = ParseClient()
        }
        return Static.instance
    }
    
    func hayo(user: User, message: String, category: String) -> Promise<String> {
        let me = Account.instance()        
        return PFCloud.promise("hayo", parameters: ["fromId": me.parseObjectId, "toId": user.parseObjectId, "message": message, "category": category])
    }
    
    func searchFriends(facebookIds: [String], twitterIds: [String]) -> Promise<[PFUser]> {
        
        return PFCloud.promise("searchFriends", parameters: ["facebookIds": facebookIds, "twitterIds": twitterIds])
            .then { (users: [PFUser]) -> [PFUser] in
                return users.filter() { u in
                    let friendParseIds = (User.MR_findAll() as [User]).map() { u in return u.parseObjectId } as [String]
                    return !contains(friendParseIds, u.objectId)
                    } as [PFUser]
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