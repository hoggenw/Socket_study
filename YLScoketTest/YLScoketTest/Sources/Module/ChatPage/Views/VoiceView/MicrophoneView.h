//
//  MicrophoneView.h
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/2/1.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MicrophoneView : UIView

- (instancetype)initColorAndLineWidthWithRect:(CGRect)frame voiceColor:(UIColor* _Nullable)fColor volumeColor:(UIColor* _Nullable)vColor isColid:(BOOL)isColid lineWidth:(CGFloat)lineWidth;

@end
