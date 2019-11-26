//
//  AppDelegate.m
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "AppDelegate.h"
#import "YLUITabBarViewController.h"
#import "YLSocketRocktManager.h"
#import "AdvertisementViewController.h"
#import "GuidanceViewController.h"
#import "LoginViewController.h"
#import "YLNavigationController.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (void)setTheme{
    [[UINavigationBar appearance] setBarTintColor: ThemeColor ];
    //设置导航栏标题颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置状态栏颜色 在Info.plist中设置UIViewControllerBasedStatusBarAppearance 为NO
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;//改变状态栏的颜色为白色
    //设置返回字体颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], NSForegroundColorAttributeName, nil]
                                             forState:UIControlStateNormal];
}
#pragma mark - 检测网络状态变化
-(void)netWorkChangeEvent
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    NSURL *url = [NSURL URLWithString:@"http://baidu.com"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        self.netWorkStatesCode = status;
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"当前使用的是流量模式");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"当前使用的是wifi模式");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"断网了");
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"变成了未知网络状态");
                break;
                
            default:
                break;
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"netWorkChangeEventNotification" object:@(status)];
    }];
    [manager.reachabilityManager startMonitoring];
}

- (void)setKeyBoard {
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.shouldResignOnTouchOutside = YES;
    keyboardManager.enableAutoToolbar = NO;
    keyboardManager.keyboardDistanceFromTextField = 5.0f;
    
}


#pragma  mark-  application 开始
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //[self setTheme];
    //    [[AccountManager sharedInstance] missLoginDeal];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    
    
    AdvertisementViewController *tb = [AdvertisementViewController new];
    //先判断是否是首次登陆
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {[AdvertisementViewController new];
        GuidanceViewController *guidanceViewController = [GuidanceViewController new];
        self.window.rootViewController = guidanceViewController;
        
    }else {
        //有广告数据才进入广告页面
        NSArray<NSString *> * urlString = [[NSUserDefaults standardUserDefaults] objectForKey: AdvertisementURLs];
        if (urlString != nil && urlString.count > 0) {
            tb.imageUrls = [urlString copy];
            [self.window setRootViewController:tb];
        }else {
            
            if ([AccountManager sharedInstance].isLogin) {
                YLUITabBarViewController * tabarVC = [[YLUITabBarViewController alloc] initWithChildVCInfoArray:  nil];
                self.window.rootViewController = tabarVC;
                POST_SOCKETCONNET_NOTIFICATION;
            }else{
                POST_LOGINQUIT_NOTIFICATION;
            }
            
        }
        
        
    }
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName: Y_Notification_Account_Offline object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [[AccountManager sharedInstance] remove];
        self.window.rootViewController=  [[YLNavigationController alloc] initWithRootViewController:[LoginViewController new]];;
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:Y_Notification_Socket_Connet object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        [ [YLSocketRocktManager shareManger] connect] ;
    }];
    
    
    [self setKeyBoard];
    //注冊消息推送
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    // 2.注册远程推送 或者 用application代理的方式注册
    [application registerForRemoteNotifications];
    
    [self netWorkChangeEvent];
    
    //远程通知调用，未启动app时候需要在此做相关调用
    // 取到url scheme跳转信息 未启动时走这一步
    NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    if (url.absoluteString.length > 0) {
        //NSString * urlString = url.absoluteString;
        //NSLog(@"=============%@",urlString);
        return  YES;
    }
    
    return YES;
}



#pragma mark - deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //ios 13 已经无法获取token
    //    NSString * hexToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
    //                          stringByReplacingOccurrencesOfString: @">" withString: @""]
    //                         stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    NSLog(@"%@", hexToken);
    [YLHintView showAlertMessage:hexToken title:@"获取deviceToken"];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"注册远程通知失败: %@", error);
}

//ios9以上用这个回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    /*
     sourceApplication: 跳转app
     urlString: 为其他app传参的要素
     */
    NSString * urlString = url.absoluteString;
    NSLog(@"=============%@",urlString);
    if ([urlString rangeOfString:@"ss"].location != NSNotFound) {
        
    }
    
    
    return true;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
