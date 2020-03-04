//
//  ChatListUserModel.h
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/19.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatListUserModel : NSObject
//聊天对象的id
@property (nonatomic, strong) NSString *userId;
//e聊天对象的昵称或者备注名
@property (nonatomic, strong) NSString *name;
//e聊天的时间
@property (nonatomic, strong) NSDate *date;

//message聊天的最后一条消息
@property (nonatomic, strong) NSString *message;
//需要提醒的消息条数
@property (nonatomic, assign) int messageCount;
//聊天对象头像的连接
@property (nonatomic, strong) NSString *avatar;
//needHint是否需要提醒
@property (nonatomic, assign) BOOL needHint;

@end
