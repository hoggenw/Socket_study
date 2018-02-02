//
//  YLVoiceView.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/2/1.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLVoiceView.h"
#import "TopViewAnimaton.h"
#import "ExtensionHeader.h"
#import "MicrophoneView.h"
#import "AppDelegate.h"

@interface YLVoiceView()
//======================向上扩展的语音输入======================
@property(nonatomic,strong)TopViewAnimaton * arcAnimation;
@property(nonatomic,strong)MicrophoneView * microphoneView;

@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger count;
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


//======================向上扩展的语音输入======================


@end

@implementation YLVoiceView
- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width * 0.4;
    frame = CGRectMake(100, 100, width, width);
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CGRect newFrame = frame;
    CGFloat min = (newFrame.size.width >= newFrame.size.height )?newFrame.size.width:newFrame.size.height;
    newFrame.size.width = min;
    newFrame.size.height = min;
    self = [super initWithFrame:newFrame];
    if (self) {
//        //处理一些默认参数
//        self.isColid = NO;
        self.lineColor = [UIColor greenColor];
        self.colidColor = self.lineColor;
        self.count = 0;
        self.layer.cornerRadius = self.width/2;
        self.clipsToBounds = true;
        self.backgroundColor = [[UIColor brownColor] colorWithAlphaComponent:0.8];
        [window addSubview: self];
        self.center = window.center;
        [self initLineWidth];
        [self addAnimationARCTop];
        [self addMicrophoneView];
        
    }
    return self;
}
- (void)initLineWidth{
    if (self.width <= 50) {
        self.lineWidth = 1.5;
    }else if (self.width <= 100){
        self.lineWidth = 2;
    }else if (self.width <= 200){
        self.lineWidth = 4;
    }else if (self.width <= 300){
        self.lineWidth = 4.5;
    }else{
        self.lineWidth = 6;
    }
    
}

- (void)addAnimationARCTop{
    self.arcAnimation = [[TopViewAnimaton alloc] initWithFrame:CGRectMake(self.width*0.1, self.height*0.25, self.width*0.8, self.height*0.5) lineWidth:self.lineWidth lindeColor:self.colidColor];
    [self addSubview:self.arcAnimation];
}

- (void)addMicrophoneView {
    self.microphoneView = [[MicrophoneView alloc] initColorAndLineWidthWithRect: CGRectMake(self.width*0.3, self.height*0.5, self.width*0.4, self.height*0.5) voiceColor: [UIColor cyanColor] volumeColor: self.colidColor isColid: false lineWidth: self.lineWidth];
    [self addSubview: self.microphoneView];
}

//开始动画
- (void)startAnimation {
    [self.timer resumeTimer];
}

- (void)startARCTopAnimation {
    [self.arcAnimation startAnimation: self.count];
    self.count++;
    if (self.count > 5) {
        self.count = 0;
    }
    
}

- (void)stopArcAnimation{
    [self.timer pauseTimer];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        self.timer = nil;
    }
    self.count = 0;
    [self.arcAnimation stopAnimation];
  

}

- (NSTimer *)timer {
    if (_timer == nil) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval: 0.3 target:self selector:@selector(startARCTopAnimation) userInfo:nil  repeats: YES];
    }
    return _timer;
}

@end




































