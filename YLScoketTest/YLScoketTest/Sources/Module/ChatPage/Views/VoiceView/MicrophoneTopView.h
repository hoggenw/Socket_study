//
//  MicrophoneTopView.h
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/2/1.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MicrophoneTopView : UIView

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth linceColor:(UIColor*)lColor colidColor:(UIColor*)cColor;

/**
 *  设置音量的大小 输入 0.0 ~ 1.0
 *
 *  @param volume 输入 0 ~ 1
 */
- (void)updateVoiceViewWithVolume:(float)volume;

@end
