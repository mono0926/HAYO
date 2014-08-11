//
//  AnalyticsUtil.swift
//  HAYO
//
//  Created by mono on 8/10/14.
//  Copyright (c) 2014 Sheep. All rights reserved.
//

import Foundation

@objc
class AnalyticsUtil {
    
#if DEBUG
    let trackingId = "UA-53666587-2"
    let trackInterval: NSTimeInterval = 5
#else
    let trackingId = "UA-53666587-1"
    let trackInterval: NSTimeInterval = 120
#endif
    
    class var sharedInstance : AnalyticsUtil {
    struct Static {
        static let instance = AnalyticsUtil()
        }
        return Static.instance
    }
    
    func setup() {
        println("trackingId: \(trackingId), trackInterval: \(trackInterval)")
        GAI.sharedInstance().dispatchInterval = trackInterval
        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().trackerWithTrackingId(trackingId)
    }
    
    func trackScreen(name: String) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: name)
        tracker.send(GAIDictionaryBuilder.createScreenView().build())
    }
    
    func eventOccured(category: String, action: String, label: String? = nil) {
        let builder = GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: nil)
        GAI.sharedInstance().defaultTracker.send(builder.build())
    }
}