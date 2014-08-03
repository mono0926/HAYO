//
//  SNSClient.swift
//  Sheep
//
//  Created by mono on 7/29/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
class SNSClient {
    class var sharedInstance : SNSClient {
    struct Static {
        static let instance = SNSClient()
        }
        return Static.instance
    }
    
    func hayo(user: PFUser, message: String, completed: (success: Bool, error: NSError!) -> ()) {
        let userQuery = PFUser.query()
        userQuery.whereKey("username", equalTo: user.username)
//        let debug = userQuery.findObjects() as Array<PFUser>?
//        println(debug)
        let pushQuery = PFInstallation.query()
        pushQuery.whereKey("user", matchesQuery: userQuery)
        
        let push = PFPush()
        push.setQuery(pushQuery)
        let message = NSString(format: localize("HayoFormat"), Account.instance().nickname, message)
        let data = ["alert": message, "sound": "sheep.caf"]
        //        push.setMessage("(　´･‿･｀)")
        push.setData(data)
        push.sendPushInBackgroundWithBlock(completed)
    }
}