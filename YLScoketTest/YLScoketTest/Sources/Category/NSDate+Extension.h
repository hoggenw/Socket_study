//
//  NSDate+Extension.h
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)


- (NSString *)localDate:(NSDateFormatterStyle)dateStyle;
- (NSString *)formatDayOfYear;
- (NSString *)formatWeekday;
- (NSString *)formatHourAndMinute;
- (NSString *)formatDate:(NSString *)format;
- (NSString *)timeAgo;
- (NSString *)timeAgo:(NSString *)format;
- (NSDate *)yesterday;
- (NSDate *)tomorrow;
- (NSDate *)future:(NSInteger)day;
- (NSDate *)beginOfTheWeek;
- (NSInteger)weekday;
- (NSString *)formatMonthAndDay;
- (NSString *)formatYYMMDDHHMMSS;
- (NSString *)formatMMDDHHMM;
- (NSString *)formatMMDD;
- (NSString *)countDownBySecond;

/**
 *  格式化输出时间  使用UTC时区表示时间
 *  如：yyyy-MM-dd HH:mm:ss
 *
 */
- (NSString *)toStringWithFormat:(NSString *)format;

/**
 *  将时间字符串按照指定格式转换为时间
 *
 *  @param dateString       时间字符串
 *  @param dateFormatString 时间格式化字符串
 *
 */
+ (NSDate *)dateWithString:(NSString *)dateString formatString:(NSString *)dateFormatString;

/**
 *  按照yyyy-MM-dd进行格式化后，是否是同一天
 */
- (BOOL)isEqualToDay:(NSDate *)otherDay;


@end
