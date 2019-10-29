//
//  LanguageUtil.m
//  iOSProject
//
//  Created by 王留根 on 2019/2/20.
//  Copyright © 2019 hoggenWang.com. All rights reserved.
//

#import "LanguageUtil.h"

@implementation LanguageUtil

+(NSString *)languageForKey:(NSString *)key {
    
    //根据NSUserDefaults的key去取多语言类型
    NSString *laguageType =[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]];
    //在文件目录中确认多语言类型对应的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:laguageType ofType:@"lproj"];
    //在多语言文件中查找label对应的值
    NSString *result = [[NSBundle bundleWithPath:path] localizedStringForKey:key value:nil table:@"Localizable"];
    return result;
}

@end
