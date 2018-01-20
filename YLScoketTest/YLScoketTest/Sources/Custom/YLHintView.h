//
//  YLHintView.h
//  ftxmall
//
//  Created by 王留根 on 2017/8/28.
//  Copyright © 2017年 wanthings. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLHintView : UIView

+(instancetype)shareHintView;
/**显示笨页面提示*/
+(void)showMessageOnThisPage:(NSString *)message;

/**window上显示加载动画*/
+(void)loadAnimationShow ;

/**window上隐藏加载动画*/
+ (void)removeLoadAnimation ;

/**在视图上显示加载动画*/
+(void)loadAnimationShowOnView:(UIView *)sectionView;

/**在视图上移除加载动画*/
+(void)removeLoadAnimationFromView:(UIView *)sectionView ;

/**在视图上显示加载动画*/
+(void)loadAnimationShowOnView:(UIView *)sectionView hint:(NSString *)hintString;

/**在视图上移除加载动画*/
+(void)removeLoadAnimationFromView:(UIView *)sectionView  hint:(NSString *)hintString ;


/**需要自定义的调用此方法*/
-(void)loadAnimationShow;

-(void)removeLoadAnimation;

//提示订单未在限定的时间支付取消订单
+(UIView *)hintViewWith:(NSString *)timeString;
//删除提示订单未在限定的时间支付取消订单
+(void)deleteButtonAction;


//颜色
+(UIColor *)colorWithHex:(NSInteger)hexRGBValue;

@end
