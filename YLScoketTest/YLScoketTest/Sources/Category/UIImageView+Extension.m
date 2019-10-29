//
//  UIImageView+Extension.m
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "UIImageView+Extension.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (Extension)

- (void)setImageWithURL:(nullable NSURL *) url placeholderImage:(nullable UIImage *)image {
    [self sd_setImageWithURL: url placeholderImage: image];
}

@end
