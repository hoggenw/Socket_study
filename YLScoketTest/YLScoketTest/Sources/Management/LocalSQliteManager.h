//
//  LocalSQliteManager.h
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalChatMessageModel.h"
@class ChatListUserModel;

@interface LocalSQliteManager : NSObject


+(instancetype)sharedInstance;

//判断聊天对应的数据是否存在
-(BOOL)isChatListUserModelExist:(ChatListUserModel *)model;

/**添加聊天数据*/
-(BOOL)insertChatListUserModel:(ChatListUserModel *)model;

/**删除聊天数据*/
-(BOOL)deletChatListUserModel:(ChatListUserModel *)model;

/**数据库聊天列表数据按时间降序排列*/
-(NSArray<LocalChatMessageModel *> *)selectLocalChatMessageModelByDESC:(NSInteger)page userId:(NSString *)userId;
/**获取某个聊天未读的条数*/
- (NSInteger )selectLocalChatMessageModelByUserId:(NSString *)userId;
/*将消息置为已读*/
- (BOOL )setLocalChatMessageModelReadedByUserId:(NSString *)userId;
/*更新消息发送状态*/
- (BOOL )setLocalChatMessageModelSendStateByMessageId:(NSString *)messageId sendState:(YLMessageSendState) sendState;






//判断聊天消息是否存在
-(BOOL)isLoaclMessageModelExist:(LocalChatMessageModel *)model;
-(BOOL)insertLoaclMessageModel:(LocalChatMessageModel *)model;
/**删除聊天数据*/
-(BOOL)deletLoaclMessageModel:(LocalChatMessageModel *)model;
/**数据库聊天列表数据按时间降序排列*/
-(NSArray<LocalChatMessageModel *> *)selectChatListUserModelModelByDESC;

@end
