//
//  YLSocketRocktManager.m
//  YLScoketTest
//
//  Created by 王留根 on 17/2/16.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "YLSocketRocktManager.h"
//#import "SocketRocket.h"
#import "YlmessageModel.pbobjc.h"
#import "YlbaseMessageModel.pbobjc.h"
#import "GPBProtocolBuffers_RuntimeSupport.h"
#import "ChatMessageModel.h"
#import "LocalChatMessageModel.h"
#import "ChatListUserModel.h"
#import <Qiniu/QiniuSDK.h>


typedef NS_ENUM(NSInteger,DisConnectType) {
    disConnectByUser = 1000,
    DisConnectByServer
};

#define self_dispatch_main_async_safe(block) \
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#define SokectTile -6524123


@interface YLSocketRocktManager ()<SRWebSocketDelegate>

@property (nonatomic, strong)SRWebSocket * webSocket;
@property (nonatomic, strong)NSTimer * heartBeat;
@property (nonatomic, strong)NSTimer * messageBeat;
@property (nonatomic, assign)NSTimeInterval reConnectTime;

@end




@implementation YLSocketRocktManager

+ (instancetype)shareManger {
    static YLSocketRocktManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YLSocketRocktManager alloc] init];
        [manager initSocket];
        [manager initMessageBeat];
    });
    return manager;
}

- (void)initSocket {
    if (_webSocket) {
        return;
    }
    AccountManager * manager = [AccountManager sharedInstance];
    if(!manager.isLogin){
        return;
    }
    UserModel * model = manager.fetch;
    _webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"ws://%@:%d/hoggen&%@&%@",SOCKETHOST,SOCKETHOSTPORT,model.accessToken,model.userID]] protocols:@[@"chat",@"superchat"]];
    _webSocket.delegate = self;
    //设置代理线程Queue
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.maxConcurrentOperationCount = 1;
    [_webSocket setDelegateOperationQueue:queue];
    [_webSocket open];
    [self connect];
    
}

//初始化心跳
- (void)initHeartBeat {
    
    self_dispatch_main_async_safe(^{
        [self destoryHeartBeat];
        __weak typeof(self) weakSelf = self;
        self->_heartBeat = [NSTimer scheduledTimerWithTimeInterval: 3*9 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"heart beat");
            
            [weakSelf ping];
        }];
        [[NSRunLoop currentRunLoop]addTimer:self->_heartBeat forMode:NSRunLoopCommonModes];
    });
    
    
}

- (void)initMessageBeat{
    self_dispatch_main_async_safe(^{
        [self destoryMessageBeat];
        __weak typeof(self) weakSelf = self;
        self->_messageBeat = [NSTimer scheduledTimerWithTimeInterval: 5 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"更新消息状态");
            [weakSelf updateSqlMessageData];
        }];
        [[NSRunLoop currentRunLoop]addTimer:self->_messageBeat forMode:NSRunLoopCommonModes];
    });
}

//取消心跳
- (void)destoryHeartBeat {
    self_dispatch_main_async_safe(^{
        if (self->_heartBeat) {
            [self->_heartBeat invalidate];
            self->_heartBeat = nil;
        }
    });
}
//取消消息定时器
- (void)destoryMessageBeat {
    self_dispatch_main_async_safe(^{
        if (self->_messageBeat) {
            [self->_messageBeat invalidate];
            self->_messageBeat = nil;
        }
    });
}

-(void)updateSqlMessageData {
    NSArray<LocalChatMessageModel *>* models = [[LocalSQliteManager sharedInstance] selectAllLocalChatMessageModels];
    if (models.count <= 0) {
        [self destoryMessageBeat];
    }else{
        for (LocalChatMessageModel *model in models) {
            
            NSTimeInterval time = 10 ;//10
            NSDate * tenMinutesLater;
            if (model.messageType == YLMessageTypeImage) {
                tenMinutesLater  = [model.date dateByAddingTimeInterval: 20];//图片二十秒
            }else{
                tenMinutesLater = [model.date dateByAddingTimeInterval: time];
            }
            int result = [NSDate compareDate:tenMinutesLater withDate: [NSDate date]];
            if (result == 1) {
                NSLog(@"消息发送失败状态更新 %@", @([[LocalSQliteManager sharedInstance] setLocalChatMessageModelSendStateByMessageId:model.messageId sendState:YLMessageSendFail]))  ;
            }
            
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:Y_Notification_Refresh_ChatMessage_State object:nil];
    }
}

#pragma mark - 其他接口

- (void)connect {
    [self initSocket];
    //    //每次正常连接的时候清零重连时间
    //        _reConnectTime = 0;
}

-(void)disconnnet {
    if (_webSocket) {
        [_webSocket close];
        _webSocket = nil;
    }
}

#pragma mark- 消息重发
-(void)resendMassege:(ChatMessageModel *)messageModel {
    YLMessageModel * pmessage  = [self messageModelMesaagModel:messageModel];
    pmessage.messageId = messageModel.messageId;
    //存入本地，然后发送通知；
    
    if ([[LocalSQliteManager sharedInstance] setLocalChatMessageModelSendStateByMessageId:pmessage.messageId sendState:YLMessageSending]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Y_Notification_Refresh_ChatMessage_State object:nil];
        // 序列化为Data
        if (pmessage.messageType == YLMessageTypeImage || pmessage.messageType == YLMessageTypeVoice) {
            [self sendPictureMesaageBefore:pmessage messageModel:messageModel ];
        }else {
            // 序列化为Data
            YLBaseMessageModel * base = [YLBaseMessageModel new];
            base.title = SokectTile;
            base.command = YLMessageCMDPersontoPerson;
            base.module = YLMessageCommonModule;
            base.data_p =  [pmessage data];
            [self sendMesaageWith:[base data]];
        }
        [self initMessageBeat];
        
    }else{
        [YLHintView showMessageOnThisPage:@"消失发送发生错误"];
    }
    
}
#pragma mark- 消息发送
-(void)sendMassege:(ChatMessageModel *)messageModel {
    
    
    YLMessageModel * pmessage  = [self messageModelMesaagModel:messageModel];
    NSString *dateString = [[NSDate date] formatYYMMDDHHMMssSS];
    pmessage.messageId = [NSString stringWithFormat:@"%@&%@&%@",messageModel.from.userId,messageModel.toUser.userId,dateString];
    
    LocalChatMessageModel * locaModel = [LocalChatMessageModel localChatMessageModelchangeWith: pmessage];
    locaModel.sendState =   YLMessageSending;
    locaModel.readState =  YLMessageReaded;
    locaModel.ownerTyper = YLMessageOwnerTypeSelf;
    locaModel.dateString = dateString;
    locaModel.messageOtherUserId = pmessage.toUser.userId;
    locaModel.date = [NSDate date];
    //存入本地，然后发送通知；
    if ([[LocalSQliteManager sharedInstance] insertLoaclMessageModel:locaModel]) {
        
        
        
        if (_delegate && [_delegate respondsToSelector:@selector(receiveMessage:)]) {
            if (pmessage != NULL) {
                [_delegate receiveMessage: locaModel];
            }
        }
        
        if (pmessage.messageType == YLMessageTypeImage || pmessage.messageType == YLMessageTypeVoice ) {
          //  [self sendPictureMesaageBefore:pmessage messageModel:messageModel];
        }else {
            // 序列化为Data
            YLBaseMessageModel * base = [YLBaseMessageModel new];
            base.title = SokectTile;
            base.command = YLMessageCMDPersontoPerson;
            base.module = YLMessageCommonModule;
            base.data_p =  [pmessage data];
            [self sendMesaageWith:[base data]];
        }
        [self initMessageBeat];
    }else{
        [YLHintView showMessageOnThisPage:@"消失发送发生错误"];
    }
}

//组装获取未获取消息请求
- (void)getUnrecivedMessage{
    YLMessageModel * pmessage = [YLMessageModel new];
    UserModel * model = [AccountManager sharedInstance].fetch;
    YLUserModel * user = [YLUserModel new];
    user.name = model.name;
    user.avatar = model.avatar;
    user.userId = model.userID;
    pmessage.fromUser = user ;
    //token
    pmessage.token = [AccountManager sharedInstance].fetch.accessToken;
    YLBaseMessageModel * base = [YLBaseMessageModel new];
    base.title = SokectTile;
    base.command = YLMessageCMDMessageGet;
    base.module = YLMessageUnsendMessgeGet;
    base.data_p =  [pmessage data];
    [self sendMesaageWith:[base data]];
}

//连接成功，获取当前连接服务器的ip
- (void)getNowIp{
    NSLog(@"获取当前ip");
    YLMessageModel * pmessage = [YLMessageModel new];
    UserModel * model = [AccountManager sharedInstance].fetch;
    YLUserModel * user = [YLUserModel new];
    user.name = model.name;
    user.avatar = model.avatar;
    user.userId = model.userID;
    pmessage.fromUser = user ;
    //token
    pmessage.token = [AccountManager sharedInstance].fetch.accessToken;
    YLBaseMessageModel * base = [YLBaseMessageModel new];
    base.title = SokectTile;
    base.command = YLMessageCMDNowIpGet;
    base.module = YLMessageUnsendMessgeGet;
    base.data_p =  [pmessage data];
    [self sendMesaageWith:[base data]];
    
}

#pragma 消息发送方法  图片消息发送前处理
-(void)sendPictureMesaageBefore:(YLMessageModel *) pmessage messageModel:(ChatMessageModel *)messageModel{
    
    //uploadtoken过期时间1天
    NSString * uploadtoken = [UserDefUtils getStringForKey:@"qiniuTokenString"];
    if ([JudgeUtil isQiNiuTokenExpire] || uploadtoken.length <= 0) {
        [[NetworkManager sharedInstance] postWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Upload_TokenAPI] paramBody:nil needToken:true showToast:false  returnBlock:^(NSDictionary *returnDict) {
            if ([@"0" isEqualToString: [NSString stringWithFormat:@"%@", returnDict[@"errno"]]]) {
                
                NSDictionary * tokenDic = returnDict[@"data"];
                NSString * uploadtoken = [NSString stringWithFormat:@"%@",tokenDic[@"uploadToken"]];
                NSLog(@"上传token%@",uploadtoken);
                [UserDefUtils saveString:[[NSDate date] toStringWithFormat:@"YYYY-MM-dd HH:mm:ss"] forKey:@"qiniuTokenTimeString"];
                [UserDefUtils saveString:uploadtoken forKey:@"qiniuTokenString"];
                [self sendPictureMesaage: pmessage messageModel: messageModel uploadtoken: uploadtoken];
            }else {
                NSLog(@"获取上传token失败");
                return;
            }
            
        }];
    }else{
        
        [self sendPictureMesaage: pmessage messageModel: messageModel uploadtoken: uploadtoken];
    }
    
}

-(void)sendPictureMesaage:(YLMessageModel *) pmessage messageModel:(ChatMessageModel *)messageModel uploadtoken:(NSString *)uploadtoken{
    //图片数据
    NSData * imageData = messageModel.voiceData;
    if (imageData == nil) {
        [YLHintView showMessageOnThisPage:@"消息数据已遗失或者损坏"];
        if ([[LocalSQliteManager sharedInstance] setLocalChatMessageModelSendStateByMessageId:pmessage.messageId sendState:YLMessageSourceError]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Y_Notification_Refresh_ChatMessage_State object:nil];
        }
        return;
    }
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.useHttps = YES;
    }];
    //重用uploadManager。一般地，只需要创建一个uploadManager对
    NSString * key = [NSString stringWithFormat:@"ihosdev/chat/%@.JPG",[[NSUUID UUID] UUIDString]] ;
    if (pmessage.messageType == YLMessageTypeImage) {
        key = [NSString stringWithFormat:@"ihosdev/chat/%@.JPG",[[NSUUID UUID] UUIDString]] ;
    }else if(pmessage.messageType == YLMessageTypeVoice){
        key = [NSString stringWithFormat:@"ihosdev/chat/%@.amr",[[NSUUID UUID] UUIDString]] ;
    }
    
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    [upManager putData:imageData key:key token:uploadtoken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        if(info.ok)
        {
            NSLog(@"请求成功");
            //                           NSLog(@"info==  %@",info);
            //                            NSLog(@"resp==  %@",resp);
            //http://qnfilesdev.schlwyy.com/ihosdev/chat/B5E10EB1-69AC-41AB-8745-ECA61A1078DE.JPG
            NSString * imageUrl =[NSString stringWithFormat:@"http://qnfilesdev.schlwyy.com/%@",key];
            //            if( pmessage.messageType == YLMessageTypeVoice){
            //                [FileManager removeFileOfPath: pmessage.messageSource];
            //            }
            pmessage.messageSource = imageUrl;
            // 序列化为Data
            YLBaseMessageModel * base = [YLBaseMessageModel new];
            base.title = SokectTile;
            base.command = YLMessageCMDPersontoPerson;
            base.module = YLMessageCommonModule;
            base.data_p =  [pmessage data];
            [self sendMesaageWith:[base data]];
            
        }
        else{
            NSString * errorString = [NSString stringWithFormat:@"%@",info.error.userInfo[@"error"]];
            if ( [errorString isEqualToString:@"expired token"]) {
                NSLog(@"token失效");
                [self refreshUploadTokenWithMesaage: pmessage messageModel:messageModel];
            }
            NSLog(@"失败%@",info.error.userInfo[@"error"] );
        }
    } option:nil];
}

#pragma 消息发送方法  最后消息发送
-(void)sendMesaageWith:(NSData *)data {
    
    
    if (!(_webSocket.readyState == SR_OPEN)) {
        [YLHintView showMessageOnThisPage:@"请查看网络连接"];
        [self disconnnet];
        [self connect];
        return;
    }else{
        [_webSocket send: data];
    }
}

#pragma 消息发送 通用消息发送前处理
-(YLMessageModel *)messageModelMesaagModel:(ChatMessageModel *)messageModel{
    YLMessageModel * pmessage = [YLMessageModel new];
    switch (messageModel.messageType) {
        case  YLMessageTypeImage:{ // 图片
            pmessage.textString = messageModel.text;
            pmessage.messageType = YLMessageTypeImage;
            pmessage.messageSource = messageModel.sourcePath;
            //pmessage.voiceData = messageModel.voiceData;
            break;
        }
        case  YLMessageTypeText:{ // 文字
            pmessage.textString = messageModel.text;
            pmessage.messageType = YLMessageTypeText;
            break;
        }
        case  YLMessageTypeVoice:{ // 语音
            pmessage.voiceData = messageModel.voiceData;
            pmessage.messageType = YLMessageTypeVoice;
            pmessage.voiceLength = (uint32_t) messageModel.voiceSeconds;
            pmessage.messageSource = messageModel.voicePath;
            break;
        }
        case  YLMessageTypeVideo:{ // 视频
            pmessage.textString = @"这是视频";
            
            break;
        }
        case  YLMessageTypeFile:{ // 文件
            break;
        }
        case  YLMessageTypeLocation:{ // 位置
            break;
        }
        default:
            break;
    }
    pmessage.fromUser = messageModel.from ;
    pmessage.toUser = messageModel.toUser;
    //token
    pmessage.token = [AccountManager sharedInstance].fetch.accessToken;
    return pmessage;
}

//重连机制
- (void)reConnect {
    [self disconnnet];
    NSLog(@"重连时间： %@",@(_reConnectTime));
    if (_reConnectTime > 64) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->_webSocket = nil;
        [self initSocket];
    });
    
    if (_reConnectTime == 0) {
        _reConnectTime = 2;
    } else {
        _reConnectTime *= 2;
    }
    
}

- (void)ping {
    NSLog(@"_webSocket.readyState: %@",@(_webSocket.readyState));
    if (_webSocket.readyState == SR_CONNECTING || _webSocket.readyState == SR_OPEN ) {
        [_webSocket sendPing:nil];
    }
    
}

#pragma mark - SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    
    NSError *error;
    YLBaseMessageModel * baseModel = [[YLBaseMessageModel alloc] initWithData:message error: &error];
    
    if (baseModel.module == 201) {//发送消息返回状态
        if (baseModel.command == 10086) {
            [YLHintView showMessageOnThisPage:@"登录已过期"];
            POST_LOGINQUIT_NOTIFICATION;
            return;
        }
        
        if (baseModel.command == 5) {
            [YLHintView showMessageOnThisPage:@"你们还不是朋友关系，不能发送消息"];
            return;
        }
        
        YLMessageModel * pmessage  = [[YLMessageModel alloc] initWithData:baseModel.data_p error:&error];
        //更新本地数据库消息发送记录
        if ([[LocalSQliteManager sharedInstance] setLocalChatMessageModelSendStateByMessageId:pmessage.messageId sendState:YLMessageSendSuccess]) {
            NSLog(@"更新消息状态成功");
            if(pmessage.messageType == YLMessageTypeVoice){
                if ( [[LocalSQliteManager sharedInstance] setLocalChatMessageModelSendStateByMessageId:pmessage.messageId vioceSource:pmessage.messageSource ]) {
                    NSLog(@"更新语音消息数据源头");
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:Y_Notification_Refresh_ChatMessage_State object:nil];
        }
        
        
        //更新该聊天对像列表的最新消息
        ChatListUserModel *item2  = [ChatListUserModel new];
        item2.userId = pmessage.toUser.userId;
        item2.name = pmessage.toUser.name;
        item2.date = [NSDate date];
        if (pmessage.messageType == YLMessageTypeImage) {
            item2.message = @"【图片】";
        }else if (pmessage.messageType == YLMessageTypeVoice) {
            item2.message = @"【语音】";
        }else {
            item2.message = pmessage.textString;
        }
        
        item2.selfId = [[AccountManager sharedInstance] fetch].userID;
        [[LocalSQliteManager sharedInstance] insertChatListUserModel:item2];
        return;
    }else  if (baseModel.module == 101) {//普通消息接收
        if (baseModel.command == 10086) {
            [YLHintView showMessageOnThisPage:@"登录已过期"];
            POST_LOGINQUIT_NOTIFICATION;
            return;
        }
        
        YLMessageModel * pmessage  = [[YLMessageModel alloc] initWithData:baseModel.data_p error:&error];
        //todo
        //新增本地数据库消息接收记录
        
        LocalChatMessageModel * locaModel = [LocalChatMessageModel localChatMessageModelchangeWith: pmessage];
        locaModel.sendState =  YLMessageSendSuccess;
        locaModel.readState =  YLMessageUnRead;
        locaModel.ownerTyper = YLMessageOwnerTypeOther;
        locaModel.messageOtherUserId = pmessage.fromUser.userId;
        NSString * dateString = [locaModel.messageId componentsSeparatedByString:@"&"].lastObject;
        locaModel.date = [ NSDate dateWithString:dateString formatString: @"YYYY/MM/dd HH:mm:ss SS"];
        locaModel.dateString = dateString;
        
        if ([[LocalSQliteManager sharedInstance] insertLoaclMessageModel:locaModel]) {
            NSLog(@"接收消息状态成功");
            //下一步将消息
            NSInteger unread = [[LocalSQliteManager sharedInstance] selectLocalChatMessageModelByUserId:pmessage.fromUser.userId];
            //更新该聊天对像列表的最新消息
            ChatListUserModel *item2  = [ChatListUserModel new];
            item2.userId = pmessage.fromUser.userId;
            item2.name = pmessage.fromUser.name;
            item2.date = [NSDate date];
            if (pmessage.messageType == YLMessageTypeImage) {
                item2.message = @"【图片】";
            }else if (pmessage.messageType == YLMessageTypeVoice) {
                item2.message = @"【语音】";
            }else {
                item2.message = pmessage.textString;
            }
            item2.messageCount = (int)unread;
            item2.avatar = pmessage.fromUser.avatar;
            item2.selfId = [[AccountManager sharedInstance] fetch].userID;
            [[LocalSQliteManager sharedInstance] insertChatListUserModel:item2];
            [[NSNotificationCenter defaultCenter] postNotificationName:Y_Notification_Refresh_ChatList object:nil];
            if (_delegate && [_delegate respondsToSelector:@selector(receiveMessage:)]) {
                if (pmessage != NULL) {
                    [_delegate receiveMessage: locaModel];
                }
                return;
            }
            
        }
        
    }
    
    // NSLog(@"服务器返回消息：%@",message);
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"连接成功,拉取未接收信息");
    _reConnectTime = 0;
    [self initHeartBeat];
    [self getUnrecivedMessage];
    [self getNowIp];
    
    
}

//open失败的时候调用
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"连接失败error：%@",error);
    //重连
    [self reConnect];
}

//网络连接中断被调用
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"被关闭连接，code:%ld,reason:%@,wasClean:%d",code,reason,wasClean);
    if (code == disConnectByUser) {
        [self disconnnet];
        NSLog(@"用户操作，终端连接");
    } else {
        NSLog(@"非用户操作重连");
        [self reConnect];
    }
    [self destoryHeartBeat];
}

//sendPing的时候，如果网络通的话，则会收到回调，但是必须保证ScocketOpen，否则会crash
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSLog(@"收到PONG回调: %@",[[NSString alloc] initWithData:pongPayload encoding: NSUTF8StringEncoding]);
}


-(void)refreshUploadTokenWithMesaage:(YLMessageModel *) pmessage messageModel:(ChatMessageModel *)messageModel{
    [[NetworkManager sharedInstance] postWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Upload_TokenAPI] paramBody:nil needToken:true showToast:false  returnBlock:^(NSDictionary *returnDict) {
        if ([@"0" isEqualToString: [NSString stringWithFormat:@"%@", returnDict[@"errno"]]]) {
            
            NSDictionary * tokenDic = returnDict[@"data"];
            NSString * uploadtoken = [NSString stringWithFormat:@"%@",tokenDic[@"uploadToken"]];
            NSLog(@"上传token%@",uploadtoken);
            [UserDefUtils saveString:[[NSDate date] toStringWithFormat:@"YYYY-MM-dd HH:mm:ss"] forKey:@"qiniuTokenTimeString"];
            [UserDefUtils saveString:uploadtoken forKey:@"qiniuTokenString"];
            NSData * imageData = messageModel.voiceData;
            QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
                builder.useHttps = YES;
            }];
            //重用uploadManager。一般地，只需要创建一个uploadManager对
            NSString * key = [NSString stringWithFormat:@"ihosdev/chat/%@.JPG",[[NSUUID UUID] UUIDString]] ;
            if (pmessage.messageType == YLMessageTypeImage) {
                key = [NSString stringWithFormat:@"ihosdev/chat/%@.JPG",[[NSUUID UUID] UUIDString]] ;
            }else if(pmessage.messageType == YLMessageTypeVoice){
                key = [NSString stringWithFormat:@"ihosdev/chat/%@.amr",[[NSUUID UUID] UUIDString]] ;
            }
            
            QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
            [upManager putData:imageData key:key token:uploadtoken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                
                if(info.ok)
                {
                    NSLog(@"请求成功");
                    //                           NSLog(@"info==  %@",info);
                    //                            NSLog(@"resp==  %@",resp);
                    //http://qnfilesdev.schlwyy.com/ihosdev/chat/B5E10EB1-69AC-41AB-8745-ECA61A1078DE.JPG
                    NSString * imageUrl =[NSString stringWithFormat:@"http://qnfilesdev.schlwyy.com/%@",key];
                    //            if( pmessage.messageType == YLMessageTypeVoice){
                    //                [FileManager removeFileOfPath: pmessage.messageSource];
                    //            }
                    pmessage.messageSource = imageUrl;
                    // 序列化为Data
                    YLBaseMessageModel * base = [YLBaseMessageModel new];
                    base.title = SokectTile;
                    base.command = YLMessageCMDPersontoPerson;
                    base.module = YLMessageCommonModule;
                    base.data_p =  [pmessage data];
                    [self sendMesaageWith:[base data]];
                    
                }
                else{
                    NSLog(@"失败%@",info.error);
                }
            } option:nil];
        }else {
            NSLog(@"获取上传token失败");
            return;
        }
        
    }];
}

@end

