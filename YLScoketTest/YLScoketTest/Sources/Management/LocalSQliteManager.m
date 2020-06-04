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
        [fmdb executeUpdate:@"create table if not exists ChatListTabel(userId primary key not null,name not null,avatar, message ,date not null,messageCount INTEGER,needHint INTEGER,selfId);"];
        //消息列表
        [fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS MessagesTabel (messageId TEXT PRIMARY KEY NOT NULL,messageOtherUserId TEXT NOT NULL,fromUserId TEXT NOT NULL,fromName TEXT NOT NULL,fromAvatar TEXT ,toUserUserId TEXT NOT NULL,toUserName TEXT NOT NULL,toUserAvatar TEXT,dateString TEXT , messageType INTEGER,ownerTyper INTEGER,readState INTEGER,sendState INTEGER,textString TEXT,messageSource TEXT,address TEXT,voiceSeconds INTEGER,date not null)"];
        
    }
}

//判断聊天消息是否存在
-(BOOL)isLoaclMessageModelExist:(LocalChatMessageModel *)model{
    FMResultSet *rs=[fmdb executeQuery:@"SELECT *FROM MessagesTabel WHERE messageId=?",model.messageId];
    if ([rs next]) {
        return YES;
    }
    return NO;
}
-(BOOL)insertLoaclMessageModel:(LocalChatMessageModel *)model{
    if (![self isLoaclMessageModelExist:model]) {
        BOOL success=[fmdb executeUpdate:@"INSERT into MessagesTabel values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.messageId,model.messageOtherUserId,model.fromUserId,model.fromName,model.fromAvatar,model.toUserUserId,model.toUserName,model.toUserAvatar,model.dateString,@(model.messageType),@(model.ownerTyper),@(model.readState),@(model.sendState),model.textString,model.messageSource,model.address,model.voiceSeconds,model.date];
        return success;
    }else{
        BOOL success = true;
           if (model.sendState != 0) {
               success =[fmdb executeUpdate:@"update MessagesTabel SET sendState = ? WHERE  messageId=? ",@(model.sendState),model.messageId];
               if (!success) {
                   return success;
               }
           }
  
    }
   
    return YES;
}
/**删除聊天数据*/
-(BOOL)deletLoaclMessageModel:(LocalChatMessageModel *)model{
    if ([self isLoaclMessageModelExist:model]) {
        BOOL success=[fmdb executeUpdate:@"delete from MessagesTabel where messageId=?",model.messageId];
        return success;
    }
    return true;
}
/*将消息置为已读*/
- (BOOL )setLocalChatMessageModelReadedByUserId:(NSString *)userId{
        BOOL success=[fmdb executeUpdate:@"update MessagesTabel SET readState = 1 WHERE  messageOtherUserId=? ",userId];
        return success;
}

/*更新消息发送状态*/
- (BOOL )setLocalChatMessageModelSendStateByMessageId:(NSString *)messageId sendState:(YLMessageSendState) sendState{
        BOOL success=[fmdb executeUpdate:@"update MessagesTabel SET sendState = ? WHERE  messageId=? ",sendState,messageId];
        return success;
}

/**获取某个聊天未读的条数*/
- (NSInteger )selectLocalChatMessageModelByUserId:(NSString *)userId{
    //从表中获取所要的数据
         NSUInteger count=[fmdb intForQuery:@"select Count(*) from MessagesTabel  where messageOtherUserId=? and readState = 0",userId];
         return count;
}

- (BOOL )deleteAll:(NSString *)userId{
        BOOL success=[fmdb executeUpdate:@"delete from MessagesTabel WHERE  messageOtherUserId=? ",userId];
    return success;
}

/**数据库聊天列表数据按时间降序排列*/
-(NSArray<ChatMessageModel *> *)selectLocalChatMessageModelByDESC:(NSInteger)page userId:(NSString *)userId{
//    BOOL success = [self deleteAll:userId];
    NSInteger startIndex = (page -1 > 0?page:0) * 40;
    NSInteger limit = 40;
    //从表中获取所要的数据
      FMResultSet *rs=[fmdb executeQuery:@"select * from MessagesTabel  where messageOtherUserId=? ORDER BY date ASC",userId];
      NSMutableArray<ChatMessageModel *> *models=[NSMutableArray array];
      while ([rs next]) {
          //创建聊天列表 userId 聊天对象的id； name聊天对象的昵称或者备注名； avatar聊天对象头像的连接；message聊天的最后一条消息；date聊天的时间；messageCount需要提醒的消息条数；needHint是否需要提醒
          LocalChatMessageModel *model=[[LocalChatMessageModel alloc]init];
          model.messageId= [rs stringForColumn: @"messageId"];
          model.messageOtherUserId= [rs stringForColumn: @"messageOtherUserId"];
          model.fromUserId= [rs stringForColumn: @"fromUserId"];
          model.fromName= [rs stringForColumn: @"fromName"];
          model.fromAvatar= [rs stringForColumn: @"fromAvatar"];
          model.toUserUserId= [rs stringForColumn: @"toUserUserId"];
          model.toUserName= [rs stringForColumn: @"toUserName"];
          model.toUserAvatar= [rs stringForColumn: @"toUserAvatar"];
          model.dateString= [rs stringForColumn: @"dateString"];
          model.messageType= [rs intForColumn: @"messageType"];
          model.ownerTyper= [rs intForColumn: @"ownerTyper"];
          model.readState= [rs intForColumn: @"readState"];
          model.sendState= [rs intForColumn: @"sendState"];
          model.textString= [rs stringForColumn: @"textString"];
          model.messageSource = [rs stringForColumn: @"messageSource"];
          model.address = [rs stringForColumn: @"address"];
          model.voiceSeconds = [rs intForColumn: @"voiceSeconds"];
          [models addObject: [LocalChatMessageModel chatMessageModelChangeWith:model] ];
      }
     // return [[[models reverseObjectEnumerator] allObjects] copy];
    return [models copy];
}








//判断聊天对应的数据是否存在
-(BOOL)isChatListUserModelExist:(ChatListUserModel *)model{
    FMResultSet *rs=[fmdb executeQuery:@"SELECT *FROM ChatListTabel WHERE userId=? and selfId=?",model.userId,model.selfId];
    if ([rs next]) {
        return YES;
    }
    return NO;
}

/**添加聊天数据*/
-(BOOL)insertChatListUserModel:(ChatListUserModel *)model{
    if (![self isChatListUserModelExist:model]) {
        BOOL success=[fmdb executeUpdate:@"INSERT into ChatListTabel values(?,?,?,?,?,?,?,?)",model.userId,model.name,model.avatar,model.message,model.date,@(model.messageCount),model.needHint,model.selfId];
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
            success =[fmdb executeUpdate:@"update ChatListTabel SET needHint = ? WHERE  userId=? ",@(model.needHint),model.userId];
            if (!success) {
                return success;
            }
        }
        if (model.messageCount >= 0) {
            success =[fmdb executeUpdate:@"update ChatListTabel SET messageCount = ? WHERE  userId=? ",@(model.messageCount),model.userId];
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
        BOOL success=[fmdb executeUpdate:@"delete from ChatListTabel where userId=? and selfId=?",model.userId,model.selfId];
        BOOL success2=[fmdb executeUpdate:@"delete from MessagesTabel where messageOtherUserId=?",model.userId];
        return (success && success2);
    }
    return true;
}

/**数据库聊天列表数据按时间降序排列*/
-(NSArray<ChatListUserModel *> *)selectChatListUserModelModelByDESC:(NSString *)selfId{
    //从表中获取所要的数据
    FMResultSet *rs=[fmdb executeQuery:@"select * from ChatListTabel where  selfId=? ORDER BY date DESC",selfId];
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
