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
    func loginToFacebook(completed: (user: TypedFacebookUser?) -> ()) {
        // TODO: permissions
        let permissions = ["user_about_me", "user_relationships", "user_birthday", "user_location"]
        PFFacebookUtils.logInWithPermissions(permissions, block: {user, error in
            if !user {
                if !error {
                    println("Uh oh. The user cancelled the Facebook login.")
                    completed(user: nil)
                    return;
                }
                println("Uh oh. An error occurred: %@", error)
                completed(user: nil)
                return
            }
            if user.isNew {
                println("user.isNew, user: %@", user)
            } else {
                println("User with facebook logged in!, user: %@", user)
            }
            FBRequestConnection.startForMeWithCompletionHandler({ connection, result, error in
                let facebookUser = TypedFacebookUser(data: result)
                completed(user: facebookUser)
                })
    })
    }
}