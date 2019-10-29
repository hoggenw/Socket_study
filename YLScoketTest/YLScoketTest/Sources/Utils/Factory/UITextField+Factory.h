//
//  UITextField+Factory.h
//  iOSProject
//
//  Created by Alexander on 2019/10/28.
//  Copyright © 2019 hoggenWang.com. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextFieldMaker : NSObject

- (TextFieldMaker *(^)(CGRect))frame;
- (TextFieldMaker *(^)(NSString *))text;
- (TextFieldMaker *(^)(NSAttributedString *))attributedText;
- (TextFieldMaker *(^)(UIFont *))font;
- (TextFieldMaker *(^)(UIColor *))textColor;
- (TextFieldMaker *(^)(NSTextAlignment))textAlignment;
- (TextFieldMaker *(^)(UITextBorderStyle))borderStyle;
- (TextFieldMaker *(^)(NSString *))placeholder;
- (TextFieldMaker *(^)(NSAttributedString *))attributedPlaceholder;
- (TextFieldMaker *(^)(BOOL))SizeToFit;
- (TextFieldMaker *(^)(id <UITextFieldDelegate>))delegate;
- (TextFieldMaker *(^)(UIImage *))backgroundImage;
- (TextFieldMaker *(^)(UIColor *))backgroundColor;
- (TextFieldMaker *(^)(UITextFieldViewMode))clearMode;
- (TextFieldMaker *(^)(UIView *))leftView;
- (TextFieldMaker *(^)(UITextFieldViewMode))leftViewMode;
- (TextFieldMaker *(^)(UIView *))rightView;
- (TextFieldMaker *(^)(UITextFieldViewMode))rightViewMode;
- (TextFieldMaker *(^)(UIKeyboardType))keyboardType;
- (TextFieldMaker *(^)(UIReturnKeyType))returnKeyType;
- (TextFieldMaker *(^)(BOOL))enablesReturnKeyAutomatically;
- (TextFieldMaker *(^)(BOOL))secureTextEntry;
- (TextFieldMaker *(^)(UIView *))addToSuperView;

@end

@interface UITextField (Factory)

+ (instancetype)makeTextField:(void(^)(TextFieldMaker *make))textFieldMaker;

@end

NS_ASSUME_NONNULL_END
