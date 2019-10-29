//
//  YLThread.m
//  iOSProject
//
//  Created by 王留根 on 2019/6/19.
//  Copyright © 2019 hoggenWang.com. All rights reserved.
//

#import "YLThread.h"
#include <pthread.h>
#import <libkern/OSAtomic.h>

@implementation YLThread


+ (void)networkRequestThreadEntryPoint:(NSString *) name {
    @autoreleasepool {
        [[NSThread currentThread] setName:name];
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        // 这里主要是监听某个 port，目的是让这个 Thread 不会回收
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

+ (NSThread *)networkRequestThreadName:(NSString *)name {
    static NSThread *_networkRequestThread = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _networkRequestThread =
        [[NSThread alloc] initWithTarget:self
                                selector:@selector(networkRequestThreadEntryPoint:)
                                  object:name];
        [_networkRequestThread start];
    });
    return _networkRequestThread;
}

@end
