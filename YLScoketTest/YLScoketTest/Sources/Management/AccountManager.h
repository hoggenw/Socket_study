//
//  AccountManager.h
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;
@interface AccountManager : NSObject


+ (instancetype)sharedInstance;
//获取用户模型
- (UserModel *)fetch;
- (void)remove;
- (void)update:(UserModel *)user;
//判断是否登录
- (BOOL)isLogin;
//获取账号或token
- (NSString *)fetchAccessToken;
- (NSString *)fetchUserAccount;
@end
