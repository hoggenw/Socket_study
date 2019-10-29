//
//  UILabel+Factory.m
//  iOSProject
//
//  Created by Alexander on 2019/10/28.
//  Copyright © 2019 hoggenWang.com. All rights reserved.
//

#import "UILabel+Factory.h"

@interface LabelMaker ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation LabelMaker
- (LabelMaker *(^)(CGRect))frame
{
    return ^LabelMaker *(CGRect rect){
        self.label.frame = rect;
        return self;
    };
}

- (LabelMaker *(^)(UIFont *))font
{
    return ^LabelMaker *(UIFont *font){
        self.label.font = font;
        return self;
    };
}

- (LabelMaker *(^)(UIColor *))textColor
{
    return ^LabelMaker *(UIColor *textColor){
        self.label.textColor = textColor;
        return self;
    };
}

- (LabelMaker *(^)(UIColor *))backgroundColor
{
    return ^LabelMaker *(UIColor *backgroundColor){
        self.label.backgroundColor = backgroundColor;
        return self;
    };
}

- (LabelMaker *(^)(NSTextAlignment))textAlignment
{
    return ^LabelMaker *(NSTextAlignment textAlignment){
        self.label.textAlignment = textAlignment;
        return self;
    };
}

- (LabelMaker *(^)(NSInteger))numberOfLines
{
    return ^LabelMaker *(NSInteger numberOfLines){
        self.label.numberOfLines = numberOfLines;
        return self;
    };
}

- (LabelMaker *(^)(NSString *text))text
{
    return ^LabelMaker *(NSString *text){
        self.label.text = text;
        return self;
    };
}

- (LabelMaker *(^)(NSAttributedString *attributedText))attributedText
{
    return ^LabelMaker *(NSAttributedString *attributedText){
        self.label.attributedText = attributedText;
        return self;
    };
}

- (LabelMaker *(^)(BOOL))userInteraction
{
    return ^LabelMaker *(BOOL whether){
        self.label.userInteractionEnabled = whether;
        return self;
    };
}

- (LabelMaker *(^)(BOOL))enable
{
    return ^LabelMaker *(BOOL whether){
        self.label.enabled = whether;
        return self;
    };
}

- (LabelMaker *(^)(BOOL))adjustsFontSizeToFitWidth
{
    return ^LabelMaker *(BOOL whether){
        self.label.adjustsFontSizeToFitWidth = whether;
        return self;
    };
}

- (LabelMaker *(^)(CGFloat))minimumScale
{
    return ^LabelMaker *(CGFloat num){
        self.label.minimumScaleFactor = num;
        return self;
    };
}

- (LabelMaker *(^)(UIView *))addToSuperView
{
    return ^LabelMaker *(UIView *superView){
        [superView addSubview:self.label];
        return self;
    };
}

@end

@implementation UILabel (Factory)

+ (instancetype)makeLabel:(void (^)(LabelMaker *make))labelMaker
{
    LabelMaker *maker = [LabelMaker new];
    maker.label = [self new];
    labelMaker(maker);
    return maker.label;
}

@end

