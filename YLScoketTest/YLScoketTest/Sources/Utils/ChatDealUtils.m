//
//  ChatDealUtils.m
//  YLScoketTest
//
//  Created by hoggen on 2020/6/3.
//  Copyright © 2020 ios-mac. All rights reserved.
//

#import "ChatDealUtils.h"
#import "ChatListUserModel.h"

@implementation ChatDealUtils


+(void)setMessageStateReaded:(NSString *)userId{
    [[LocalSQliteManager sharedInstance] setLocalChatMessageModelReadedByUserId:userId];
       ChatListUserModel *item2  = [ChatListUserModel new];
       item2.userId = userId;
       item2.messageCount = 0;
        item2.selfId = [[AccountManager sharedInstance] fetch].userID;
       [[LocalSQliteManager sharedInstance] insertChatListUserModel:item2];
}

@end
