//
//  NetworkManager.h
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import <Foundation/Foundation.h>

//返回block
typedef void (^ReturnBlock)(NSDictionary *returnDict);

@interface NetworkManager : NSObject

@property(nonatomic,strong)ReturnBlock returnBlock;
+(instancetype)sharedInstance;

//判断目前App Store版本
- (void)generalGetWithURL:(NSString *)requestURL param:(NSDictionary *)paramDic returnBlock:(ReturnBlock)infoBlock;
@end
