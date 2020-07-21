//
//  UpdatePasswordViewModel.m
//  YLScoketTest
//
//  Created by hoggen on 2019/12/26.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "UpdatePasswordViewModel.h"

@implementation UpdatePasswordViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

-(void)initData{
    _command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [[NetworkManager sharedInstance] postWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,UpdatePasswordAPI] paramBody:_parame needToken:true showToast:true returnBlock:^(NSDictionary *returnDict) {
                if ([@"0" isEqualToString: [NSString stringWithFormat:@"%@", returnDict[@"errno"]]]) {
                    [subscriber sendNext: @(true)];
                    
                }else {
                    [subscriber sendNext: nil];
                    
                }
                [subscriber sendCompleted];
                
            }];
            
            return nil;
        }];
    }];
}

-(void)setParame:(NSDictionary *)parame{
    _parame = parame;
    
    [self.command execute:nil];
}

@end
