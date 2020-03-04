//
//  LocalSQliteManager.h
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChatListUserModel;

@interface LocalSQliteManager : NSObject


+(instancetype)sharedInstance;

//判断聊天对应的数据是否存在
-(BOOL)isExist:(ChatListUserModel *)model;

/**添加聊天数据*/
-(BOOL)insertChatListUserModel:(ChatListUserModel *)model;

/**删除聊天数据*/
-(BOOL)deletChatListUserModel:(ChatListUserModel *)model;

/**数据库聊天列表数据按时间降序排列*/
-(NSArray<ChatListUserModel *> *)selectGetModelByDESC;

@end
