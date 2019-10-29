//
//  YLProgressView.m
//  ftxmall
//
//  Created by 王留根 on 2017/9/27.
//  Copyright © 2017年 wanthings. All rights reserved.
//

#import "YLProgressView.h"
#import "NSTimer+Extension.h"



@interface YLProgressView ()

@property(nonatomic, strong) CAShapeLayer * shapeLayer;

@property(nonatomic, assign) NSTimeInterval incInterval;

@property(nonatomic, assign) NSTimeInterval totalTimerInterval;

@property(nonatomic, assign) CGFloat showProgress;

@property(nonatomic, assign) CGFloat startProgress;

@property(nonatomic, strong) NSTimer * progressTimer;

@end

@implementation YLProgressView

-(void)dealloc {
    if (_progressTimer != nil) {
        [_progressTimer invalidate];
        _progressTimer = nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.shapeLayer = [[CAShapeLayer alloc] initWithLayer: self.layer];
        [self.layer addSublayer: self.shapeLayer];
        self.shapeLayer.borderWidth = 1;
        self.shapeLayer.lineWidth = 2;
        self.shapeLayer.fillColor = [[[UIColor blackColor] colorWithAlphaComponent: 0.6] CGColor];
        self.shapeLayer.strokeColor = [[UIColor colorWithHexString: @"#2bb3e7"] CGColor];
        self.shapeLayer.borderColor = [[UIColor colorWithHexString:  @"#2bb3e7"] CGColor];
        self.incInterval = 0.05;
    }
    return  self;
}

-(void)startProgress:(CGFloat) progress{
    self.showProgress = progress;
    self.startProgress = progress;
    self.totalTimerInterval = self.totalTime;
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval: _incInterval target: self selector: @selector(timerProgress) userInfo:nil repeats: YES];
    [self.progressTimer resumeTimer];
    //[[NSTimer alloc] initWithFireDate:[NSDate date] interval: _incInterval target: self selector:@selector(timerProgress) userInfo:nil repeats: YES];
}
    
-(void)timerProgress {
    self.totalTimerInterval = self.totalTimerInterval - self.incInterval ;
    self.showProgress =  (self.totalTime - self.totalTimerInterval)/self.totalTime;
    [self update: self.showProgress];
    if (self.totalTimerInterval < 0) {
        [self stopProgress];
    }
}

- (void)stopProgress {
    if (_progressTimer != nil) {
        [_progressTimer invalidate];
        _progressTimer = nil;
        [self update: 1];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.shapeLayer.cornerRadius = self.frame.size.width / 2.0;
    self.shapeLayer.path = [[self layooutPath] CGPath];
}

- (void)update:(CGFloat) progress {
    [CATransaction begin];
    [CATransaction setValue: (id)kCFBooleanTrue forKey: kCATransactionDisableActions];
    self.shapeLayer.strokeEnd = progress;
    [CATransaction commit];
}

-(UIBezierPath *)layooutPath {
    double Two_M_pI = 2.0 * M_PI;
    double startAngle = 0.75 * Two_M_pI;
    double endAngle = startAngle + Two_M_pI;
    
    CGFloat width = self.frame.size.width;
    CGFloat  borderWidth = self.shapeLayer.borderWidth;
    
    return  [UIBezierPath bezierPathWithArcCenter: CGPointMake( width/2, width/2) radius: width/2 - borderWidth startAngle: startAngle endAngle: endAngle clockwise: YES];

}

@end























