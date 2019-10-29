//
//  UIViewController+Extension.m
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

+ (UIViewController *)topController {
    for (UIWindow *window in [[[UIApplication sharedApplication]windows] reverseObjectEnumerator]) {
        if ([window isKindOfClass:[UIWindow class]] &&
            window.windowLevel == UIWindowLevelNormal &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds)) {
            UIViewController *topController = window.rootViewController;
            while (topController.presentedViewController) {
                topController = topController.presentedViewController;
            }
            return topController;
        }
    }
    return nil;
}

@end
