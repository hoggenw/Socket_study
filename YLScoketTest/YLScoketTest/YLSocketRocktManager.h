//
//  YLSocketRocktManager.h
//  YLScoketTest
//
//  Created by 王留根 on 17/2/16.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLSocketRocktManager : NSObject

+ (instancetype)shareManger;

- (void)connect;

- (void)disconnnet;

- (void)sendMassege:(NSString *)message;

- (void)ping;

@end
