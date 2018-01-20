//
//  YLDeviceUtil.m
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "YLDeviceUtil.h"
#import <sys/utsname.h>

@implementation YLDeviceUtil


+ (PhoneType)getPhoneType {
    PhoneType type = UnKown;

    return type;
}

+ (BOOL)isPhone4 {
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);
    return width <= 320 && height <= 480;
}

+ (BOOL)isPhone5 {
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);
    return width <= 320 && height > 480;
}

+ (BOOL)isPhone6Up {
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    return width > 320 && width < 414;
}

+ (BOOL)isPhone6UpPlus {
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    return width >= 414;
}

+ (BOOL)isPhoneX {
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);
    return width > 320 && width < 414 && height > 667;
}
+ (BOOL)isPhoneXPlus {
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);
    return width >= 414 && height > 736;
}

+ (NSString *)getSystemInfo
{
    static NSString *str = nil;
    if(str)
    {
        return str;
    }
    
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    NSString * iPhoneM = [[UIDevice currentDevice] systemName];
    
    str = [NSString stringWithFormat:@"2_%@_%@_%@", phoneVersion, platform, iPhoneM];
    return str;
}

+ (NSString *)getAPPVersion
{
    static NSString *version = nil;
    if(version)
    {
        return version;
    }
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    version = [infoDic objectForKey:@"CFBundleVersion"];
    return version;
}
@end
