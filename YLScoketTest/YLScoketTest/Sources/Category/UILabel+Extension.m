//
//  UILabel+Extension.m
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

- (instancetype)initWith:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor alignment:(NSTextAlignment )alignment {
    if (self = [super init]) {
        self.textColor = textColor;
        self.font = font;
        self.text = text;
        self.textAlignment = alignment;
    }
    return  self;
}

@end
