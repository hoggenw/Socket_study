//
//  YLGCDAsyncSocketManager.m
//  YLScoketTest
//
//  Created by 王留根 on 17/2/15.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "YLGCDAsyncSocketManager.h"
#import "GCDAsyncSocket.h" // for TCP


static NSString * host = @"192.168.31.27";
static const uint16_t port = 6969;

@interface YLGCDAsyncSocketManager ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong)GCDAsyncSocket * gcdSocket;

@end

@implementation YLGCDAsyncSocketManager

@end
