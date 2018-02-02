//
//  MicrophoneTopView.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/2/1.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "MicrophoneTopView.h"
#import "ExtensionHeader.h"


@interface MicrophoneTopView()
/**
 *  话筒线的view
 */
@property (nonatomic,strong) UIView * outsideLineView;
/**
 *  话筒线的layer
 */
@property (nonatomic,strong,nullable) CAShapeLayer * outsideLineLayer;
/**
 *  话筒view
 */
@property (nonatomic,strong) UIView * colidView;
/**
 *  话筒layer
 */
@property (nonatomic,strong,nullable) CAShapeLayer * colidLayer;
/**
 *  圆弧view
 */
@property (nonatomic,strong) UIView * arcView;
/**
 *  圆弧layer
 */
@property (nonatomic,strong,nullable) CAShapeLayer * arcLayer;
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


@implementation MicrophoneTopView

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth linceColor:(UIColor*)lColor colidColor:(UIColor*)cColor;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.lineColor = lColor;
        self.colidColor = cColor;
        self.lineWidth = lineWidth;
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    //话筒内部
    self.colidView = [[UIView alloc] initWithFrame: CGRectMake(self.width * 0.38, self.height * 0.15, self.width * 0.24, self.height * 0.7)];
    self.colidView.layer.cornerRadius = self.colidView.width * 0.4;
    self.colidView.clipsToBounds = YES;
    self.colidLayer = [self drawOutSideLine: CGRectMake(0, 0, self.colidView.width, 0) color: self.colidColor isFill: YES];
    [self.colidView.layer addSublayer:self.colidLayer];
    [self addSubview:self.colidView];
    
    
    //话筒边框
    self.outsideLineView = [[UIView alloc] initWithFrame:CGRectMake(self.width*0.38, self.height*0.15, self.width*0.24, self.height*0.7)];
    self.outsideLineLayer = [self drawOutSideLine:CGRectMake(0, 0, self.outsideLineView.width, self.outsideLineView.height) color:self.lineColor isFill:NO];
    [self.outsideLineView.layer addSublayer:self.outsideLineLayer];
    [self addSubview:self.outsideLineView];
    
    //话筒弧
    self.arcView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height*0.09, self.width, self.height*0.6)];
    self.arcLayer = [self drawARCLine:self.arcView.center frame:self.arcView.frame color:self.lineColor];
    [self.arcView.layer addSublayer:self.arcLayer];
    [self addSubview:self.arcView];
    
    
}
- (CAShapeLayer*)drawARCLine:(CGPoint)point frame:(CGRect)frame color:(UIColor*)color{
    CAShapeLayer * layer = [CAShapeLayer new];
    layer.fillColor = nil;
    layer.strokeColor = color.CGColor;
    layer.frame = frame;
    layer.lineWidth = self.lineWidth;
    layer.lineCap = kCALineCapRound;
    
    layer.path = [UIBezierPath bezierPathWithArcCenter: CGPointMake(point.x, point.y) radius: frame.size.width*0.3 startAngle: (M_PI * -5)/180 endAngle: (M_PI * 185)/180 clockwise: YES].CGPath;
    
    return layer;
}


//圆角矩形
- (CAShapeLayer*)drawOutSideLine:(CGRect)frame color:(UIColor*)color isFill:(BOOL)fill {
    CAShapeLayer * layer = [CAShapeLayer new];
    if (fill) {
        layer.fillColor = color.CGColor;
        layer.strokeColor = nil;
    }else {
        layer.fillColor = nil;
        layer.strokeColor = color.CGColor;
    }
    layer.frame = frame;
    layer.lineWidth = self.lineWidth;
    layer.lineCap = kCALineCapRound;
    //圆角矩形
    layer.path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, frame.size.width, frame.size.height) cornerRadius: frame.size.width*0.4].CGPath;
    return layer;
    
}

- (void)updateVoiceViewWithVolume:(float)volume{
    CGFloat height = self.colidView.height;
    CGFloat newHeight = height*volume;
    CGFloat width = self.colidView.width;
    
    //    NSLog(@"%f",newHeight);
    self.colidLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, height - newHeight , width , newHeight) cornerRadius:0].CGPath;
    
}
@end

















