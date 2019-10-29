//
//  NSObject+YLKVO.h
//  YLAudioFrequecy
//
//  Created by 王留根 on 2017/12/21.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^YLKVOBlock)(id observedObject, NSString *observedKey, id oldValue, id newValue);

@interface NSObject (YLKVO)
- (void)YLAddObserver:(NSObject *)observer
                forKey:(NSString *)key
             withBlock:(YLKVOBlock)block;

- (void)YLRemoveObserver:(NSObject *)observer forKey:(NSString *)key;

@end
