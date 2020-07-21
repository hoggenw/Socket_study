//
//  BlacklistViewModel.m
//  YLScoketTest
//
//  Created by hoggen on 2020/1/8.
//  Copyright © 2020 ios-mac. All rights reserved.
//

#import "BlacklistViewModel.h"
#import "FiendshipModel.h"

@implementation BlacklistViewModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initSource];
    }
    return self;
}

- (void)initSource
{
    @weakify(self)
      _blackListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString * input) {
          return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
              [[NetworkManager sharedInstance] getWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Blackships_List]  param:nil needToken:true showToast:true returnBlock:^(NSDictionary *returnDict) {
                  
                  if ([@"0" isEqualToString: [NSString stringWithFormat:@"%@", returnDict[@"errno"]]]) {
                      NSArray * users = returnDict[@"data"];
                      NSMutableArray<FiendshipModel *> * friends = [NSMutableArray array];
                      for (NSDictionary * temp in users) {
                          FiendshipModel * model = [FiendshipModel yy_modelWithDictionary: temp];
                         // NSLog(@"%@  ===   %@",model.user.name,model.user.userId);
                          [friends addObject: model];
                      }
                      [subscriber sendNext: friends];
                      [subscriber sendCompleted];
                      //NSLog(@"朋友列表： %@",users);
                  }else {
                      [subscriber sendNext: nil];
                      [subscriber sendCompleted];
                  }
                  
              }];
              return  nil;
          }];
          
      }];
    _deleteBlackshipCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSMutableDictionary * input) {
             return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                 [[NetworkManager sharedInstance] postWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Blackships_Delete]  param:input needToken:true  showToast:true returnBlock:^(NSDictionary *returnDict) {
                     
                     if ([@"0" isEqualToString: [NSString stringWithFormat:@"%@", returnDict[@"errno"]]]) {
                         [subscriber sendNext: @(true)];
                         [subscriber sendCompleted];
                         //NSLog(@"朋友列表： %@",users);
                     }else {
                         [subscriber sendNext: nil];
                         [subscriber sendCompleted];
                     }
                     
                 }];
                 return  nil;
             }];
             
         }];
}

-(void)getBlackList {
    [_blackListCommand execute:nil];
}

-(void)deleteBlackship:(NSMutableDictionary *)input {
    [_deleteBlackshipCommand execute:input];
}
@end
