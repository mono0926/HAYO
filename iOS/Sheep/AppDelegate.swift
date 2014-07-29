//
//  AppDelegate.swift
//  Sheep
//
//  Created by mono on 7/24/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow!
    var player: AVAudioPlayer?


    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        AFNetworkActivityIndicatorManager.sharedManager().enabled = true
        Parse.setApplicationId(ObjcHelper.parseApplicationId(), clientKey: ObjcHelper.parseClientKey())        
        PFFacebookUtils.initializeFacebook()
        PFTwitterUtils.initializeWithConsumerKey("YhUif46nJ7plXPW35wasVRLNH", consumerSecret: "lk95mJpSKThQSaujTagAyEZuQre2HbspOLP2e8MwrowYm37J98")
        
        MagicalRecord.setupCoreDataStack()
        ObjcHelper.registerRemoteNotification()
        application.statusBarStyle = .LightContent;
        
        window = UIWindow(frame:UIScreen.mainScreen().bounds)
        window.makeKeyAndVisible()
        navigate()
        
        Crashlytics.startWithAPIKey("d95b1c50531d0d17895fc1a2c84053145215f757")
        return true;
    }
    
    func navigate() {
        let sbName = Account.instance() ? "Main" : "Login";
        let vc = UIStoryboard(name: sbName, bundle: nil).instantiateInitialViewController() as UIViewController
        window.rootViewController = vc
    }

    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication!) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication!) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication!) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication!, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]!) {
        
        let notification = CWStatusBarNotification()
        let message = NSString(format: "%@ < HAYO!!", Account.instance().nickname)
        notification.displayNotificationWithMessage(message, forDuration: 5)
        let path = NSBundle.mainBundle().pathForResource("sheep", ofType: "caf")
        let url = NSURL(fileURLWithPath: path)
        player = AVAudioPlayer(contentsOfURL: url, error: nil)
        player!.play()
    }
    
    
    func application(application: UIApplication!, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData!)
    {
        let tokenId = deviceToken.description
        println("deviceToken: \(tokenId)")
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication!, didFailToRegisterForRemoteNotificationsWithError error: NSError!)
    {
        println("didFailToRegisterForRemoteNotificationsWithError")
    }
    
    func application(application: UIApplication!, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings!)
    {
        ObjcHelper.registerRemoteNotificationForIOS8()
//        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func application(application: UIApplication!, openURL url: NSURL!, sourceApplication: String!, annotation: AnyObject!) -> Bool {
        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication, withSession: PFFacebookUtils.session())
    }
    
    /*
    class func registerRemoteNotification() {
        let app = UIApplication.sharedApplication();
        if app.respondsToSelector("registerUserNotificationSettings:") {
            let settings = UIUserNotificationSettings(forTypes: .Badge | .Sound | .Alert, categories: nil)
            app.registerUserNotificationSettings(settings)
            return
        }
        let types: UIRemoteNotificationType = .Badge | .Sound | .Alert
        app.registerForRemoteNotificationTypes(types)
    }
    */
}

