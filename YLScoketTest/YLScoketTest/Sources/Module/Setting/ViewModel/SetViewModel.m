//
//  SetViewModel.m
//  YLScoketTest
//
//  Created by hoggen on 2019/12/25.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "SetViewModel.h"
#import <SDWebImage/SDImageCache.h>

@implementation SetViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self bindModel];
    }
    return self;
}

-(void)bindModel {
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
    long long folderSize = 0;
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    for(NSString *path in files)
    {
        NSString *filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@", path]];
        folderSize += [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    folderSize += [SDImageCache sharedImageCache].totalDiskSize ;
    double cacheSize = folderSize / 1024.0 / 1024.0;
    self.setData = @[@[@{@"title":@"修改密码",@"addInfo":@"",@"pushController":@"UpdatePasswordControllerViewController"},
                       @{@"title":@"清除缓存",@"addInfo":[NSString stringWithFormat:@"%.2f M", cacheSize]}],
                     @[@{@"title":@"关于我们",@"addInfo":@"",@"pushController":@"KYAboutUsController"},
                       @{@"title":@"当前版本",@"addInfo":kAppVersion}],
                     @[@{@"title":@"隐私权政策",@"addInfo":@"",@"pushController":@"KYProtocalViewController"},
                     @{@"title":@"注册协议",@"addInfo":@"",@"pushController":@"KYProtocalViewController"}]];
    

    
    
}


- (void)quitLogin {
    [_quitLoginCommand execute: nil];
}
@end
