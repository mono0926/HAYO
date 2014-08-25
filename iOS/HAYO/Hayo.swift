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
    @NSManaged var messageId: String
    @NSManaged var parseObjectId: String
    @NSManaged var at: NSDate
    @NSManaged var updatedAt: NSDate
    @NSManaged var imageURL: String
    @NSManaged var from: User!
    @NSManaged var to: User!
    @NSManaged var replies: NSSet
    
    var orderedReply: [HayoReply] {
        get {
            let sort = NSSortDescriptor(key: "at", ascending: false)
            return replies.sortedArrayUsingDescriptors([sort]) as [HayoReply]
        }
    }
    
    var message: HayoMessage { get { return HayoMessage(id: messageId) } }
    
    class func fetchHayoList(fromUser: User, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        let me = Account.instance()
        let predicate = NSPredicate(format: "(from == %@ AND to == %@) OR (from == %@ AND to == %@)", fromUser, me, me, fromUser)
        return Hayo.MR_fetchAllSortedBy("at", ascending: false, withPredicate: predicate, groupBy: nil, delegate: delegate)
    }
    
    class func fetchHayoList(delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        let me = Account.instance()
        let predicate = NSPredicate(format: "to == %@ AND from != %@", me, me)
        return Hayo.MR_fetchAllSortedBy("at", ascending: false, withPredicate: predicate, groupBy: nil, delegate: delegate)
    }
    
    class func updateHayoList(fromUser: User, completed: () -> ()) {
        ParseClient.sharedInstance.hayoList(fromUser) { hayoList, error in
            dispatchAsync(.High) {
                
                
                let moc = NSManagedObjectContext.MR_contextForCurrentThread()
                // TODO: 削除系
                for hayoObject in hayoList {
                    var hayo = Hayo.findByParseObjectId(hayoObject.objectId) as Hayo!
                    if hayo == nil {
                        hayo = Hayo.MR_createEntity() as Hayo!
                    }
                    hayo.updateWithPFObjectIfNeeded(hayoObject)
                }
                moc.MR_saveToPersistentStoreAndWait()
                completed()
            }
        }
    }
    
    func reply(replyId: String, completed: () -> ()) {
        let myObjectId = self.objectID
        ParseClient.sharedInstance.reply(self, messageId: replyId) { hayoObject, error in
            dispatchAsync(.High) {
                let moc = NSManagedObjectContext.MR_contextForCurrentThread()
                let hayo = moc.objectWithID(myObjectId) as Hayo
                hayo.updateWithPFObjectIfNeeded(hayoObject)
                hayo.saveSync()
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
                    hayo?.updateWithPFObjectIfNeeded(hayoObject)
                }
                moc.MR_saveToPersistentStoreAndWait()
            }
        }
    }
    
    func updateWithPFObjectIfNeeded(object: PFObject) {
        
        if self.updatedAt == object.updatedAt {
            return;
        }
        
        self.at = object.createdAt
        self.updatedAt = object.updatedAt
        self.messageId = object.objectForKey("messageId") as String
        self.parseObjectId = object.objectId
        if self.from == nil {
            let fromPFUser = object.objectForKey("from") as PFUser
            println(fromPFUser)
            println(fromPFUser.objectId)
            self.from = User.findByParseObjectId(fromPFUser.objectId)! as User
        }
        if self.to == nil {
            let toPFUser = object.objectForKey("to") as PFUser
            self.to = User.findByParseObjectId(toPFUser.objectId)! as User
        }
        self.updateRepliesIfNeeded(object)
    }
    
    func updateRepliesIfNeeded(hayoObject: PFObject) {
        
        let replies = hayoObject.objectForKey("replies") as PFRelation
        let replyObjects =  replies.query().findObjects() as [PFObject]
        println(replyObjects.count)
        for r in replyObjects {
            var reply = HayoReply.findByParseObjectId(r.objectId) as HayoReply!
            if reply == nil {
                reply = HayoReply.MR_createEntity() as HayoReply!
            }
            reply.hayo = self
            reply.updateWithPFObject(r)
        }
    }
}