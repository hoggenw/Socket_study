//
//  LoginViewModel.h
//  YLScoketTest
//
//  Created by Alexander on 2019/10/30.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewModel : NSObject
@property (nonatomic, strong) RACCommand *loginCommand;
@property (nonatomic, strong) RACCommand *userInfoCommand;
@property (nonatomic, copy) NSDictionary *loginInfo;
@property (nonatomic, copy) NSDictionary *userInfo;

@end

NS_ASSUME_NONNULL_END
