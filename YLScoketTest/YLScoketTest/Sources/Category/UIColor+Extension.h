//
//  UIColor+Extension.h
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor *)colorWithHex:(long)hexColor alpha:(CGFloat)a;

+ (UIColor *)colorWithHex:(long)hexColor;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIColor *)getDarkerColorFromColor1:(UIColor *)color1 color2:(UIColor *)color2;

+ (UIColor *)myColorWithRed:(float)r green:(float)g blue:(float)b alpha:(float)a;

@end
