//
//  IOUtil.swift
//  MagoCamera
//
//  Created by mono on 7/6/14.
//  Copyright (c) 2014 mono. All rights reserved.
//

import Foundation
import UIKit
import ImageIO
import CoreImage

func copyResource(resourceName: String, #targetName:String) -> String {
    let manager = NSFileManager.defaultManager()
    let filePath = getDocumentPath().stringByAppendingPathComponent(targetName)
    let resourcePath = NSBundle.mainBundle().pathForResource(resourceName, ofType:nil)
    manager.copyItemAtPath(resourcePath, toPath: filePath, error: nil)
    return filePath
}

func createUUID() -> String {
    return NSUUID.UUID().UUIDString
}

func getDocumentPath() -> String {
    return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
}

enum DispatchPriority : Int {
    case High = 0, Default, Low
}

func dispatchAsync(priority: DispatchPriority, block:() -> ()) {
    dispatch_async(dispatch_get_global_queue(priority.toRaw(), 0)) {
        block()
    }
}

func dispatchOnMainThread(block: () -> ()) {
    dispatch_async(dispatch_get_main_queue()) {
        block()
    }
}

extension NSURL {
    func saveTemporary() {
        let data = NSData(contentsOfURL: self)        
        data.saveTemporary(self.lastPathComponent)
    }
}

extension NSData {
    
    func saveTemporary(filename:String) {
        let tempPath = NSTemporaryDirectory().stringByAppendingString(filename)
        self.writeToFile(tempPath, atomically: true)
    }
    
    func saveToDocuments(filename:String) -> String? {
        let filePath = getDocumentPath().stringByAppendingPathComponent(filename)
        if self.writeToFile(filePath, atomically: true) {
            return filePath
        }
        return nil
    }
}

extension NSDate {
    func year() -> Int {
        let components = NSCalendar.currentCalendar().components(.CalendarUnitYear, fromDate: self)
        return components.year
    }
    func month() -> Int {
        let components = NSCalendar.currentCalendar().components(.CalendarUnitMonth, fromDate: self)
        return components.month
    }
}



class FormatterUtil {
    class var exifDateFormatter:NSDateFormatter {
        get {
            struct Static {
                static var onceToken : dispatch_once_t = 0
                static var instance : NSDateFormatter? = nil
            }
            dispatch_once(&Static.onceToken) {
                var formatter = NSDateFormatter();
                formatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
                Static.instance = formatter
            }
            return Static.instance!
    }
    }
    class var fileNameDateFormatter:NSDateFormatter {
        get {
            struct Static {
                static var onceToken : dispatch_once_t = 0
                static var instance : NSDateFormatter? = nil
            }
            dispatch_once(&Static.onceToken) {
                var formatter = NSDateFormatter();
                formatter.dateFormat = "yyyyMMddHHmmss"
                Static.instance = formatter
            }
            return Static.instance!
    }
    }
    /*
    class var monthDateHourMinFormatter: NSDateFormatter {
        get {
            struct Static {
                static var onceToken : dispatch_once_t = 0
                static var instance : NSDateFormatter? = nil
            }
        
            dispatch_once(&Static.onceToken) {
                var formatter = NSDateFormatter();
                formatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
                Static.instance = formatter
            }
            return Static.instance!
        }
    }
    
    class var is24Mode: NSNumber {
        get {
            struct Static {
                static var onceToken : dispatch_once_t = 0
                static var instance : NSNumber? = nil
            }
            
            dispatch_once(&Static.onceToken) {
                var formatter = NSDateFormatter();
                formatter.locale = NSLocale.currentLocale();
                formatter.dateStyle = .NoStyle;
                formatter.timeStyle = .ShortStyle;
                let dateString = formatter.stringFromDate(NSDate())
                let amRange = dateString.rangeOfString(formatter.AMSymbol)
                let pmRange = dateString.rangeOfString(formatter.PMSymbol)
                Static.instance = amRange.startIndex == NSNotFound && pmRange.startIndex == NSNotFound;
            }
            return Static.instance!
    }
    }
*/
}

extension NSManagedObject {
    func saveSync() {
        self.managedObjectContext.MR_saveToPersistentStoreAndWait()
    }
}