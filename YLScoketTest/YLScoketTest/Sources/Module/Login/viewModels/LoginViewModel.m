//
//  LoginViewModel.m
//  YLScoketTest
//
//  Created by Alexander on 2019/10/30.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "LoginViewModel.h"

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
              
            
            return  nil;
        }];
      
    }];
    
    _personalCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
           return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               
              
               return nil;
           }];
       }];
    
}

- (void)setLoginInfo:(NSDictionary *)loginInfo{
    _loginInfo = loginInfo;
    [_loginCommand execute:nil];
}

-(void)setUserId:(NSString *)userId{
    _userId = userId;
    [_personalCommand execute:nil];
}
@end
