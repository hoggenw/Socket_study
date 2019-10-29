//
//  LanguageUtil.h
//  iOSProject
//
//  Created by 王留根 on 2019/2/20.
//  Copyright © 2019 hoggenWang.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol myProtocol <NSObject>

@required
-(void)name;

@optional

-(void)work;

@end

typedef NS_ENUM(NSInteger,NAMETYPE){
    One = 0,
    Two,
    Three
};


typedef void (^myBlock) (NSString * name, id delegate,NAMETYPE type);
@interface LanguageUtil : NSObject

@property (nonatomic, copy) myBlock block;

+(NSString *)languageForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
