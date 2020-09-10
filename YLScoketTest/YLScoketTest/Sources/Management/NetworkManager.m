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

#ifdef DEBUG
//https
NSString * const BaseUrl = @"http://192.168.1.11:8099/";
NSString * const SOCKETHOST = @"192.168.1.11";
uint16_t const SOCKETHOSTPORT = 9696;

//NSString * const BaseUrl = @"http://49.235.149.115:8099/";
//NSString * const WebBaseUrl = @"https://community.coinsolid.com/resum/download?resumUrl=";
//NSString * const SOCKETHOST = @"49.235.149.115";
//uint16_t const SOCKETHOSTPORT = 9696;


//NSString * const BaseUrl = @"http://www.wangchat.buzz:9001/";
//NSString * const WebBaseUrl = @"https://community.coinsolid.com/resum/download?resumUrl=";
//NSString * const SOCKETHOST = @"websocket.wangchat.buzz";
//uint16_t const SOCKETHOSTPORT = 9001;

#else
NSString * const BaseUrl = @"http://www.wangchat.buzz:9001/";
NSString * const SOCKETHOST = @"websocket.wangchat.buzz";
uint16_t const SOCKETHOSTPORT = 9001;
#endif



#pragma mark- 接口

NSString * const RegistCodeAPI = @"api/login/getKaptchaImage";

NSString * const LoginAPI = @"api/login/userLogin";
NSString * const LoginQuitAPI = @"api/login/quit";
//获取用户信息
NSString * const UserInfoAPI = @"api/login/info";
//获取用户信息
NSString * const UserPushTokenAPI = @"api/login/pushToken";

NSString * const UpdatePasswordAPI = @"api/login/updatePassword";


#pragma mark- 用户关系接口
NSString * const Friendships_List = @"api/apply/friend/friedsList";
NSString * const ApplyFriendships_List = @"api/apply/friend/applyList";
NSString * const Blackships_List = @"api/apply/friend/blackList";
NSString * const Blackships_Delete = @"api/apply/friend/blackDelete";
NSString * const Update_Friendship_info = @"api/apply/friend/updateFriendship";
NSString * const Agree_Friendship = @"api/apply/friend/add";
NSString * const Create_Friendship = @"api/apply/friend/creat";
NSString * const Delete_Friendship = @"api/apply/friend/delete";

NSString * const Search_Friends = @"api/people/search";

NSString * const Upload_TokenAPI = @"api/file/uploadToken";

NSString * const RegisterAPI = @"api/login/register";

NSString * const UploadFileAPI = @"api/file/upload";

@interface NetworkManager()
@property (nonatomic, strong) NetworkManager * netManager;
@end
static AFHTTPSessionManager *sessionManager = nil;
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
    [self.netManager getWithURL:requestURL param:paramDic needToken: false showToast: true returnBlock:infoBlock];
}


#pragma mark - 登录接口






#pragma mark- 上传图片

-(void)postImageUploadApiParam:(NSData *)data fileName:(NSString *)fileName  mimeType:(NSString *)mimeType returnBlock:(ReturnBlock)infoBlock {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] getSessionManager: true showToast: false];
    [manager POST:[NSString stringWithFormat:@""] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data
                                    name:@"file"
                                fileName:fileName
                                mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
        NSString *errnos = [NSString stringWithFormat:@"%@",[dict objectForKey:@"errno"]];
        if([errnos isEqualToString:@"0"]){ //成功
            self.returnBlock = infoBlock;
            self.returnBlock(dict);
            
        }else if ([errnos isEqualToString:@"10086"]){//被挤下线
            [YLHintView showMessageOnThisPage:@"登录已过期"];
            POST_LOGINQUIT_NOTIFICATION;
        }else {
            [self dealError: [NSString stringWithFormat:@"%@",[dict objectForKey:@"errmsg"]]];
        }
        self.returnBlock = infoBlock;
        self.returnBlock(dict);
        [[YLHintView shareHintView] removeLoadAnimation];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *errorDic = @{@"errno":@"-1"};
        self.returnBlock = infoBlock;
        self.returnBlock(errorDic);
        [self dealError: @"网络请求发生错误"];
        [[YLHintView shareHintView] removeLoadAnimation];
    }];
    
}




#pragma mark - 基础请求方法
//放入请求头
- (void)postWithURL:(NSString *)requestURL param:(NSDictionary *)paramDic showToast:(BOOL)showToast needToken:(BOOL)needToken returnBlock:(ReturnBlock)infoBlock {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] getSessionManager: needToken showToast: showToast];
    
    [manager POST:requestURL parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
        NSString *errnos = [NSString stringWithFormat:@"%@",[dict objectForKey:@"errno"]];
        if([errnos isEqualToString:@"0"]){ //成功
            
            
        }else if ([errnos isEqualToString:@"10086"]){//被挤下线
            [YLHintView showMessageOnThisPage:@"登录已过期"];
            POST_LOGINQUIT_NOTIFICATION;
        }else {
            [self dealError: [NSString stringWithFormat:@"%@",[dict objectForKey:@"errmsg"]]];
        }
        self.returnBlock = infoBlock;
        self.returnBlock(dict);
        
        [[YLHintView shareHintView] removeLoadAnimation];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *errorDic = @{@"errno":@"-1"};
        self.returnBlock = infoBlock;
        self.returnBlock(errorDic);
        [self dealError: @"网络请求发生错误"];
        [[YLHintView shareHintView] removeLoadAnimation];
    }];
}

//放入请求体
- (void)postWithURL:(NSString *)requestURL paramBody:(NSDictionary *)paramDic  needToken:(BOOL)needToken showToast:(BOOL)showToast returnBlock:(ReturnBlock)infoBlock {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] getSessionManager: needToken showToast: showToast];
    
    [manager POST:requestURL parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
        NSString *errnos = [NSString stringWithFormat:@"%@",[dict objectForKey:@"errno"]];
        if([errnos isEqualToString:@"0"]){ //成功
            
            
        }else if ([errnos isEqualToString:@"10086"]){//被挤下线
            [YLHintView showMessageOnThisPage:@"登录已过期"];
            POST_LOGINQUIT_NOTIFICATION;
        }else {
            [self dealError: [NSString stringWithFormat:@"%@",[dict objectForKey:@"errmsg"]]];
        }
        self.returnBlock = infoBlock;
        self.returnBlock(dict);
        [[YLHintView shareHintView] removeLoadAnimation];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *errorDic = @{@"errno":@"-1"};
        self.returnBlock = infoBlock;
        self.returnBlock(errorDic);
        //               for (NSString * key in error.userInfo.allKeys) {
        //                   NSLog(@"error key = %@, valeu = %@",key,error.userInfo[key]);
        //                   if ([key isEqualToString:@"com.alamofire.serialization.response.error.data"]) {
        //                       NSData * data = error.userInfo[key];
        //                       NSLog(@"错误dat啊： %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        //
        //                   }
        //               }
        NSLog(@"error ： %@",error);
        [self dealError: @"网络请求发生错误"];
        [[YLHintView shareHintView] removeLoadAnimation];
    }];
    
    
    
}

- (void)getWithURL:(NSString *)requestURL param:(NSDictionary *)paramDic  needToken:(BOOL)needToken showToast:(BOOL)showToast returnBlock:(ReturnBlock)infoBlock {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] getSessionManager: needToken showToast: showToast];
    [manager GET:requestURL parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
        NSString *errnos = [NSString stringWithFormat:@"%@",[dict objectForKey:@"errno"]];
        if([errnos isEqualToString:@"0"]){ //成功
            
            
        }else if ([errnos isEqualToString:@"10086"]){//被挤下线
            [YLHintView showMessageOnThisPage:@"登录已过期"];
            POST_LOGINQUIT_NOTIFICATION;
        }else {
            [self dealError: [NSString stringWithFormat:@"%@",[dict objectForKey:@"errmsg"]]];
        }
        self.returnBlock = infoBlock;
        self.returnBlock(dict);
        [[YLHintView shareHintView] removeLoadAnimation];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *errorDic = @{@"errno":@"-1"};
        
        self.returnBlock = infoBlock;
        self.returnBlock(errorDic);
        [self dealError: @"网络请求发生错误"];
        [[YLHintView shareHintView] removeLoadAnimation];
    }];
}

- (void)deleteWithURL:(NSString *)requestURL param:(NSDictionary *)paramDic  needToken:(BOOL)needToken  showToast:(BOOL)showToast returnBlock:(ReturnBlock)infoBlock {
    
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] getSessionManager: needToken showToast: showToast];
    [manager DELETE:requestURL parameters:paramDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
        NSString *errnos = [NSString stringWithFormat:@"%@",[dict objectForKey:@"errno"]];
        if([errnos isEqualToString:@"0"]){ //成功
            
            
        }else if ([errnos isEqualToString:@"10086"]){//被挤下线
            [YLHintView showMessageOnThisPage:@"登录已过期"];
            POST_LOGINQUIT_NOTIFICATION;
        }else {
            [self dealError: [NSString stringWithFormat:@"%@",[dict objectForKey:@"errmsg"]]];
        }
        self.returnBlock = infoBlock;
        self.returnBlock(dict);
        [[YLHintView shareHintView] removeLoadAnimation];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *errorDic = @{@"errno":@"-1"};
        self.returnBlock = infoBlock;
        self.returnBlock(errorDic);
        [self dealError: @"网络请求发生错误"];
        [[YLHintView shareHintView] removeLoadAnimation];
    }];
}


- (void)putWithURL:(NSString *)requestURL param:(NSDictionary *)paramDic  needToken:(BOOL)needToken showToast:(BOOL)showToast returnBlock:(ReturnBlock)infoBlock {
    AFHTTPSessionManager *manager = [[NetworkManager sharedInstance] getSessionManager: needToken showToast:showToast];
    [manager PUT:requestURL parameters:paramDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
        NSString *errnos = [NSString stringWithFormat:@"%@",[dict objectForKey:@"errno"]];
        if([errnos isEqualToString:@"0"]){ //成功
            
            
        }else if ([errnos isEqualToString:@"10086"]){//被挤下线
            [YLHintView showMessageOnThisPage:@"登录已过期"];
            POST_LOGINQUIT_NOTIFICATION;
        }else {
            [self dealError: [NSString stringWithFormat:@"%@",[dict objectForKey:@"errmsg"]]];
        }
        self.returnBlock = infoBlock;
        self.returnBlock(dict);
        [[YLHintView shareHintView] removeLoadAnimation];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *errorDic = @{@"errno":@"-1"};
        self.returnBlock = infoBlock;
        self.returnBlock(errorDic);
        [self dealError: @"网络请求发生错误"];
        [[YLHintView shareHintView] removeLoadAnimation];
    }];
}


-(void)dealError:(NSString *)errorMessage {
    [YLHintView showMessageOnThisPage: errorMessage];
}

#pragma  mark - 头部文件设置
- (AFHTTPSessionManager *)getSessionManager:(BOOL)needToken showToast:(BOOL)showToast
{
    //    if (sessionManager != nil) {
    //        return  sessionManager;
    //    }
    if (showToast) {
         [[YLHintView shareHintView] loadAnimationShow];
    }
   
    sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    //(这里设置涉及到AFHTTPRequestSerializer  ，AFJSONRequestSerializer java 后台getParameter能否收到参数，AFHTTPRequestSerializer能)测试无效
    
    [sessionManager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [sessionManager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    //[sessionManager.requestSerializer setValue:@"application/form-data" forHTTPHeaderField:@"Content-Type"];
    [sessionManager.requestSerializer setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    //sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil ,nil];
    
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
        [sessionManager.requestSerializer setValue:user.accessToken forHTTPHeaderField:@"token"];
        [sessionManager.requestSerializer setValue:user.userID forHTTPHeaderField:@"userId"];
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
