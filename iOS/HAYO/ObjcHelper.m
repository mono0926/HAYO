//
//  ObjcHelper.m
//  MagoCamera
//
//  Created by mono on 7/13/14.
//  Copyright (c) 2014 mono. All rights reserved.
//

#import "ObjcHelper.h"
#import "Aspects.h"
#import "HAYO-Swift.h"
@import UIKit;

@implementation ObjcHelper

+(NSString*)replace:(NSString*)input from:(NSString *)from to:(NSString *)to
{
    return [input stringByReplacingOccurrencesOfString:from withString:to];
}

+(void)applyAutoScreenTracking {
    [UIViewController aspect_hookSelector:@selector(viewDidAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        NSString* className = NSStringFromClass([aspectInfo.instance class]);
        [[AnalyticsUtil sharedInstance]trackScreen:className];
    } error:nil];
}

@end
