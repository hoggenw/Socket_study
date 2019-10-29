//
//  YLThread.h
//  iOSProject
//
//  Created by 王留根 on 2019/6/19.
//  Copyright © 2019 hoggenWang.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLThread : NSObject

+ (NSThread *)networkRequestThreadName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
