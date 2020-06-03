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
@property (nonatomic, assign)NSTimeInterval reConnectTime;

@end

static const uint16_t port = 6969;



@implementation YLSocketRocktManager

+ (instancetype)shareManger {
    static YLSocketRocktManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YLSocketRocktManager alloc] init];
        [manager initSocket];
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
    _webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"ws://%@:%d/hoggen&%@&%@",HOST,port,model.accessToken,model.userID]] protocols:@[@"chat",@"superchat"]];
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
    
    if (@available(iOS 10.0, *)) {
        self_dispatch_main_async_safe(^{
            [self destoryHeartBeat];
            __weak typeof(self) weakSelf = self;
            self->_heartBeat = [NSTimer scheduledTimerWithTimeInterval: 3*9 repeats:YES block:^(NSTimer * _Nonnull timer) {
                NSLog(@"heart beat");
    
                
                [weakSelf ping];
            }];
            [[NSRunLoop currentRunLoop]addTimer:self->_heartBeat forMode:NSRunLoopCommonModes];
        });
    } else {
        // Fallback on earlier versions
    }
    
    
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

#pragma mark - 其他接口

- (void)connect {
    [self initSocket];
    //    //每次正常连接的时候清零重连时间
    //    _reConnectTime = 0;
}

-(void)disconnnet {
    if (_webSocket) {
        [_webSocket close];
        _webSocket = nil;
    }
}
#pragma mark- 消息发送
-(void)sendMassege:(ChatMessageModel *)messageModel {
    
    if (!(_webSocket.readyState == SR_OPEN)) {
        NSLog(@"程序未连接");
        return;
    }
    
    YLMessageModel * pmessage = [YLMessageModel new];
    switch (messageModel.messageType) {
        case  YLMessageTypeImage:{ // 图片
            pmessage.textString = @"这是图片";
            pmessage.messageType = YLMessageTypeImage;
            pmessage.messageSource = messageModel.sourcePath;
            pmessage.voiceData = messageModel.voiceData;
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
    NSString *dateString = [[NSDate date] formatYYMMDDHHMMssSS];
    pmessage.messageId = [NSString stringWithFormat:@"%@&%@&%@",messageModel.from.userId,messageModel.toUser.userId,dateString];
    
    LocalChatMessageModel * locaModel = [LocalChatMessageModel localChatMessageModelchangeWith: pmessage];
    locaModel.sendState =   YLMessageSending;
    locaModel.readState =  YLMessageReaded;
    locaModel.ownerTyper = YLMessageOwnerTypeSelf;
    locaModel.dateString = dateString;
    locaModel.messageOtherUserId = pmessage.toUser.userId;
    
    //存入本地，然后发送通知；
    if ([[LocalSQliteManager sharedInstance] insertLoaclMessageModel:locaModel]) {
        
         // 序列化为Data
         NSData *data = [pmessage data];
         
         YLBaseMessageModel * base = [YLBaseMessageModel new];
         base.title = SokectTile;
         base.command = YLMessageCMDPersontoPerson;
         base.module = YLMessageCommonModule;
         base.data_p = data;
         //NSLog(@"%@",data);
         [_webSocket send: [base data]];
         
    }else{
        [YLHintView showMessageOnThisPage:@"消息存储失败"];
    }
    
    
 
    
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
                   
        YLMessageModel * pmessage  = [[YLMessageModel alloc] initWithData:baseModel.data_p error:&error];
        //todo
        //更新本地数据库消息发送记录
        LocalChatMessageModel * locaModel = [LocalChatMessageModel new];
        locaModel.messageId = pmessage.messageId;
        locaModel.sendState =  YLMessageSendSuccess;
         if ([[LocalSQliteManager sharedInstance] insertLoaclMessageModel:locaModel]) {
             NSLog(@"更新消息状态成功");
           }
        //更新该聊天对像列表的最新消息
            ChatListUserModel *item2  = [ChatListUserModel new];
            item2.userId = pmessage.toUser.userId;
            item2.name = pmessage.toUser.name;
            item2.date = [NSDate date];
            item2.message = pmessage.textString;
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
        NSString *dateString = [[NSDate date] formatYYMMDDHHMMssSS];
        LocalChatMessageModel * locaModel = [LocalChatMessageModel localChatMessageModelchangeWith: pmessage];
        locaModel.sendState =  YLMessageSendSuccess;
        locaModel.readState =  YLMessageUnRead;
        locaModel.ownerTyper = YLMessageOwnerTypeOther;
        locaModel.dateString = dateString;
        locaModel.messageOtherUserId = pmessage.fromUser.userId;
        if ([[LocalSQliteManager sharedInstance] insertLoaclMessageModel:locaModel]) {
            NSLog(@"接收消息状态成功");
            //下一步将消息
            NSInteger unread = [[LocalSQliteManager sharedInstance] selectLocalChatMessageModelByUserId:pmessage.fromUser.userId];
            //更新该聊天对像列表的最新消息
            ChatListUserModel *item2  = [ChatListUserModel new];
            item2.userId = pmessage.fromUser.userId;
            item2.name = pmessage.fromUser.name;
            item2.date = [NSDate date];
            item2.message = pmessage.textString;
            item2.messageCount = (int)unread;
            [[LocalSQliteManager sharedInstance] insertChatListUserModel:item2];
            [[NSNotificationCenter defaultCenter] postNotificationName:Y_Notification_Refresh_ChatList object:nil];
        }
        
        
    }
    
    
//
//    if (_delegate && [_delegate respondsToSelector:@selector(receiveMessage:)]) {
//        if (baseModel != NULL) {
//
//            if (baseModel.command == 10086) {
//                [YLHintView showMessageOnThisPage:@"登录已过期"];
//                POST_LOGINQUIT_NOTIFICATION;
//                return;
//            }
//
//            YLMessageModel * pmessage  = [[YLMessageModel alloc] initWithData:baseModel.data_p error:&error];
//            NSLog(@"%@",pmessage.description);
//            if (pmessage != NULL) {
//                [_delegate receiveMessage: pmessage];
//            }
//        }
//
//        return;
//    }else{
//
//        if (baseModel != NULL) {
//            [self disconnnet];
//            if (baseModel.command == 10086) {
//                [YLHintView showMessageOnThisPage:@"登录已过期"];
//                POST_LOGINQUIT_NOTIFICATION;
//                return;
//            }
//            YLMessageModel * pmessage  = [[YLMessageModel alloc] initWithData:baseModel.data_p error:&error];
//            LocalChatMessageModel * locaModel = [LocalChatMessageModel localChatMessageModelchangeWith: pmessage];
//            locaModel.sendState =  YLMessageSendSuccess;
//            locaModel.readState =  YLMessageUnRead;
//            locaModel.ownerTyper = YLMessageOwnerTypeOther;
//            NSString *dateString = [[NSDate date] formatYYMMDDHHMMssSS];
//            locaModel.dateString = dateString;
//            locaModel.messageOtherUserId = pmessage.fromUser.userId;
//            //存入本地
//
//
//        }
//    }
//
    
    
    NSLog(@"服务器返回消息：%@",message);
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"连接成功");
    _reConnectTime = 0;
    [self initHeartBeat];
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


//将收到的消息，是否需要把data转换为NSString，每次收到消息都会被调用，默认YES
//- (BOOL)webSocketShouldConvertTextFrameToString:(SRWebSocket *)webSocket
//{
//    NSLog(@"webSocketShouldConvertTextFrameToString");
//
//    return NO;
//}
@end








