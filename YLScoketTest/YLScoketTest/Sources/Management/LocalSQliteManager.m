//
//  LocalSQliteManager.m
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "LocalSQliteManager.h"
#import <FMDB/FMDB.h>
#import "ChatListUserModel.h"

@implementation LocalSQliteManager{
    FMDatabase *fmdb;
}



-(instancetype)init {
    @throw [NSException exceptionWithName:@"单例类" reason:@"不能用此方法构造" userInfo:nil];
}

-(instancetype)initPrivate {
    if (self = [super init]) {
        [self creatDataBase];
    }
    return  self;
}
+(instancetype)sharedInstance {
    static LocalSQliteManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[self alloc] initPrivate];
            
        }
    });
    return  manager;
}

//初始化数据库
-(void)creatDataBase{
    
    NSArray *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPath = [[documentsPath firstObject] stringByAppendingPathComponent:@"experenceStore.db"];
    if (!fmdb) {
        fmdb=[[FMDatabase alloc]initWithPath:dbPath];
    }
    if ([fmdb open]) {
        //创建聊天列表 userId 聊天对象的id； name聊天对象的昵称或者备注名； avatar聊天对象头像的连接；message聊天的最后一条消息；date聊天的时间；messageCount需要提醒的消息条数；needHint是否需要提醒
        [fmdb executeUpdate:@"create table if not exists ChatListTabel(userId primary key not null,name not null,avatar, message ,date not null,messageCount INTEGER,needHint INTEGER);"];
        //消息列表
        //       [fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS newOrderTabel (stockId TEXT PRIMARY KEY NOT NULL,stockCount INTEGER,count INTEGER,itemId TEXT NOT NULL,sellPrice TEXT NOT NULL,originPrice TEXT NOT NULL,name TEXT NOT NULL,categoryId TEXT NOT NULL,dockId TEXT,dockName TEXT,phone not null,purchaseNum not null)"];
        
    }
}


//判断聊天对应的数据是否存在
-(BOOL)isChatListUserModelExist:(ChatListUserModel *)model{
    FMResultSet *rs=[fmdb executeQuery:@"SELECT *FROM ChatListTabel WHERE userId=?",model.userId];
    if ([rs next]) {
        return YES;
    }
    return NO;
}

/**添加聊天数据*/
-(BOOL)insertChatListUserModel:(ChatListUserModel *)model{
    if (![self isChatListUserModelExist:model]) {
        BOOL success=[fmdb executeUpdate:@"INSERT into ChatListTabel values(?,?,?,?,?,?,?)",model.userId,model.name,model.avatar,model.message,model.date,model.messageCount,model.needHint];
        return success;
    }else{
        BOOL success = true;
        if (model.name.length > 0) {
            success =[fmdb executeUpdate:@"update ChatListTabel SET name = ? WHERE  userId=? ",model.name,model.userId];
            if (!success) {
                return success;
            }
        }
        if (model.avatar.length > 0) {
            success =[fmdb executeUpdate:@"update ChatListTabel SET avatar = ? WHERE  userId=? ",model.avatar,model.userId];
            if (!success) {
                return success;
            }
        }
        if (model.message.length > 0) {
            success =[fmdb executeUpdate:@"update ChatListTabel SET message = ? WHERE  userId=? ",model.message,model.userId];
            if (!success) {
                return success;
            }
        }
        if (model.date !=NULL)  {
            success =[fmdb executeUpdate:@"update ChatListTabel SET date = ? WHERE  userId=? ",[NSDate date],model.userId];
            if (!success) {
                return success;
            }
        }
        if (model.needHint == 0 || model.needHint == 1) {
            success =[fmdb executeUpdate:@"update ChatListTabel SET needHint = ? WHERE  userId=? ",model.needHint,model.userId];
            if (!success) {
                return success;
            }
        }
        if (model.messageCount >= 0) {
            success =[fmdb executeUpdate:@"update ChatListTabel SET messageCount = ? WHERE  userId=? ",model.messageCount,model.userId];
            if (!success) {
                return success;
            }
        }
        
        
        
    }
    return YES;
}

/**删除聊天数据*/
-(BOOL)deletChatListUserModel:(ChatListUserModel *)model{
    if ([self isChatListUserModelExist:model]) {
        BOOL success=[fmdb executeUpdate:@"delete from ChatListTabel where userId=?",model.userId];
        return success;
    }
    return true;
}

/**数据库聊天列表数据按时间降序排列*/
-(NSArray<ChatListUserModel *> *)selectChatListUserModelModelByDESC{
    //从表中获取所要的数据
    FMResultSet *rs=[fmdb executeQuery:@"select * from ChatListTabel ORDER BY date DESC"];
    NSMutableArray<ChatListUserModel *> *models=[NSMutableArray array];
    while ([rs next]) {
        //创建聊天列表 userId 聊天对象的id； name聊天对象的昵称或者备注名； avatar聊天对象头像的连接；message聊天的最后一条消息；date聊天的时间；messageCount需要提醒的消息条数；needHint是否需要提醒
        ChatListUserModel *model=[[ChatListUserModel alloc]init];
        model.userId = [rs stringForColumn: @"userId"];
        model.name = [rs stringForColumn: @"name"];
        model.avatar = [rs stringForColumn: @"avatar"];
        model.message = [rs  stringForColumn: @"message"];
        model.date = [rs dateForColumn: @"date"];
        model.messageCount = [rs intForColumn: @"messageCount"];
        model.needHint = ![rs boolForColumn: @"needHint"];
        [models addObject:model];
    }
    return [models copy];
}
@end
