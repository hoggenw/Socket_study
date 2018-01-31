//
//  UIResponder+Extension.m
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/30.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "UIResponder+Extension.h"

@implementation UIResponder (Extension)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}

@end
