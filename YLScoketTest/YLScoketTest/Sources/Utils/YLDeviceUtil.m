//
//  YLDeviceUtil.m
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "YLDeviceUtil.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import <Photos/Photos.h>


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
+(BOOL)isiPhoneXLater{
    if (@available(iOS 11.0, *)) {
        return UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom > 0.0 ? true : false;
    } else {
        return  false;
    }
}

+ (void)checkLibraryAuthorityWithCallBack:(AuthorizationStatusCallBack)callback
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status)
        {
            case PHAuthorizationStatusNotDetermined: break;
            case PHAuthorizationStatusRestricted:
            case PHAuthorizationStatusDenied:
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"权限受限" message:@"当前操作需要开启相册权限，请到设置页面开启" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *set = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:set];
                [alert addAction:cancel];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            }
                break;
            case PHAuthorizationStatusAuthorized:
            {
                if (callback)
                {
                    callback();
                }
            }
                break;
        }
    }];
}

+ (void)checkVideoAuthorityWithCallBack:(AuthorizationStatusCallBack)callback
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status)
    {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted)
                {
                    if (callback)
                    {
                        callback();
                    }
                }
            }];
        }
            break;
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"权限受限" message:@"当前操作需要开启相机权限，请到设置页面开启" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *set = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:set];
            [alert addAction:cancel];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }
            break;
        case AVAuthorizationStatusAuthorized:
        {
            if (callback)
            {
                callback();
            }
        }
            break;
    }
}

+ (void)checkMicroAuthorityWithCallBack:(AuthorizationStatusCallBack)callback
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status)
    {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
//                if (granted)
//                {
//                    if (callback)
//                    {
//                        callback();
//                    }
//                }
            }];
        }
            break;
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"权限受限" message:@"当前操作需要开启麦克风权限，请到设置页面开启" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *set = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:set];
            [alert addAction:cancel];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }
            break;
        case AVAuthorizationStatusAuthorized:
        {
            if (callback)
            {
                callback();
            }
        }
            break;
    }
}



@end
