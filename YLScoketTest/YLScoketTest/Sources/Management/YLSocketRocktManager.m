//
//  YLSocketRocktManager.m
//  YLScoketTest
//
//  Created by 王留根 on 17/2/16.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "YLSocketRocktManager.h"
#import "SocketRocket.h"
 #import "Message.pbobjc.h"
#import "GPBProtocolBuffers_RuntimeSupport.h"
#import "ChatMessageModel.h"
#import "ChatOtherUserModel.h"

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


@interface YLSocketRocktManager ()<SRWebSocketDelegate>

@property (nonatomic, strong)SRWebSocket * webSocket;
@property (nonatomic, strong)NSTimer * heartBeat;
@property (nonatomic, assign)NSTimeInterval reConnectTime;

@end

static NSString * host = @"192.168.20.14";
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
    _webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"ws://%@:%d",host,port]]];
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
        _heartBeat = [NSTimer scheduledTimerWithTimeInterval: 3*60 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"heart beat");
             ChatMessageModel * message = [ChatMessageModel new];
            message.from = [ChatOtherUserModel sharedOtherUser].user;
            message.messageType = YLMessageTypeText;
            message.text = @"heart";
            [weakSelf sendMassege: message];
        }];
        [[NSRunLoop currentRunLoop]addTimer:_heartBeat forMode:NSRunLoopCommonModes];
    });
    
    
}

//取消心跳
- (void)destoryHeartBeat {
    self_dispatch_main_async_safe(^{
        if (_heartBeat) {
            [_heartBeat invalidate];
            _heartBeat = nil;
        }
    });
}

#pragma mark - 其他接口

- (void)connect {
    [self initSocket];
    //每次正常连接的时候清零重连时间
    _reConnectTime = 0;
}

-(void)disconnnet {
    if (_webSocket) {
        [_webSocket close];
        _webSocket = nil;
    }
}

-(void)sendMassege:(ChatMessageModel *)messageModel {
    
    YLmessageModel * pmessage = [YLmessageModel new];
    switch (messageModel.messageType) {
        case  YLMessageTypeImage:{ // 图片
            pmessage.textString = @"这是图片";
            pmessage.messageType = YLMessageTypeImage;
            pmessage.name = messageModel.imagePath;
            pmessage.voiceData = messageModel.voiceData;
            break;
        }
        case  YLMessageTypeText:{ // 文字
             pmessage.textString = messageModel.text;
            pmessage.name = messageModel.from.username;
            pmessage.messageType = YLMessageTypeText;
            break;
        }
        case  YLMessageTypeVoice:{ // 语音
            pmessage.name =  messageModel.from.username;
            pmessage.voiceData = messageModel.voiceData;
            pmessage.messageType = YLMessageTypeVoice;
            pmessage.voiceLength = (uint32_t) messageModel.voiceSeconds;
            break;
        }
        case  YLMessageTypeVideo:{ // 视频
            NSLog(@"视频暂时不处理");
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
    // 序列化为Data
    NSData *data = [pmessage data];
    NSLog(@"%@",data);
    [_webSocket send: data];
    
}
//重连机制
- (void)reConnect {
    [self disconnnet];
    
    if (_reConnectTime > 64) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _webSocket = nil;
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
    if (_delegate && [_delegate respondsToSelector:@selector(receiveMessage:)]) {
        NSError *error;
        YLmessageModel * pmessage  = [[YLmessageModel alloc] initWithData:message error:&error];
        //NSLog(@"%@",pmessage.description);
        [_delegate receiveMessage: pmessage];
    }
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






































