//
//  NetworkManager.h
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import <Foundation/Foundation.h>

//返回block
typedef void (^ReturnBlock)(NSDictionary *returnDict);

extern NSString * const BaseUrl;              // 网络请求的BaseUrl
extern NSString * const WebBaseUrl;         // 通用网页的BaseUrl

extern NSString * const SOCKETHOST;

extern uint16_t const SOCKETHOSTPORT;


//注册验证码接口
extern NSString * const RegistCodeAPI;
//登录接口
extern NSString * const LoginAPI;
//用户推送PushToken
extern NSString * const UserPushTokenAPI;
//获取用户信息接口
extern NSString * const UserInfoAPI;
//注册接口
extern NSString * const RegisterAPI;
//退出登录
extern NSString * const LoginQuitAPI;
//更新密码
extern NSString * const UpdatePasswordAPI;
#pragma mark- 用户关系接口
//获取朋友列表
extern NSString * const Friendships_List;
//黑名单列表
extern NSString * const Blackships_List;
//删除黑名单
extern NSString * const Blackships_Delete;
//申请关系列表
extern NSString * const ApplyFriendships_List;
//更新申请信息
extern NSString * const Update_Friendship_info;
//同意好友关系
extern NSString * const Agree_Friendship;
//申请好友
extern NSString * const Create_Friendship;
//删除好友
extern NSString * const Delete_Friendship;
//查询朋友
extern NSString * const Search_Friends;

@interface NetworkManager : NSObject

@property(nonatomic,strong)ReturnBlock returnBlock;
+(instancetype)sharedInstance;

//判断目前App Store版本
- (void)generalGetWithURL:(NSString *)requestURL param:(NSDictionary *)paramDic returnBlock:(ReturnBlock)infoBlock;


// 上传图片接口
-(void)postImageUploadApiParam:(NSData *)data returnBlock:(ReturnBlock)infoBlock;


//放入请求头
- (void)postWithURL:(NSString *)requestURL param:(NSDictionary *)paramDic needToken:(BOOL)needToken showToast:(BOOL)showToast returnBlock:(ReturnBlock)infoBlock;

//放入请求体
- (void)postWithURL:(NSString *)requestURL paramBody:(NSDictionary *)paramDic needToken:(BOOL)needToken showToast:(BOOL)showToast returnBlock:(ReturnBlock)infoBlock;


- (void)getWithURL:(NSString *)requestURL param:(NSDictionary *)paramDic  needToken:(BOOL)needToken showToast:(BOOL)showToast returnBlock:(ReturnBlock)infoBlock;
@end
