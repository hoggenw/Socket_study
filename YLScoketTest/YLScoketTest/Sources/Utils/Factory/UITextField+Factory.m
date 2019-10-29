//
//  UITextField+Factory.m
//  iOSProject
//
//  Created by Alexander on 2019/10/28.
//  Copyright © 2019 hoggenWang.com. All rights reserved.
//

#import "UITextField+Factory.h"

@interface TextFieldMaker ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation TextFieldMaker
- (TextFieldMaker *(^)(CGRect))frame
{
    return ^TextFieldMaker *(CGRect rect){
        self.textField.frame = rect;
        return self;
    };
}

- (TextFieldMaker *(^)(NSString *))text
{
    return ^TextFieldMaker *(NSString *text){
        self.textField.text = text;
        return self;
    };
}

- (TextFieldMaker *(^)(NSAttributedString *))attributedText
{
    return ^TextFieldMaker *(NSAttributedString *attriburedText){
        self.textField.attributedText = attriburedText;
        return self;
    };
}

- (TextFieldMaker *(^)(UIFont *))font
{
    return ^TextFieldMaker *(UIFont *font){
        self.textField.font = font;
        return self;
    };
}

- (TextFieldMaker *(^)(UIColor *))textColor
{
    return ^TextFieldMaker *(UIColor *color){
        self.textField.textColor = color;
        return self;
    };
}
- (TextFieldMaker *(^)(NSTextAlignment))textAlignment
{
    return ^TextFieldMaker *(NSTextAlignment textAlignment){
        self.textField.textAlignment = textAlignment;
        return self;
    };
}

- (TextFieldMaker *(^)(UITextBorderStyle))borderStyle
{
    return ^TextFieldMaker *(UITextBorderStyle style){
        self.textField.borderStyle = style;
        return self;
    };
}

- (TextFieldMaker *(^)(NSString *))placeholder
{
    return ^TextFieldMaker *(NSString *placeholder){
        self.textField.placeholder = placeholder;
        return self;
    };
}

- (TextFieldMaker *(^)(NSAttributedString *))attributedPlaceholder
{
    return ^TextFieldMaker *(NSAttributedString *attributedPlaceholder){
        self.textField.attributedPlaceholder = attributedPlaceholder;
        return self;
    };
}

- (TextFieldMaker *(^)(BOOL))SizeToFit
{
    return ^TextFieldMaker *(BOOL whether){
        self.textField.adjustsFontSizeToFitWidth = whether;
        return self;
    };
}

- (TextFieldMaker *(^)(id <UITextFieldDelegate>))delegate
{
    return ^TextFieldMaker *(id <UITextFieldDelegate> delegate){
        self.textField.delegate = delegate;
        return self;
    };
}

- (TextFieldMaker *(^)(UIImage *))backgroundImage
{
    return ^TextFieldMaker *(UIImage *image){
        self.textField.background = image;
        return self;
    };
}
- (TextFieldMaker *(^)(UIColor *))backgroundColor
{
    return ^TextFieldMaker *(UIColor *color){
        self.textField.backgroundColor = color;
        return self;
    };
}

- (TextFieldMaker *(^)(UITextFieldViewMode))clearMode
{
    return ^TextFieldMaker *(UITextFieldViewMode mode){
        self.textField.clearButtonMode = mode;
        return self;
    };
}
- (TextFieldMaker *(^)(UIView *))leftView
{
    return ^TextFieldMaker *(UIView *view){
        self.textField.leftView = view;
        return self;
    };
}

- (TextFieldMaker *(^)(UITextFieldViewMode))leftViewMode
{
    return ^TextFieldMaker *(UITextFieldViewMode mode){
        self.textField.leftViewMode = mode;
        return self;
    };
}

- (TextFieldMaker *(^)(UIView *))rightView
{
    return ^TextFieldMaker *(UIView *view){
        self.textField.rightView = view;
        return self;
    };
}

- (TextFieldMaker *(^)(UITextFieldViewMode))rightViewMode
{
    return ^TextFieldMaker *(UITextFieldViewMode mode){
        self.textField.rightViewMode = mode;
        return self;
    };
}

- (TextFieldMaker *(^)(UIKeyboardType))keyboardType
{
    return ^TextFieldMaker *(UIKeyboardType type){
        self.textField.keyboardType = type;
        return self;
    };
}

- (TextFieldMaker *(^)(UIReturnKeyType))returnKeyType
{
    return ^TextFieldMaker *(UIReturnKeyType type){
        self.textField.returnKeyType = type;
        return self;
    };
}

- (TextFieldMaker *(^)(BOOL))enablesReturnKeyAutomatically
{
    return ^TextFieldMaker *(BOOL whether){
        self.textField.enablesReturnKeyAutomatically = whether;
        return self;
    };
}

- (TextFieldMaker *(^)(BOOL))secureTextEntry
{
    return ^TextFieldMaker *(BOOL whether){
        self.textField.secureTextEntry = whether;
        return self;
    };
}

- (TextFieldMaker *(^)(UIView *))addToSuperView
{
    return ^TextFieldMaker *(UIView *superView){
        [superView addSubview:self.textField];
        return self;
    };
}

@end

@implementation UITextField (Factory)
+ (instancetype)makeTextField:(void(^)(TextFieldMaker *make))textFieldMaker
{
    TextFieldMaker *maker = [TextFieldMaker new];
    maker.textField = [self new];
    textFieldMaker(maker);
    return maker.textField;
}

@end
