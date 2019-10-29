//
//  UILabel+Factory.h
//  iOSProject
//
//  Created by Alexander on 2019/10/28.
//  Copyright © 2019 hoggenWang.com. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LabelMaker : NSObject

- (LabelMaker *(^)(CGRect))frame;
- (LabelMaker *(^)(UIFont *))font;
- (LabelMaker *(^)(UIColor *))textColor;
- (LabelMaker *(^)(UIColor *))backgroundColor;
- (LabelMaker *(^)(NSTextAlignment))textAlignment;
- (LabelMaker *(^)(NSInteger))numberOfLines;
- (LabelMaker *(^)(NSString *text))text;
- (LabelMaker *(^)(NSAttributedString *attributedText))attributedText;
- (LabelMaker *(^)(BOOL))userInteraction;
- (LabelMaker *(^)(BOOL))enable;
- (LabelMaker *(^)(BOOL))adjustsFontSizeToFitWidth;
- (LabelMaker *(^)(CGFloat))minimumScale;
- (LabelMaker *(^)(UIView *))addToSuperView;

@end

@interface UILabel (Factory)

+ (instancetype)makeLabel:(void(^)(LabelMaker *make))labelMaker;

@end

NS_ASSUME_NONNULL_END
