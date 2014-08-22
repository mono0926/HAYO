//
//  User.swift
//  HAYO
//
//  Created by mono on 8/22/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
class User: NSManagedObject {
    class func MR_entityName() -> String {
        return "User"
    }
    
    @NSManaged var parseObjectId: String
    @NSManaged var username: String
    @NSManaged var imageURL: String
    @NSManaged var sentHayos: NSSet
    @NSManaged var receivedHayos: NSSet
    
    var image: UIImage? { get { return nil } }
    
    class func fetchUserList(delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        return User.MR_fetchAllSortedBy("username", ascending: true, withPredicate: nil, groupBy: nil, delegate: delegate)
    }
    
    class func updateUsers() {
        ParseClient.sharedInstance.friendList() { friendList, error in
            dispatchAsync(.High) {
                
                let moc = NSManagedObjectContext.MR_contextForCurrentThread()
                
                let locals = NSMutableSet(array: (User.MR_findAll() as [User]).map() { u in return u.parseObjectId } as [String])
                println(friendList)
                let parses = NSSet(array: friendList.map() { u in
                    println(u)
                    return u.objectId
                    } as [String])
                locals.minusSet(parses)
                
                for objid in locals {
                    let id = objid as String
                    if id == PFUser.currentUser().objectId {
                        continue
                    }
                    let local = self.findByParseObjectId(id)!
                    moc.deleteObject(local)
                }
                
                for friend in friendList {
                    var user = self.findByParseObjectId(friend.objectId) as User?
                    if user == nil {
                        user = User.MR_createEntity() as User?
                    }
                    user?.updateWithPFUser(friend)
                }
                moc.MR_saveToPersistentStoreAndWait()
            }
        }
    }

    func updateWithPFUser(user: PFUser) {
        self.parseObjectId = user.objectId
        self.username = user.username
        self.imageURL = user.getImageURL()
    }
}