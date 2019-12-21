//
//  UITextField+Extension.h
//  YLScoketTest
//
//  Created by hoggen on 2019/12/19.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (Extension)

+ (UITextField *)makeSearchTextFieldWithBackgroundColor:(UIColor *)bColor
                                                   font:(UIFont *)font
                                              textColor:(UIColor *)tColor
                                            placeholder:(NSString *)placeholder;

@end

NS_ASSUME_NONNULL_END
