//
//  UIImage+Extension.h
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  获取指定颜色的1像素的图片
 *
 *  @param color    图片的颜色
 *
 *  @return 1像素的图片
 */
+ (instancetype)imageWithColor:(UIColor *)color;

//压缩图片大小(长宽同时乘以ratio)
- (UIImage *)compressImage:(float )ratio ;

/**
 *  根据图片的中心点去拉伸图片并返回
 */
- (UIImage *)resizableImageWithCenterPoint;

@end
