//
//  UIView+Extension.h
//  ftxmall3.0
//
//  Created by 王留根 on 2017/11/20.
//  Copyright © 2017年 FTXMALL. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum : NSInteger {
    // in 内侧
    /** 线在view内的底部 */
    LineViewSideInBottom = 0,     // 最常用，设置为0
    /** 顶部 */
    LineViewSideInTop,
    /** 左侧 */
    LineViewSideInLeft,
    /** 右侧 */
    LineViewSideInRight,
    // out 外侧
    /** 线在view外的底部 */
    LineViewSideOutBottom,
    LineViewSideOutTop,
    LineViewSideOutLeft,
    LineViewSideOutRight
}LineViewSide;



@interface UIView (Extension)




@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

- (void)topAdd:(CGFloat)add;
- (void)leftAdd:(CGFloat)add;
- (void)widthAdd:(CGFloat)add;
- (void)heightAdd:(CGFloat)add;
/**
 *  向view中某侧添加线条，当为上下方向时需注意
 *
 *  @param side        线条在view的哪侧：底顶上下
 *  @param color       线条颜色
 *  @param height      左右方向为线的高度，上下方向为线的宽度
 *  @param leftMargin  左侧间距，上下方向时为顶部间距
 *  @param rightMargin 右侧间距，上下方向时为底部间距
 */
- (void)addLineWithSide:(LineViewSide)side lineColor:(UIColor *)color lineHeight:(CGFloat)height leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin;


/** 移除所有子控件 */
- (void)removeAllSubViews;

@end
