//
//  UIImage+Extension.m
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)


/**
 *  获取指定颜色的1像素的图片
 */
+ (instancetype)imageWithColor:(UIColor *)color
{
    CGFloat imageW = 1;
    CGFloat imageH = 1;
    
    // 1.开启基于位图的图形上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), NO, 0.0);
    // 2.画一个color颜色的矩形框
    [color set];
    UIRectFill(CGRectMake(0, 0, imageW, imageH));
    // 3.拿到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 4.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  根据图片的中心点去拉伸图片并返回
 */
- (UIImage *)resizableImageWithCenterPoint
{
    CGFloat top = (self.size.height * 0.5 - 1); // 顶端盖高度
    CGFloat bottom = top ;                      // 底端盖高度
    CGFloat left = (self.size.width * 0.5 -1);  // 左端盖宽度
    CGFloat right = left;                       // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    UIImage * image = [self resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    return image;
}

//压缩图片大小(长宽同时乘以ratio)
- (UIImage *)compressImage:(float )ratio  {
    
    CGSize imageSize = self.size;
    
    CGFloat width = imageSize.width * ratio;
    CGFloat height = imageSize.height;
    
    CGFloat targetHeight = ratio * height;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, targetHeight));
    [self drawInRect:CGRectMake(0, 0, width, targetHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
