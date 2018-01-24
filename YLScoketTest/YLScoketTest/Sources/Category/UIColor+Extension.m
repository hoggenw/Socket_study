//
//  UIColor+Extension.m
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (UIColor *)colorWithHex:(long)hexColor
{
    return [self colorWithHex:hexColor alpha:1.0];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(CGFloat)a
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:a];
}

+ (UIColor *)myColorWithRed:(float)r green:(float)g blue:(float)b alpha:(float)a
{
    return [UIColor colorWithRed:r/255.0 green: g/255.0 blue: b/255.0 alpha: a];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSString *removeSharpMarkhexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:removeSharpMarkhexString];
    unsigned result = 0;
    [scanner scanHexInt:&result];
    return [self.class colorWithHex:result];
}

+ (UIColor *)getDarkerColorFromColor1:(UIColor *)color1 color2:(UIColor *)color2 {
    if ([color1 colorNumber] > [color2 colorNumber]) {
        return color2;
    } else {
        return color1;
    }
}

- (float)colorNumber {
    double r,g,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r + g + b + a;
}

@end
