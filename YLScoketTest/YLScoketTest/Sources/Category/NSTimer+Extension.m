//
//  NSTimer+Extension.m
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "NSTimer+Extension.h"

@implementation NSTimer (Extension)

- (void)pauseTimer{
    if ([self isValid]) {
        [self setFireDate:[NSDate distantFuture]];
    }
}

- (void)resumeTimer{
    if ([self isValid]) {
        [self setFireDate:[NSDate date]];
    }
}

- (void)resumeTimerAfterInterval:(NSTimeInterval)interval{
    if ([self isValid]) {
        [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
    }
}

@end
