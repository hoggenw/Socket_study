//
//  JudgeUtil.m
//  YLScoketTest
//
//  Created by hoggen on 2020/9/7.
//  Copyright © 2020 ios-mac. All rights reserved.
//

#import "JudgeUtil.h"

@implementation JudgeUtil

+ (BOOL)isQiNiuTokenExpire {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //指定时间显示样式: HH表示24小时制 hh表示12小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * qiniuTokenTimeString = [UserDefUtils getStringForKey: @"qiniuTokenTimeString"];
    if (qiniuTokenTimeString.length <= 0 ) {
        return true;
    }
    
    NSDate * qiniuTokenTime = [NSDate dateWithString:qiniuTokenTimeString formatString:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeInterval time = 60 * 60 * 24;//1天
    //得到一年之前的当前时间（-：表回示答向前的时间间隔（即去年），如果没有，则表示向后的时间间隔（即明年））
    NSDate * oneDayLater = [qiniuTokenTime dateByAddingTimeInterval: time];
    
    int result = [NSDate compareDate:oneDayLater withDate: [NSDate date]];
    if (result == 1) {
        return  true;
    }
    
    return false;
}

@end
