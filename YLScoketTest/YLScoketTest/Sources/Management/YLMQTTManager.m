//
//  YLMQTTManager.m
//  YLScoketTest
//
//  Created by 王留根 on 17/2/17.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "YLMQTTManager.h"
#import "MQTTKit.h"


//192.168.20.14
static NSString * host = @"192.168.20.14";
static const uint16_t port = 6969;
static NSString *clinetId = @"wangliugen";
static NSString *clinetOther = @"clinetOther ";

@interface YLMQTTManager ()

@property (nonatomic , strong)MQTTClient *client;
@end

@implementation YLMQTTManager

+ (instancetype)shareManager {
    static YLMQTTManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    [manager initSocket];
    return  manager;
}

- (void)initSocket {
    if (_client) {
        [self disConnnect];
    }
    _client = [[MQTTClient alloc] initWithClientId: clinetId];
    _client.port = port;
    
    __weak typeof(self) weakSelf = self;
    [_client setMessageHandler:^(MQTTMessage * message) {
        //收到消息的回调，前提是得先订阅
        NSString *messageString = [[NSString alloc] initWithData:message.payload encoding:NSUTF8StringEncoding];
//        if (weakSelf.delegate != nil) {
//            [weakSelf.delegate receiveMessage: [NSString stringWithFormat:@"%@", messageString]];
//        }
        NSLog(@"收到服务端发送的消息：%@",messageString);
    }];
    
    [_client connectToHost:host completionHandler:^(MQTTConnectionReturnCode code) {
        switch (code) {
            case ConnectionAccepted:
                NSLog(@"MQTT连接成功");
                //订阅自己的ID，这样收到消息就能回调
                [_client subscribe: clinetId  withCompletionHandler:^(NSArray *grantedQos) {
                    NSLog(@"订阅成功");
                }];
                
                break;
             
            case ConnectionRefusedBadUserNameOrPassword:
                NSLog(@"错误的用户名或密码");
                break;
            default:
                break;
        }
    }];
}

#pragma mark - 对外接口

//建立连接
- (void)connect {
    [self initSocket];
}

- (void)disConnnect {
    if (_client) {
        [_client unsubscribe: clinetId withCompletionHandler:^{
           
            NSLog(@"取消订阅wangliugen成功");
        }];
        
        [_client disconnectWithCompletionHandler:^(NSUInteger code) {
            NSLog(@"断开MQTT成功");
        }];
        
        _client = nil;
    }
}

- (void)sendMessage:(NSString *)message {
    //QoS（Quality of Service，服务质量）指一个网络能够利用各种基础技术，为指定的网络通信提供更好的服务能力, 是网络的一种安全机制， 是用来解决网络延迟和阻塞等问题的一种技术。
    //typedef enum MQTTQualityOfService : NSUInteger {
//    AtMostOnce,
//    AtLeastOnce,
//    ExactlyOnce
//} MQTTQualityOfService;分别对应最多发送一次，至少发送一次，精确只发送一次。
    [_client publishString:message toTopic: clinetId withQos:ExactlyOnce retain:YES completionHandler:^(int mid) {
        NSLog(@"消息已发送");
    }];
}


@end
































