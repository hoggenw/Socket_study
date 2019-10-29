//
//  UIImage+Extension.h
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YLImageType) {
    YLImageJpeg,
    YLImagePng,
    YLImageGif,
    YLImageTiif,
    YLImageUnkonw
};

@interface UIImage (Extension)

//添加一个新属性：图片网络链接
@property(nonatomic,copy)NSString *urlString;
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

/**
 * 获取图片类型
 */
- (YLImageType )typeForImageData:(NSData *)data ;

//压缩图片到指定大小()
- (UIImage *)compressImageWithSice:(CGSize )rectSize;
//渐变色的图片
+(UIImage *)gradientImageStartColor:(UIColor *)startColor endColor:(UIColor *) endColor bounds:(CGRect) bounds;

- (void)clearAssociatedObjcet;


- (UIImage *)fixOrientation;                                    //修正图片方向

- (UIImage *)rotation:(UIImageOrientation)orientation;          //设置图片方向

@end
