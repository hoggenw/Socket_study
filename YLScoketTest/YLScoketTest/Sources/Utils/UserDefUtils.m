//
//  UserDefUtils.m
//  qianjituan2.0
//
//  Created by ios-mac on 16/4/13.
//  Copyright © 2016年 ios-mac. All rights reserved.
//

#import "UserDefUtils.h"
#import "YYModel.h"

@implementation UserDefUtils
/**
 *字典本地化存储
 */
+(void)saveDictionary:(NSDictionary *)dictionary forKey:(NSString *)key{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSData *json = [dictionary yy_modelToJSONData];
    [userDef setObject:json forKey:key];
    [userDef synchronize];
    
    
}
/**
 *  字典本地化取出
 */
+(NSDictionary *)getDictionaryForKey:(NSString *)key{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSData *json = [userDef dataForKey:key];
    NSDictionary *returnDictionary = [NSDictionary dictionary];
    if (json.length > 0) {
    returnDictionary=[NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
    }

    return returnDictionary;
}
/**
 *  数组本地化存储
 */
+(void)saveArray:(NSArray *)saveArray forKey:(NSString *)key{
  ;

    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:saveArray forKey:key];
    [userDef synchronize];
}
/**
 *  数组本地化取出
 */
+(NSArray *)getArrayForKey:(NSString *)key{
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSArray *getArray = [userDef arrayForKey:key];

    return getArray;
}
/**
 *  字符串本地化存储
 */
+ (void) saveString:(NSString*)saveString forKey:(NSString *)key {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:saveString forKey:key];
    [userDef synchronize];
}

/**
 *  字符串本地取出
 */
+ (NSString *) getStringForKey:(NSString *)key {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *string=[userDef stringForKey:key];
    return string;
}


#pragma mark - Plist文件数据存储

/**
 Plist数据保存
 
 @param plistName Plist文件名称
 @param dataObj 对象数据（NSMutableDictionary、NSArray）
 @return YES:成功 NO:失败
 */
+ (BOOL)savePlist:(NSString *)plistName dataObj:(NSObject *)dataObj {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [path stringByAppendingPathComponent:plistName];
    if ([dataObj isKindOfClass:[NSMutableDictionary class]]) {
        return [((NSMutableDictionary *)dataObj) writeToFile:plistPath atomically:YES];
    }
    else if ([dataObj isKindOfClass:[NSArray class]]) {
        return [((NSArray *)dataObj) writeToFile:plistPath atomically:YES];
    }
    else {
        return NO;
    }
}

/**
 Plist数据读取
 
 @param plistName Plist文件名称
 @param dataClass 数据类型
 @return 对象数据
 */
+ (nullable id)readPlist:(NSString *)plistName dataClass:(Class)dataClass {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [path stringByAppendingPathComponent:plistName];
    if ([dataClass isSubclassOfClass:[NSMutableDictionary class]]) {
        return [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }
    else if ([dataClass isSubclassOfClass:[NSArray class]]) {
        return [NSMutableArray arrayWithContentsOfFile:plistPath];
    }
    else {
        return nil;
    }
}

/**
 Plist数据删除
 
 @param plistName Plist文件名称
 @return YES:成功 NO:失败
 */
+ (BOOL)removePlist:(NSString *)plistName {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [path stringByAppendingPathComponent:plistName];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:plistPath]) {
        [fileManager removeItemAtPath:plistPath error:nil];
    }
    return YES;
}

@end
