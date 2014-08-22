 //
//  Hayo.swift
//  Sheep
//
//  Created by mono on 8/8/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation

 class Hayo: NSManagedObject {
    class func MR_entityName() -> String {
        return "Hayo"
    }
    @NSManaged var message: String
    @NSManaged var parseObjectId: String
    @NSManaged var at: NSDate
    @NSManaged var imageURL: String
    @NSManaged var from: User
    @NSManaged var to: User
    
    class func fetchHayoList(fromUser: User, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        let predicate = NSPredicate(format: "fromUser == %@ AND toUser == %@", fromUser, Account.instance())
        return Hayo.MR_fetchAllSortedBy("at", ascending: false, withPredicate: nil, groupBy: nil, delegate: delegate)
    }
    
    class func fetchHayoList(delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        let me = Account.instance()
        let predicate = NSPredicate(format: "fromUser == %@ OR toUser == %@", me, me)
        return Hayo.MR_fetchAllSortedBy("at", ascending: false, withPredicate: nil, groupBy: nil, delegate: delegate)
    }
    
    class func updateHayoList(fromUser: User) {
        ParseClient.sharedInstance.hayoList(fromUser) { hayoList, error in
            dispatchAsync(.High) {
                let moc = NSManagedObjectContext.MR_contextForCurrentThread()
                // TODO: 削除系
                for hayoObject in hayoList {
                    var hayo = Hayo.findByParseObjectId(hayoObject.objectId) as Hayo?
                    if hayo == nil {
                        hayo = Hayo.MR_createEntity() as Hayo?
                    }
                    hayo?.updateWithPFObject(hayoObject)
                }
                moc.MR_saveToPersistentStoreAndWait()
            }
        }
    }
    
    class func updateHayoList() {
        ParseClient.sharedInstance.hayoList() { hayoList, error in
            dispatchAsync(.High) {
                let moc = NSManagedObjectContext.MR_contextForCurrentThread()
                // TODO: 削除系
                for hayoObject in hayoList {
                    var hayo = Hayo.findByParseObjectId(hayoObject.objectId) as Hayo?
                    if hayo == nil {
                        hayo = Hayo.MR_createEntity() as Hayo?
                    }
                    hayo?.updateWithPFObject(hayoObject)
                }
                moc.MR_saveToPersistentStoreAndWait()
            }
        }
    }
    
    func updateWithPFObject(object: PFObject) {
        self.at = object.createdAt
        self.message = object.objectForKey("message") as String
        self.parseObjectId = object.objectId
        let fromPFUser = object.objectForKey("from") as PFUser
        self.from = User.findByParseObjectId(fromPFUser.objectId)! as User
        let toPFUser = object.objectForKey("to") as PFUser
        println(toPFUser.objectId)
        self.to = User.findByParseObjectId(toPFUser.objectId)! as User
    }
}