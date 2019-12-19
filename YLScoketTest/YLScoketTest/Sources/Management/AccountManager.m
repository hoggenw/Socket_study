//
//  AccountManager.m
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "AccountManager.h"
#import "UserModel.h"
#import "YLHintView.h"
#import <SSKeychain/SSKeychain.h>


@interface AccountManager()
@property (nonatomic, strong) UserModel *user;
@end

@implementation AccountManager


-(instancetype)init {
    @throw [NSException exceptionWithName:@"单例类" reason:@"不能用此方法构造" userInfo:nil];
}

-(instancetype)initPrivate {
    if (self = [super init]) {
        
    }
    return  self;
}
+(instancetype)sharedInstance {
    static AccountManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[self alloc] initPrivate];
        }
    });
    return  manager;
}

- (UserModel *)user {
    if (_user == nil) {
        _user = [UserModel new];
    }
    return _user;
}

- (NSString *)fetchAccessToken {
    return [self fetch].accessToken;
}
- (NSString *)fetchUserAccount {
    return [self fetch].phone;
}

- (void)update {
    if (self.user) {
        NSString *bundleIdentifier = [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"];
        NSArray *accounts = [SSKeychain accountsForService:bundleIdentifier];
         NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if (accounts.count > 0) {
            
            NSDictionary *account = accounts.firstObject;
            
            NSString *phoneNumber = account[@"acct"];
            
            [SSKeychain deletePasswordForService:bundleIdentifier account:phoneNumber];
            [userDefaults removeObjectForKey:phoneNumber];
        }
            [SSKeychain setPassword: @"1" forService:bundleIdentifier account: self.user.phone];
            [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_user] forKey: self.user.phone];
            [userDefaults synchronize];
    }
}

- (UserModel *)fetch {
        NSString *bundleIdentifier = [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"];
        NSArray *accounts = [SSKeychain accountsForService:bundleIdentifier];
        if (accounts.count > 0) {
            NSDictionary *account = accounts.firstObject;
            NSString *phoneNumber = account[@"acct"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSData *data = [userDefaults valueForKey:phoneNumber];
            if (data) {
                self.user = (UserModel *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
            }
        }
    
    return self.user;
}

- (void)remove {
    if (self.user) {
        self.user = nil;
        NSString *bundleIdentifier = [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"];
        NSArray *accounts = [SSKeychain accountsForService:bundleIdentifier];
        if (accounts.count > 0) {
            NSDictionary *account = accounts.firstObject;
            NSString *phoneNumber = account[@"acct"];
            [SSKeychain deletePasswordForService:bundleIdentifier account:phoneNumber];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:phoneNumber];
        }
    }
}

- (void)update:(UserModel *)user {
    if (user) {
        self.user = user;
        NSString *bundleIdentifier = [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"];
        NSLog(@"%@",bundleIdentifier);
        NSArray *accounts = [SSKeychain accountsForService:bundleIdentifier];
        if (accounts.count > 0) {
            NSDictionary *account = accounts.firstObject;
            NSString *phoneNumber = account[@"acct"];
            if ([phoneNumber isEqualToString: user.phone]) {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:phoneNumber];
            }else {
                [self update];
            }
           
        }else {
            [self update];
        }
    }
}
#pragma mark - todo登陆z设置为已登录
- (BOOL)isLogin {
    return ([self fetchAccessToken] && [self fetchAccessToken] .length > 0);
}

- (void)missLoginDeal {
    
    self.user.userID = @"";
    self.user.accessToken = @"";
    self.user.phone = @"";
    self.user.paySet = @"";
    self.user.name = @"";
    self.user.loginType = @"";
    [self update];
}

@end
