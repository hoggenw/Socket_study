//
//  YLGCDAsyncSocketManager.m
//  YLScoketTest
//
//  Created by 王留根 on 17/2/15.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "YLGCDAsyncSocketManager.h"
#import "GCDAsyncSocket.h" // for TCP



@interface YLGCDAsyncSocketManager ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong)GCDAsyncSocket * gcdSocket;

@end

static NSString * host = @"192.168.31.27";
static const uint16_t port = 6969;

@implementation YLGCDAsyncSocketManager

+ (instancetype)shareManger {

    static YLGCDAsyncSocketManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        [manager initSocket];
        
    });
    
    return manager;
}

- (void)initSocket {
    _gcdSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}


//对外接口
- (BOOL)connect {
    return [_gcdSocket connectToHost:host onPort:port error:nil];
}

//断开连接

- (void)disconnnet {
    [_gcdSocket disconnect];
}

//发送消息
- (void)sendMassege:(NSString *)message {
    NSData * data = [message dataUsingEncoding:NSUTF8StringEncoding];
    [_gcdSocket writeData:data withTimeout:-1 tag:110];
}

//监听最新消息
- (void)pullMassege {

    //监听读数据的代理，只能监听10秒，10秒过后调用代理方法  -1永远监听，不超时，但是只收一次消息，
    //所以每次接受消息还的调用一次
    [_gcdSocket readDataWithTimeout:-1 tag:110];
}

#pragma mark -GCDAsyncSocketDelegate
//连接成功

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"连接成功：host：%@，port: %d",host,port);
    [self pullMassege];
    //心跳写在这里
}

//断开连接的时候调用
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"断开连接，host:%@,port:%d",sock.localHost,sock.localPort);
    //断线重连代写
}

//写成功的回调
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"写的回调,tag:%ld",tag);

}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *recieveMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"收到消息：%@",recieveMessage);
    [self pullMassege];
    
}

//分段去获取消息的回调
//- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
//{
//
//    NSLog(@"读的回调,length:%ld,tag:%ld",partialLength,tag);
//
//}

//为上一次设置的读取数据代理续时 (如果设置超时为-1，则永远不会调用到)如果设置了超时时间，时间结束后会调用
-(NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length {
    NSLog(@"来延时，tag:%ld,elapsed:%f,length:%ld",tag,elapsed,length);
    return 10;
}

@end
































