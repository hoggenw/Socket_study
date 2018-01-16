//
//  YLMQTTManager.h
//  YLScoketTest
//
//  Created by 王留根 on 17/2/17.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol receiveMessageDelegate<NSObject>

- (void)receiveMessage:(NSString *)message;

@end

@interface YLMQTTManager : NSObject

@property (nonatomic, weak)id<receiveMessageDelegate> delegate;

+ (instancetype)shareManager ;

- (void)connect;

- (void)disConnnect;

- (void)sendMessage:(NSString *)message;

@end
