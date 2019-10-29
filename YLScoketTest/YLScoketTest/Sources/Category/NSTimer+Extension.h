//
//  NSTimer+Extension.h
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Extension)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterInterval:(NSTimeInterval)interval;

@end
