//
//  UIImage+Extension.m
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "UIImage+Extension.h"
#import <objc/runtime.h>



@implementation UIImage (Extension)

//set方法
- (void)setUrlString:(NSString *)urlString{
    objc_setAssociatedObject(self,
                             &kImageUrlString,
                             urlString,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//get方法
- (NSString *)urlString{
    return objc_getAssociatedObject(self,
                                    &kImageUrlString);
}
//添加一个自定义方法，用于清除所有关联属性
- (void)clearAssociatedObjcet{
    objc_removeAssociatedObjects(self);
}

+(UIImage *)YLImageNamed:(NSString *)name {
    NSLog(@"拦截系统的imageNamed方法");
    //[YLHintView showMessageOnThisPage:@"拦截系统的imageNamed方法"];
    return [UIImage YLImageNamed: name];
}
//
//+(void)load {
//    // 获取两个类的类方法
//    Method m1 = class_getClassMethod([UIImage class], @selector(imageNamed:));
//    Method m2 = class_getClassMethod([UIImage class], @selector(YLImageNamed:));
//    // 开始交换方法实现
//    method_exchangeImplementations(m1, m2);
//}




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

//压缩图片到指定大小()
- (UIImage *)compressImageWithSice:(CGSize )rectSize  {
    
    
    CGFloat width = rectSize.width;
    CGFloat height = rectSize.height;
    
    UIGraphicsBeginImageContext(CGSizeMake(width ,height));
    [self drawInRect:CGRectMake(0, 0, width, height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage *)gradientImageStartColor:(UIColor *)startColor endColor:(UIColor *) endColor bounds:(CGRect) bounds{
    //创建CGContextRef
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    
    //绘制Path
    CGRect rect = bounds;
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPathCloseSubpath(path);
    
    //绘制渐变
    [UIImage drawLinearGradient:gc path:path startColor: startColor.CGColor endColor: endColor.CGColor];
    
    //注意释放CGMutablePathRef
    CGPathRelease(path);
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  img;
}

+ (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


- (YLImageType )typeForImageData:(NSData *)data {
    
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    
    
    switch (c) {
            
        case 0xFF:
            
            return YLImageJpeg;
            
        case 0x89:
            
            return YLImagePng;
            
        case 0x47:
            
            return YLImageGif;
            
        case 0x49:
            
        case 0x4D:
            
            return YLImageTiif;
            
    }
    
    return YLImageUnkonw;
    
}
- (UIImage *)fixOrientation
{
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

- (UIImage *)rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation)
    {
        case UIImageOrientationLeft:
        {
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, self.size.height, self.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
        }
            break;
            
        case UIImageOrientationRight:
        {
            rotate = 33 * M_PI_2;
            rect = CGRectMake(0, 0, self.size.height, self.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
        }
            break;
            
        case UIImageOrientationDown:
        {
            rotate = M_PI;
            rect = CGRectMake(0, 0, self.size.width, self.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
        }
            break;
            
        default:
        {
            rotate = 0.0;
            rect = CGRectMake(0, 0, self.size.width, self.size.height);
            translateX = 0;
            translateY = 0;
        }
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    CGContextScaleCTM(context, scaleX, scaleY);
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), self.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

@end
