//
//  LoginViewModel.m
//  YLScoketTest
//
//  Created by Alexander on 2019/10/30.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "LoginViewModel.h"
#import "UserModel.h"

@implementation LoginViewModel
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initSource];
    }
    return self;
}

- (void)initSource {
    _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [[NetworkManager sharedInstance] postWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,LoginAPI] paramBody:_loginInfo needToken:false returnBlock:^(NSDictionary *returnDict) {
                if ([@"0" isEqualToString: [NSString stringWithFormat:@"%@", returnDict[@"errno"]]]) {
                    NSDictionary * userDic = returnDict[@"data"];
                    UserModel * user = [UserModel yy_modelWithDictionary:userDic[@"user"]];
                    user.accessToken = [NSString stringWithFormat:@"%@",userDic[@"token"]];
                    [[AccountManager sharedInstance] update: user];
                    [UserDefUtils saveString:user.phone forKey:@"account"];
                    [subscriber sendNext: user];
                    [subscriber sendCompleted];
                }else {
                    [subscriber sendNext: nil];
                    [subscriber sendCompleted];
                }
                
            }];
            return  nil;
        }];
      
    }];
    
    
    _userInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
           return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               [[NetworkManager sharedInstance] postWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,UserInfoAPI] paramBody:_userInfo needToken:true returnBlock:^(NSDictionary *returnDict) {
                   if ([@"0" isEqualToString: [NSString stringWithFormat:@"%@", returnDict[@"errno"]]]) {
                       
                       NSDictionary * userDic = returnDict[@"data"];
                       NSLog(@"%@",userDic);
                       UserModel * model = [UserModel yy_modelWithDictionary: userDic];
                       [subscriber sendNext: model];
                       [subscriber sendCompleted];
                   }else {
                       [subscriber sendNext: nil];
                       [subscriber sendCompleted];
                   }
                   
               }];
               return  nil;
           }];
         
       }];
    

    
}

- (void)setLoginInfo:(NSDictionary *)loginInfo{
    _loginInfo = loginInfo;
    [_loginCommand execute:nil];
}

-(void)setUserInfo:(NSDictionary *)userInfo {
    _userInfo = userInfo;
      [_userInfoCommand execute: nil];
}




@end
