//
//  ChatOtherUserModel.m
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/23.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "ChatOtherUserModel.h"
#import "ChatUserModel.h"

@implementation ChatOtherUserModel

-(instancetype)init {
    @throw [NSException exceptionWithName:@"单例类" reason:@"不能用此方法构造" userInfo:nil];
}

-(instancetype)initPrivate {
    if (self = [super init]) {
        
    }
    return  self;
}
+(instancetype)sharedOtherUser {
    static ChatOtherUserModel * user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!user) {
            user = [[self alloc] initPrivate];
            
        }
    });
    return  user;
}

- (ChatUserModel *)user
{
    if (_user == nil) {
        _user = [[ChatUserModel alloc] init];
        _user.username = @"Bay、栢";// 名字
        _user.userID = @"li-bokun";// ID
        _user.avatarURL = @"send_head.jpg";// 图片
    }
    return _user;
}

@end
