//
//  YLUMengHelper.h
//  iOSProject
//
//  Created by 王留根 on 2018/11/19.
//  Copyright © 2018年 hoggenWang.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UShareUI/UShareUI.h>
#import <UserNotificationsUI/UserNotificationsUI.h>
#import <UserNotifications/UserNotifications.h>
#import <UMShare/UMShare.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLUMengHelper : NSObject

/**
 初始化第三方登录和分享
 */
+ (void)UMSocialStart;

/**
 自定义分享
 
 @param title 分享的标题
 @param subTitle 内容
 @param thumbImage 缩略图 url
 @param shareURL 分享的url
 */
+ (void)shareTitle:(NSString *)title subTitle:(NSString *)subTitle thumbImage:(NSString *)thumbImage shareURL:(NSString *)shareURL;


#pragma mark - UM第三方登录
+ (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType completion:(void(^)(UMSocialUserInfoResponse *result, NSError *error))completion;


@end

NS_ASSUME_NONNULL_END
