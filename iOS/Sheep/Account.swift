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
    @NSManaged
    var nickname: String
    @NSManaged
    var imageData: NSData
    
    var image: UIImage {
        get {
        return UIImage(data: imageData)
    }
    }
    
    
    class func instance() -> Account! {
        if Account.MR_countOfEntities() == 0 {
            return nil
        }
        return Account.MR_findFirst() as Account
    }
    
    class func createAsync(nickname: String, imageURL: String, image: UIImage, completed: (success: Bool) -> ()) {
        dispatchAsync(.High) {
            let installation = PFInstallation.currentInstallation()
            let user = PFUser.currentUser()
            installation["user"] = user
            installation.save()
            // TODO: エラー処理
            user.nickname = nickname
            user.imageURL = imageURL
            user.save()
            let account = Account.MR_createEntity() as Account
            account.username = user.username
            account.nickname = nickname
            let imageData = NSData(data: UIImageJPEGRepresentation(image, 1))
            account.imageData = imageData
            account.saveSync()
            dispatchOnMainThread() {
                completed(success: true)
            }
        }
    }
}

extension PFUser {
    var nickname: String {
    set {
        self.setObject(newValue, forKey: "nickname")
    }
    get {
        return self.objectForKey("nickname") as String
    }
    }
    var imageURL: String {
    set {
        self.setObject(newValue, forKey: "imageURL")
    }
    get {
        return self.objectForKey("imageURL") as String
    }
    }
    func getImageURL() -> String {
        return self.imageURL
    }
}