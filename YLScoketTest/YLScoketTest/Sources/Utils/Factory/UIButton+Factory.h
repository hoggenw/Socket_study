//
//  UIButton+Factory.h
//  iOSProject
//
//  Created by Alexander on 2019/10/28.
//  Copyright © 2019 hoggenWang.com. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ButtonMaker  : NSObject
- (ButtonMaker * (^) (CGRect))frame;
- (ButtonMaker *(^)(NSString *, UIControlState))titleForState;
- (ButtonMaker *(^)(NSAttributedString *, UIControlState))attributedTitleForState;
- (ButtonMaker *(^)(UIImage *, UIControlState))imageForState;
- (ButtonMaker *(^)(UIColor *, UIControlState))titleColorForState;
- (ButtonMaker *(^)(UIEdgeInsets))contentEdgeInsets;
- (ButtonMaker *(^)(UIImage *, UIControlState))backgroundImageForState;
- (ButtonMaker *(^)(UIFont *))titleFont;
- (ButtonMaker *(^)(UIColor *))backgroundColor;
- (ButtonMaker *(^)(id _Nonnull,SEL,UIControlEvents))addAction;
- (ButtonMaker *(^)(UIView *))addToSuperView;

@end

@interface UIButton (Factory)

+(instancetype)makeBUtton:(void (^) (ButtonMaker *make))buttonMaker;

@end

NS_ASSUME_NONNULL_END
