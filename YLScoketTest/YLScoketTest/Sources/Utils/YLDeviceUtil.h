//
//  YLDeviceUtil.h
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, PhoneType) {
    Phone4     = 0,
    Phone5     = 1,
    PhoneGreaterThan6     = 2,
    PhoneGreaterThan6Plus   = 3,
    PhoneX = 4,
    PhoneXPlus = 5,
    UnKown = 1000,
};

@interface YLDeviceUtil : NSObject

+ (PhoneType)getPhoneType;
+ (BOOL)isPhone4;
+ (BOOL)isPhone5;
+ (BOOL)isPhone6Up;
+ (BOOL)isPhone6UpPlus;
+ (BOOL)isPhoneX;
+ (BOOL)isPhoneXPlus;
+ (NSString *)getSystemInfo;
+ (NSString *)getAPPVersion;
@end
