//
//  RegisterViewModel.m
//  YLScoketTest
//
//  Created by hoggen on 2019/11/15.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "RegisterViewModel.h"

@implementation RegisterViewModel

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
    _registerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [[NetworkManager sharedInstance] postWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,RegisterAPI] paramBody:_registerInfo needToken:false returnBlock:^(NSDictionary *returnDict) {
                
                NSDictionary * userDic = returnDict[@"data"];
                UserModel * user = [[UserModel alloc] initWithDictionary: userDic];
                [[AccountManager sharedInstance] update: user];
                [subscriber sendNext: user];
                [subscriber sendCompleted];
               
            }];

            return nil;
        }];
        
    }];
    
}

- (void)setRegisterInfo:(NSDictionary *)registerInfo {
    _registerInfo = registerInfo;
    [_registerCommand execute:nil];
    
}
@end
