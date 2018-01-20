//
//  NetworkManager.m
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "NetworkManager.h"
#import "YLDeviceUtil.h"

#define NetworkTimeoutInterval 20.0

@interface NetworkManager()
@property (nonatomic, strong) NetworkManager * netManager;
@end

@implementation NetworkManager

-(instancetype)init {
    @throw [NSException exceptionWithName:@"单例类" reason:@"不能用此方法构造" userInfo:nil];
}

-(instancetype)initPrivate {
    if (self = [super init]) {
        
    }
    return  self;
}
+(instancetype)sharedInstance {
    static NetworkManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[self alloc] initPrivate];
            
        }
    });
    return  manager;
}

-(NetworkManager *)netManager {
    if (_netManager == nil) {
        _netManager = [NetworkManager sharedInstance];
    }
    return _netManager;
}
#pragma mark - 业务请求方法
//一般get请求
- (void)generalGetWithURL:(NSString *)requestURL param:(NSDictionary *)paramDic returnBlock:(ReturnBlock)infoBlock; {
    [self.netManager getWithURL:requestURL param:paramDic needToken: false returnBlock:infoBlock];
}



#pragma mark - 基础请求方法
- (void)postWithURL:(NSString *)requestURL param:(NSDictionary *)paramDic needToken:(BOOL)needToken returnBlock:(ReturnBlock)infoBlock {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] getSessionManager: needToken];
    
    [manager POST:requestURL parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
        self.returnBlock = infoBlock;
        self.returnBlock(dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSDictionary *dict = @{@"returnInfo" : @NO};
        self.returnBlock = infoBlock;
        self.returnBlock(dict);
    }];
}

- (void)getWithURL:(NSString *)requestURL param:(NSDictionary *)paramDic  needToken:(BOOL)needToken returnBlock:(ReturnBlock)infoBlock {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] getSessionManager: needToken];
    [manager GET:requestURL parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
        
        self.returnBlock = infoBlock;
        
        self.returnBlock(dict);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *dict = @{@"returnInfo" : @NO};
        
        self.returnBlock = infoBlock;
        self.returnBlock(dict);
        
    }];
}

- (void)deleteWithURL:(NSString *)requestURL param:(NSDictionary *)paramDic  needToken:(BOOL)needToken returnBlock:(ReturnBlock)infoBlock {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] getSessionManager: needToken];
    [manager DELETE:requestURL parameters:paramDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
        
        self.returnBlock = infoBlock;
        self.returnBlock(dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *dict = @{@"returnInfo" : @NO};
        self.returnBlock = infoBlock;
        self.returnBlock(dict);
    }];
}


- (void)putWithURL:(NSString *)requestURL param:(NSDictionary *)paramDic  needToken:(BOOL)needToken returnBlock:(ReturnBlock)infoBlock {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] getSessionManager: needToken];
    [manager PUT:requestURL parameters:paramDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
        
        self.returnBlock = infoBlock;
        self.returnBlock(dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *dict = @{@"returnInfo" : @NO};
        self.returnBlock = infoBlock;
        self.returnBlock(dict);
    }];
}

#pragma  mark - 头部文件设置
- (AFHTTPSessionManager *)getSessionManager:(BOOL)needToken
{
    static AFHTTPSessionManager *sessionManager = nil;
    sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [sessionManager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [sessionManager.requestSerializer setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    
    sessionManager.requestSerializer.timeoutInterval = NetworkTimeoutInterval;
    
    NSString *str = [YLDeviceUtil getSystemInfo];
    [sessionManager.requestSerializer setValue:str forHTTPHeaderField:@"platform"];
    [sessionManager.requestSerializer setValue:[YLDeviceUtil getAPPVersion] forHTTPHeaderField:@"version"];
    [sessionManager.requestSerializer setValue:@"Paw/3.0.14 (Macintosh; OS X/10.12.5) GCDHTTPRequest"forHTTPHeaderField:@"User-Agent"];
    if (needToken) {
        AccountManager * accountManager = [AccountManager sharedInstance];
        
        //NSLog(@"token = %@", token);
        [sessionManager.requestSerializer setValue: [accountManager fetchAccessToken] forHTTPHeaderField:@"token"];
    }
    return sessionManager;
}



@end
