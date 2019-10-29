//
//  NSObject+JSONExtension.h
//  iOSProject
//
//  Created by 王留根 on 2019/5/14.
//  Copyright © 2019 hoggenWang.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (JSONExtension)
+(instancetype)objectWithDict:(NSDictionary *)dict;
//// 告诉数组中都是什么类型的模型对象
+ (NSDictionary *)modelContainerPropertyGenericClass;
@end

NS_ASSUME_NONNULL_END
