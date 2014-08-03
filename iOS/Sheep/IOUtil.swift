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

extension UIImage {
    func resizedImage(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        self.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        let context = UIGraphicsGetCurrentContext()
        CGContextSetInterpolationQuality(context, kCGInterpolationHigh)
        UIGraphicsEndImageContext()
        return resized
    }
    
    func circularImage(diameter: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(diameter, diameter), false, 0)
        let context = UIGraphicsGetCurrentContext()
        let image = self
        let imageWidth = image.size.width
        let center = diameter/2
        let radius = diameter/2
        CGContextBeginPath(context)
        CGContextAddArc (context, center, center, radius, CGFloat(0), 2.0*CGFloat(M_PI), 0);
        CGContextClosePath (context);
        CGContextClip (context);
        let scaleFactor = diameter/imageWidth;
        CGContextScaleCTM (context, scaleFactor, scaleFactor);
        
        let myRect = CGRectMake(0, 0, imageWidth, imageWidth);
        image.drawInRect(myRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
    
    func borderedImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        
        self.drawInRect(CGRectMake(0, 0, size.width, size.height))
        
        let strokeWidth = CGFloat(1.0);
        let context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, strokeWidth);
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor);
        
        let radius = self.size.width/2;
        let rrect = CGRectMake(strokeWidth / 2, strokeWidth / 2, self.size.width - strokeWidth, self.size.height - strokeWidth);
        let width = CGRectGetWidth(rrect);
        let height = CGRectGetHeight(rrect);
        let minx = CGRectGetMinX(rrect);
        let midx = CGRectGetMidX(rrect);
        let maxx = CGRectGetMaxX(rrect);
        let miny = CGRectGetMinY(rrect);
        let midy = CGRectGetMidY(rrect);
        let maxy = CGRectGetMaxY(rrect);
        CGContextMoveToPoint(context, minx, midy);
        CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
        CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
        CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
        CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathStroke);
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
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