//
//  NotificationManager.swift
//  HAYO
//
//  Created by mono on 8/11/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation
class NotificationManager {
    class var sharedInstance : NotificationManager {
    struct Static {
        static let instance = NotificationManager()
        }
        return Static.instance
    }
    
    func setup() {
        
        let app = UIApplication.sharedApplication()
        if !app.respondsToSelector("registerUserNotificationSettings:") {
            let myTypes: UIRemoteNotificationType = .Badge | .Alert | .Sound;
            app.registerForRemoteNotificationTypes(myTypes)
            return
        }
        
        
        let dameAction = UIMutableUserNotificationAction()
        dameAction.identifier = "A1"
        dameAction.title = "ダメです"
        dameAction.destructive = true
        dameAction.activationMode = .Background
        dameAction.authenticationRequired = false
        
        let okAction = UIMutableUserNotificationAction()
        okAction.identifier = "A2"
        okAction.title = "d( ´･‿･｀)"
        okAction.destructive = false
        okAction.activationMode = .Background
        okAction.authenticationRequired = false
        
        
        let category = UIMutableUserNotificationCategory()
        category.identifier = "HAYO"
        
        category .setActions([dameAction, okAction], forContext: .Default)
        category .setActions([dameAction, okAction], forContext: .Minimal)
        
        let categories = NSSet(array: [category])
        let types: UIUserNotificationType = .Badge | .Sound | .Alert
        let settings = UIUserNotificationSettings(forTypes: types, categories:categories);
        
        app.registerUserNotificationSettings(settings)
    }
    
    func notify() {
        let notification = UILocalNotification()
        notification.fireDate = NSDate()
        notification.alertBody = "進捗どうですか？"
        notification.timeZone = NSTimeZone.localTimeZone()
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.category = "HAYO"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}