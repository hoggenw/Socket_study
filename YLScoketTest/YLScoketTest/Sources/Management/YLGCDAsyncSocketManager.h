//
//  YLGCDAsyncSocketManager.h
//  YLScoketTest
//
//  Created by 王留根 on 17/2/15.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLGCDAsyncSocketManager : NSObject 

+ (instancetype)shareManger;

- (BOOL)connect;

- (void)disconnnet;

- (void)sendMassege:(NSString *)message;

- (void)pullMassege;

@end


































