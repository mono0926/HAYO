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
    @NSManaged var replies: NSSet
    
    var orderedReply: [HayoReply] {
        get {
            let sort = NSSortDescriptor(key: "at", ascending: false)
            return replies.sortedArrayUsingDescriptors([sort]) as [HayoReply]
        }
    }
    
    class func fetchHayoList(fromUser: User, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        let me = Account.instance()
        let predicate = NSPredicate(format: "(from == %@ AND to == %@) OR (from == %@ AND to == %@)", fromUser, me, me, fromUser)
        return Hayo.MR_fetchAllSortedBy("at", ascending: false, withPredicate: predicate, groupBy: nil, delegate: delegate)
    }
    
    class func fetchHayoList(delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        let me = Account.instance()
        let predicate = NSPredicate(format: "from == %@ OR to == %@", me, me)
        return Hayo.MR_fetchAllSortedBy("at", ascending: false, withPredicate: predicate, groupBy: nil, delegate: delegate)
    }
    
    class func updateHayoList(fromUser: User, completed: () -> ()) {
        ParseClient.sharedInstance.hayoList(fromUser).then { hayoList in
            dispatchAsync(.High) {
                
                
                let moc = NSManagedObjectContext.MR_contextForCurrentThread()
                // TODO: 削除系
                for hayoObject in hayoList {
                    var hayo = Hayo.findByParseObjectId(hayoObject.objectId) as Hayo!
                    if hayo == nil {
                        hayo = Hayo.MR_createEntity() as Hayo!
                    }
                    hayo.updateWithPFObject(hayoObject)
                    let replies = hayoObject.objectForKey("replies") as PFRelation
                    let replyObjects =  replies.query().findObjects() as [PFObject]
                    for r in replyObjects {
                        var reply = HayoReply.findByParseObjectId(r.objectId) as HayoReply!
                        if reply == nil {
                            reply = HayoReply.MR_createEntity() as HayoReply!
                        }
                        reply.hayo = hayo
                        reply.updateWithPFObject(r)
                    }
                }
                moc.MR_saveToPersistentStoreAndWait()
                completed()
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