//
//  NetworkManager.m
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "NetworkManager.h"
#import "YLDeviceUtil.h"
#import "LoginViewController.h"

#define NetworkTimeoutInterval 20.0



//https
NSString * const BaseUrl = @"https://community.coinsolid.com";
NSString * const WebBaseUrl = @"https://community.coinsolid.com/resum/download?resumUrl=";


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


#pragma mark - 登录接口









#pragma mark - 基础请求方法
//放入请求头
- (void)postWithURL:(NSString *)requestURL param:(NSDictionary *)paramDic needToken:(BOOL)needToken returnBlock:(ReturnBlock)infoBlock {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] getSessionManager: needToken];
    
    [manager POST:requestURL parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
        
        if ([[NSString stringWithFormat:@"%@" ,dict[@"retcode"]] isEqualToString:@"127"]) {
            AppDelegate *AppDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            AppDele.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
            [[AccountManager sharedInstance] missLoginDeal];
             return ;
        }
        
        self.returnBlock = infoBlock;
        self.returnBlock(dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure error: %@", error);
        NSDictionary *dict = @{@"returnInfo" : @NO};
        self.returnBlock = infoBlock;
        self.returnBlock(dict);
    }];
}

//放入请求体
- (void)postWithURL:(NSString *)requestURL paramBody:(NSDictionary *)paramDic needToken:(BOOL)needToken returnBlock:(ReturnBlock)infoBlock {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] getSessionManager: needToken];
    [manager POST:requestURL parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
        
        if ([[NSString stringWithFormat:@"%@" ,dict[@"retcode"]] isEqualToString:@"127"]) {
            AppDelegate *AppDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            AppDele.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
            [[AccountManager sharedInstance] missLoginDeal];
            return ;
        }
        
        self.returnBlock = infoBlock;
        self.returnBlock(dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure error: %@", error);
        NSDictionary *dict = @{@"returnInfo" : @NO};
        self.returnBlock = infoBlock;
        self.returnBlock(dict);
    }];

}

- (void)getWithURL:(NSString *)requestURL param:(NSDictionary *)paramDic  needToken:(BOOL)needToken returnBlock:(ReturnBlock)infoBlock {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] getSessionManager: needToken];
    [manager GET:requestURL parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
        if ([[NSString stringWithFormat:@"%@" ,dict[@"retcode"]] isEqualToString:@"127"]) {
            AppDelegate *AppDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            AppDele.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
            [[AccountManager sharedInstance] missLoginDeal];
             return ;
        }
        self.returnBlock = infoBlock;
        
        self.returnBlock(dict);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *dict = @{@"returnInfo" : @NO};
        NSLog(@"error:%@",error);
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
        if ([[NSString stringWithFormat:@"%@" ,dict[@"retcode"]] isEqualToString:@"127"]) {
            AppDelegate *AppDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            AppDele.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
            [[AccountManager sharedInstance] missLoginDeal];
            return ;
        }
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
    //(这里设置涉及到AFHTTPRequestSerializer  ，AFJSONRequestSerializer java 后台getParameter能否收到参数，AFHTTPRequestSerializer能)测试无效
    
    [sessionManager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //[sessionManager.requestSerializer setValue:@"application/form-data" forHTTPHeaderField:@"Content-Type"];
    [sessionManager.requestSerializer setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    
    sessionManager.requestSerializer.timeoutInterval = NetworkTimeoutInterval;
    
    //证书问题===
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    sessionManager.securityPolicy = securityPolicy;
    //证书问题===
    
    NSString *str = [YLDeviceUtil getSystemInfo];
    [sessionManager.requestSerializer setValue:str forHTTPHeaderField:@"platform"];
    NSString * language = [NSString string];
    
    if ([[self currentLanguage] isEqualToString:@"zh-Hans-CN"]) {
        language = @"cn";
    }else{
        language = @"en";
    }
    [sessionManager.requestSerializer setValue:language forHTTPHeaderField:@"lan"];
    [sessionManager.requestSerializer setValue:[YLDeviceUtil getAPPVersion] forHTTPHeaderField:@"version"];
    //[sessionManager.requestSerializer setValue:@"Paw/3.0.14 (Macintosh; OS X/10.12.5) GCDHTTPRequest"forHTTPHeaderField:@"User-Agent"];
    if (needToken) {
        UserModel * user = [[AccountManager sharedInstance] fetch];
        NSLog(@"yltoken = %@", user.accessToken);
        [sessionManager.requestSerializer setValue: @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJsb2dpblR5cGUiOiIyIiwibG9naW5OYW1lIjoiYWRtaW4iLCJleHAiOjE1NDM4MzE1MzQsInVzZXJJZCI6IncxMjM0NTYifQ.fRtN4k7s9Fu71XiRFUw_Hj7edn3fswsxvPM9qKHXPz4" forHTTPHeaderField:@"token"];
    }
    return sessionManager;
}

- (NSString*)currentLanguage
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defaults objectForKey:@"AppleLanguages"];
    NSString* currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}



@end
