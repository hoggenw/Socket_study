//
//  MIneViewModel.m
//  YLScoketTest
//
//  Created by hoggen on 2019/11/20.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "MIneViewModel.h"

@implementation MIneViewModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initSource];
        [self initData];
    }
    return self;
}

- (void)initSource {
    
    _quitLoginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            UserModel * user = [AccountManager sharedInstance].fetch;
            NSDictionary * quitLoginInfo = @{@"userId":user.userID};
            [[NetworkManager sharedInstance] postWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,LoginQuitAPI] paramBody:quitLoginInfo needToken:true returnBlock:^(NSDictionary *returnDict) {
                if ([@"0" isEqualToString: [NSString stringWithFormat:@"%@", returnDict[@"errno"]]]) {
                    [subscriber sendNext: @(true)];
                    [subscriber sendCompleted];
                    
                }else {
                    [subscriber sendNext: nil];
                    [subscriber sendCompleted];
                }
                
            }];
            
            
            return nil;
        }];
    }];
    
}

-(void)initData
{
    self.dataSource = @[ @{@"imageString":@"mine_push_icon",
                           @"title":@"我的发布",
                           @"pushController":@"KYServiceManagerController"},
                         @{@"imageString":@"mine_blackName_icon",
                           @"title":@"黑名单管理",
                           @"pushController":@"KYOrderListViewController"},
                         
                         @{@"imageString":@"mine_help_icon",
                           @"title":@"帮助与反馈",
                           @"pushController":@"KYServiceManagerController"},
                         @{@"imageString":@"mine_setting_icon",
                           @"title":@"设置",
                           @"pushController":@"KYSetViewController"}];
    
}

@end
