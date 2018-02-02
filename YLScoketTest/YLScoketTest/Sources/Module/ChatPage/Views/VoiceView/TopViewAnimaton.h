//
//  TopViewAnimaton.h
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/2/1.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopViewAnimaton : UIView

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth lindeColor:(UIColor *)lineColor;

- (void)startAnimation:(NSInteger)count;
- (void)stopAnimation;

@end
