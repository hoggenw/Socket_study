//
//  NSDate+Extension.m
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "NSDate+Extension.h"
#define MINUTE 60
#define HOUR   (60 * MINUTE)
#define DAY    (24 * HOUR)
#define WEEK   (7 * DAY)
#define MONTH  (30 * DAY)
#define YEAR   (365 * DAY)

@implementation NSDate (Extension)


- (NSString *)localDate:(NSDateFormatterStyle)dateStyle {
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
    }
    [formatter setDateStyle:dateStyle];
    [formatter setTimeStyle:dateStyle];
    return [formatter stringFromDate:self];
}

- (NSString *)formatDayOfYear {
    return [self formatDate:@"yyyy-MM-dd"];
}

- (NSString *)formatWeekday {
    return [self formatDate:@"EEEE"];
}

- (NSString *)formatHourAndMinute {
    return [self formatDate:@"HH:mm"];
}

- (NSString *)formatDate:(NSString *)format {
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
    }
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

- (NSString *)timeAgo {
    return [self timeAgo:@"yyyy-MM-dd HH:mm"];
}

- (NSString *)timeAgo:(NSString *)format {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger comps = (NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear);
    NSDate *today = [calendar dateFromComponents:[calendar components:comps fromDate:now]];
    NSDate *current = [calendar dateFromComponents:[calendar components:comps fromDate:self]];
    NSTimeInterval elapsed = fabs([current timeIntervalSinceDate:today]);
    if (elapsed == 0) {
        double elapsedSeconds = fabs([self timeIntervalSinceDate:now]);
        if (elapsedSeconds < MINUTE) {
            return [NSString stringWithFormat:@"%d秒前", (int)elapsedSeconds];
        } else if (elapsedSeconds < MINUTE * 2) {
            return @"1分钟前";
        } else if (elapsedSeconds < HOUR) {
            int minutes = (int)(elapsedSeconds/MINUTE);
            return [NSString stringWithFormat:@"%d分钟前", minutes];
        } else if (elapsedSeconds < 2 * HOUR) {
            return @"1小时前";
        } else {
            int hours = (int)(elapsedSeconds/HOUR);
            return [NSString stringWithFormat:@"%d小时前", hours];
        }
    } else if (elapsed == DAY) {
        return @"昨天";
    } else if (elapsed < WEEK) {
        int days = (int)(elapsed/DAY);
        return [NSString stringWithFormat:@"%d天前", days];
    } else {
        return [self formatDate:format];
    }
}

- (NSString *)countDownBySecond {
    NSDate *now = [NSDate date];
    
    double elapsedSeconds =  -[now timeIntervalSinceDate:self];
    if (elapsedSeconds < 0) {
        return @"活动已结束";
    }else if (elapsedSeconds < MINUTE) {
        return [NSString stringWithFormat:@"%d秒", (int)elapsedSeconds];
    } else if (elapsedSeconds < HOUR) {
        int minutes = (int)(elapsedSeconds/MINUTE);
        int seconds = (int)(elapsedSeconds - (MINUTE * minutes));
        return [NSString stringWithFormat:@"%d:%d", minutes, seconds];
    } else if (elapsedSeconds < DAY) {
        int hours = (int)(elapsedSeconds/HOUR);
        int minutes = (int)((elapsedSeconds - (HOUR * hours))/MINUTE);
        int seconds = (int)(elapsedSeconds - (MINUTE * minutes) - (HOUR * hours));
        return [NSString stringWithFormat:@"%d:%d:%d", hours, minutes, seconds];
    } else {
        int days = (int)(elapsedSeconds/DAY);
        int hours = (int)((elapsedSeconds - (DAY*days))/HOUR);
        int minutes = (int)((elapsedSeconds - (HOUR*hours) - (DAY*days))/MINUTE);
        int seconds = (int)(elapsedSeconds - (MINUTE*minutes) - (HOUR*hours) - (DAY*days));
        return [NSString stringWithFormat:@"%d天%d:%d:%d",days, hours, minutes, seconds];
    }
    
}


- (NSDate *)yesterday {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:-1];
    return [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:self options:0];
}

- (NSDate *)tomorrow {
    return [self future:1];
}

- (NSDate *)future:(NSInteger)day {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    return [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:self options:0];
}

- (NSDate *)beginOfTheWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | kCFCalendarUnitDay fromDate:self];
    NSInteger dayofweek = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
    if (dayofweek == 1) { // if it is sunday
        dayofweek = 8;
    }
    [components setDay:([components day] - (dayofweek - 2))];
    return [calendar dateFromComponents:components];
}

- (NSInteger)weekday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:self];
    return [components weekday];
}

- (NSString *)formatMonthAndDay {
    return [self formatDate:@"MM月dd日"];
}

- (NSString *)formatYYMMDDHHMM {
    return [self formatDate:@"yyyy-MM-dd HH:mm"];
}

- (NSString *)formatMMDDHHMM {
    return [self formatDate:@"MM-dda HH:mm"];
}

- (NSString *)formatMMDD {
    return [self formatDate:@"MM-dd"];
}



/**
 *  按照yyyy-MM-dd进行格式化后，是否是同一天
 */
- (BOOL)isEqualToDay:(NSDate *)otherDay
{
    NSString *dayStr = [self toStringWithFormat:@"yyyy-MM-dd"];
    NSString *otherDayStr = [otherDay toStringWithFormat:@"yyyy-MM-dd"];
    return [dayStr isEqualToString:otherDayStr];
}

/**
 *  格式化输出时间
 *  如：yyyy-MM-dd HH:mm:ss
 *
 */
- (NSString *)toStringWithFormat:(NSString *)format
{
    // 设置 格式化样式
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:format];
    
    //    NSTimeZone *timezone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSTimeZone *timezone = [NSTimeZone systemTimeZone];
    [dateformatter setTimeZone:timezone];
    
    // 设置 时区
    //    [dateformatter setLocale:[NSLocale currentLocale]];
    //    [dateformatter setLocale:[NSLocale currentLocale]];
    //    [dateformatter setTimeZone:[NSTimeZone systemTimeZone]];
    //    [dateformatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSString *strFormResult = [dateformatter stringFromDate:self];
    return strFormResult;
}



/**
 *  将时间字符串按照指定格式转换为时间
 *
 *  @param dateString       时间字符串
 *  @param dateFormatString 时间格式化字符串
 *
 */
+ (NSDate *)dateWithString:(NSString *)dateString formatString:(NSString *)dateFormatString
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:dateFormatString];
    [inputFormatter setLocale:[NSLocale currentLocale]];
    
    //    //[inputFormatter setDateFormat:dateFormatString];
    //    // 设置为UTC时区
    //    // 这里如果不设置为UTC时区，会把要转换的时间字符串定为当前时区的时间（东八区）转换为UTC时区的时间
    //    NSTimeZone *timezone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    //    [inputFormatter setTimeZone:timezone];
    
    NSDate *date = [inputFormatter dateFromString:dateString];
    
    return date;
}

@end
