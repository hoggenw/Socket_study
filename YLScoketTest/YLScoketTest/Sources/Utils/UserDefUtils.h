//
//  UserDefUtils.h
//  qianjituan2.0
//
//  Created by ios-mac on 16/4/13.
//  Copyright © 2016年 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TemporaryPhoneNumber @"temporaryPhoneNumber"
#define TemporaryCountryNumber @"TemporaryCountryNumber"

@interface UserDefUtils : NSObject
/**
 *字典本地化存储
 */
+(void)saveDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;
/**
 *  字典本地化取出
 */
+(NSDictionary *)getDictionaryForKey:(NSString *)key;
/**
 *  数组本地化存储
 */
+(void)saveArray:(NSArray *)saveArray forKey:(NSString *)key;
/**
 *  数组本地化取出
 */
+(NSArray *)getArrayForKey:(NSString *)key;
/**
 *  字符串本地化存储
 */
+ (void) saveString:(NSString*)saveString forKey:(NSString *)key;
/**
 *  字符串本地取出
 */
+ (NSString *) getStringForKey:(NSString *)key;



#pragma mark - Plist文件数据存储

/**
 Plist数据保存
 
 @param plistName Plist文件名称
 @param dataObj 对象数据（NSMutableDictionary、NSArray）
 @return YES:成功 NO:失败
 */
+ (BOOL)savePlist:(NSString *)plistName dataObj:(NSObject *)dataObj;

/**
 Plist数据读取
 
 @param plistName Plist文件名称
 @param dataClass 数据类型
 @return 对象数据
 */
+ (nullable id)readPlist:(NSString *)plistName dataClass:(Class)dataClass;

/**
 Plist数据删除
 
 @param plistName Plist文件名称
 @return YES:成功 NO:失败
 */
+ (BOOL)removePlist:(NSString *)plistName;

@end
