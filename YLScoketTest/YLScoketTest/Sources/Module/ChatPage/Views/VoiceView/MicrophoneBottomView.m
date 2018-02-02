//
//  MicrophoneBottomView.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/2/1.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "MicrophoneBottomView.h"
#import "ExtensionHeader.h"

@interface MicrophoneBottomView()
/**
 *  中间线view
 */
@property (nonatomic,strong) UIView * cenLineView;
/**
 *  中间线layer
 */
@property (nonatomic,strong) CAShapeLayer * cenLineLayer;
/**
 *  底部线view
 */
@property (nonatomic,strong) UIView * bomLineView;
/**
 *  底部线layer
 */
@property (nonatomic,strong) CAShapeLayer * bomLineLayer;
/**
 *  线宽
 */
@property (nonatomic,assign) CGFloat lineWidth;
/**
 *  线的颜色
 */
@property (nonatomic,strong) UIColor * lineColor;

@end


@implementation MicrophoneBottomView

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth lindeColor:(UIColor*)lineColor
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.lineWidth = lineWidth;
        self.lineColor = lineColor;
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp{
    
    self.cenLineView = [[UIView alloc]initWithFrame:CGRectMake(self.width/2 - self.lineWidth/2, 0, self.lineWidth, self.height*0.6)];
    self.cenLineLayer = [self drawOutSideLine:self.cenLineView.bounds color:self.lineColor];
    [self.cenLineView.layer addSublayer:self.cenLineLayer];
    [self addSubview:self.cenLineView];
    
    self.bomLineView = [[UIView alloc]initWithFrame:CGRectMake(self.width*0.3, self.height*0.6 - self.lineWidth/2, self.width*0.4, self.lineWidth)];
    self.cenLineLayer = [self drawOutSideLine:self.bomLineView.bounds color:self.lineColor];
    [self.bomLineView.layer addSublayer:self.cenLineLayer];
    [self addSubview:self.bomLineView];
    
}

- (CAShapeLayer*)drawOutSideLine:(CGRect)frame color:(UIColor*)color{
    CAShapeLayer * Layer = [CAShapeLayer new];
    
    Layer.fillColor = color.CGColor;
    Layer.strokeColor = nil;
    Layer.frame = frame;
    Layer.lineWidth = self.lineWidth;
    Layer.lineCap = kCALineCapRound;
    
    //这个就是画图
    Layer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, frame.size.width, frame.size.height)  cornerRadius: frame.size.width*0.4].CGPath;
    
    return Layer;
}


@end
