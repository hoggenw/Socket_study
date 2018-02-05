//
//  YLSocketRocktManager.h
//  YLScoketTest
//
//  Created by 王留根 on 17/2/16.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChatMessageModel;

@class YLmessageModel;

@protocol receiveMessageDelegate<NSObject>

- (void)receiveMessage:(YLmessageModel *)message;

@end

@interface YLSocketRocktManager : NSObject


@property (nonatomic, weak)id<receiveMessageDelegate> delegate;

+ (instancetype)shareManger;

- (void)connect;

- (void)disconnnet;

-(void)sendMassege:(ChatMessageModel *)messageModel ;

- (void)ping;

@end
