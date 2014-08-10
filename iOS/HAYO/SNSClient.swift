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
        
        let me = PFUser.currentUser()
        
        PFCloud.callFunctionInBackground("hayo", withParameters: ["from": me.username, "to": user.username, "message": message], block: { result, error in
            completed(success: true, error: error)
        })
    }
}