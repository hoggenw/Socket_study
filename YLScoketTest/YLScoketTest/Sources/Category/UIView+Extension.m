//
//  UIView+Extension.m
//  ftxmall3.0
//
//  Created by 王留根 on 2017/11/20.
//  Copyright © 2017年 FTXMALL. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (CGFloat)left {
    return self.frame.origin.x;
}
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (void)leftAdd:(CGFloat)add{
    CGRect frame = self.frame;
    frame.origin.x += add;
    self.frame = frame;
}


- (CGFloat)top {
    return self.frame.origin.y;
}
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (void)topAdd:(CGFloat)add{
    CGRect frame = self.frame;
    frame.origin.y += add;
    self.frame = frame;
}


- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}




- (CGFloat)width {
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)widthAdd:(CGFloat)add {
    CGRect frame = self.frame;
    frame.size.width += add;
    self.frame = frame;
}


- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (void)heightAdd:(CGFloat)add {
    CGRect frame = self.frame;
    frame.size.height += add;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


- (CGPoint)origin {
    return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGSize)size {
    return self.frame.size;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

/**
 *  向view中某侧添加线条，当为上下方向时需注意
 *
 *  @remark     当为底部线条时候，在6及以上应该设置线条宽度为1才能显示
 *
 *  @param side        线条在view的哪侧：底顶上下
 *  @param color       线条颜色
 *  @param height      左右方向为线的高度，上下方向为线的宽度
 *  @param leftMargin  左侧间距，上下方向时为顶部间距
 *  @param rightMargin 右侧间距，上下方向时为底部间距
 */
- (void)addLineWithSide:(LineViewSide)side lineColor:(UIColor *)color lineHeight:(CGFloat)height leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin
{
    UIView *lineView = [[UIView alloc] init];
    [self addSubview:lineView];
    //TODO 这里的约束应修正为最原生的约束，实现完全独立，而不是依赖masonry
    lineView.backgroundColor = color;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        switch (side)
        {
                /**
                 *  优化方案：将水平方向 和 竖直方向 分别处理关键位置，然后统一处理水平和竖直即可。
                 */
                
                // 内侧
                
                // 线条在view的底部
            case LineViewSideInBottom:
                make.bottom.equalTo(self);
                
                make.left.equalTo(self).offset(leftMargin);
                make.right.equalTo(self).offset(-rightMargin);
                make.height.equalTo(@(height));
                break;
                
                // 顶部
            case LineViewSideInTop:
                make.top.equalTo(self);
                
                make.left.equalTo(self).offset(leftMargin);
                make.right.equalTo(self).offset(-rightMargin);
                make.height.equalTo(@(height));
                break;
                
                // 左侧
            case LineViewSideInLeft:
                make.left.equalTo(self);
                
                make.top.equalTo(self).offset(leftMargin);
                make.bottom.equalTo(self).offset(-rightMargin);
                make.width.equalTo(@(height));
                break;
                
                // 右侧
            case LineViewSideInRight:
                make.right.equalTo(self);
                
                make.top.equalTo(self).offset(leftMargin);
                make.bottom.equalTo(self).offset(-rightMargin);
                make.width.equalTo(@(height));
                break;
                
                // 外侧
                
            case LineViewSideOutBottom:
                make.top.equalTo(self.mas_bottom);
                
                make.left.equalTo(self).offset(leftMargin);
                make.right.equalTo(self).offset(-rightMargin);
                make.height.equalTo(@(height));
                break;
                
            case LineViewSideOutTop:
                make.bottom.equalTo(self.mas_top);
                
                make.left.equalTo(self).offset(leftMargin);
                make.right.equalTo(self).offset(-rightMargin);
                make.height.equalTo(@(height));
                break;
                
            case LineViewSideOutLeft:
                make.right.equalTo(self.mas_left);
                
                make.top.equalTo(self).offset(leftMargin);
                make.bottom.equalTo(self).offset(-rightMargin);
                make.width.equalTo(@(height));
                break;
                
            case LineViewSideOutRight:
                make.left.equalTo(self.mas_right);
                
                make.top.equalTo(self).offset(leftMargin);
                make.bottom.equalTo(self).offset(-rightMargin);
                make.width.equalTo(@(height));
                break;
                
            default:
                break;
        }
    }];
}

// 移除所有子控件
- (void)removeAllSubViews
{
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end
