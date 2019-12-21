//
//  UITextField+Extension.m
//  YLScoketTest
//
//  Created by hoggen on 2019/12/19.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "UITextField+Extension.h"


@implementation UITextField (Extension)

+ (UITextField *)makeSearchTextFieldWithBackgroundColor:(UIColor *)bColor
                                                   font:(UIFont *)font
                                              textColor:(UIColor *)tColor
                                            placeholder:(NSString *)placeholder
{
    UITextField *textField = [UITextField new];
    textField.backgroundColor = bColor;
    textField.textColor = tColor;
    textField.font = font;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = tColor;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:attrs];
    textField.returnKeyType = UIReturnKeySearch;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.enablesReturnKeyAutomatically = YES;
    
    UIView *leftView = [UIView new];
    leftView.backgroundColor = [UIColor clearColor];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
    }];
    
    UIImageView *searchIcon = [UIImageView new];
    searchIcon.image = IMAGE(@"common_search_icon");
    [leftView addSubview:searchIcon];
    [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftView);
        make.left.equalTo(leftView).mas_offset(10);
        make.height.width.mas_equalTo(14);
    }];

    return textField;
}

@end
