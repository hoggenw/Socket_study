//
//  MicrophoneView.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/2/1.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "MicrophoneView.h"
#import "ExtensionHeader.h"
#import "MicrophoneTopView.h"
#import "MicrophoneBottomView.h"


@interface MicrophoneView()

/**
 *  话筒顶部
 */
@property (nonatomic,strong) MicrophoneTopView * topView;
/**
 *  话筒底部
 */
@property (nonatomic,strong) MicrophoneBottomView * bomView;
/**
 *  线宽
 */
@property (nonatomic,assign) CGFloat lineWidth;
/**
 *  线的颜色
 */
@property (nonatomic,strong) UIColor * lineColor;
/**
 *  话筒颜色
 */
@property (nonatomic,strong) UIColor * colidColor;

@end

@implementation MicrophoneView


- (instancetype)initColorAndLineWidthWithRect:(CGRect)frame voiceColor:(UIColor* _Nullable)fColor volumeColor:(UIColor* _Nullable)vColor isColid:(BOOL)isColid lineWidth:(CGFloat)lineWidth{
    self = [super initWithFrame: frame];
    if (self) {
        //设置线宽
        self.lineWidth = lineWidth;
        //设置颜色
        self.lineColor = fColor;
        self.colidColor = vColor;
        [self createTopView];
        [self createBottmView];
    }
    return  self;
}

- (void)createTopView{
    self.topView = [[MicrophoneTopView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height*0.7) lineWidth:self.lineWidth linceColor:self.lineColor colidColor:self.colidColor];
    [self addSubview:self.topView];
    
}

- (void)createBottmView{
    self.bomView = [[MicrophoneBottomView alloc]initWithFrame:CGRectMake(0, self.height*0.7, self.width, self.height*0.3) lineWidth:self.lineWidth lindeColor:self.lineColor ];
    [self addSubview:self.bomView];
}

- (void)updateVoiceViewWithVolume:(float)volume{
    [self.topView updateVoiceViewWithVolume:volume];
}

@end
