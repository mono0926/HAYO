//
//  ObjcHelper.h
//  MagoCamera
//
//  Created by mono on 7/13/14.
//  Copyright (c) 2014 mono. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjcHelper : NSObject
+(void)registerRemoteNotification;
+(void)registerRemoteNotificationForIOS8;
+(NSString*)parseApplicationId;
+(NSString*)parseClientKey;
@end
