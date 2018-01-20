//
//  ChatListUserModel.h
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/19.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatListUserModel : NSObject

@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) int messageCount;
@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, assign) BOOL needHint;

@end
