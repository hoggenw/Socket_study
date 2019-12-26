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
//            [NetworkRequest requestWithUrl:[NSString stringWithFormat:@"%@%@",REQUEST_HOST,UPDATE_PASSWORD] method:REQUEST_POST parameters:[self.parame mutableCopy] hudShow:YES hudHidden:YES completion:^(id  _Nonnull response, NSError * _Nonnull error) {
//                if (error) {
//                    [subscriber sendNext:nil];
//                }else{
//                    [subscriber sendNext:response];
//                }
//                [subscriber sendCompleted];
//            }];
            return nil;
        }];
    }];
}

-(void)setParame:(NSDictionary *)parame{
    _parame = parame;
    
    [self.command execute:nil];
}

@end
