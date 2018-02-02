//
//  TopArcView.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/2/1.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "TopArcView.h"
#import "ExtensionHeader.h"

@interface TopArcView()

@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic,strong) UIColor * lineColor;
@property (nonatomic,assign) float  size;

@end

@implementation TopArcView

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth lindeColor:(UIColor *)lineColor size:(CGFloat)size
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lineWidth = lineWidth;
        self.lineColor = lineColor;
        self.size = size;
        //        self.backgroundColor = [UIColor blueColor];
        self.layer.cornerRadius = self.width / 2;
        [self setUp];
    }
    return self;
}
- (void)setUp {
    self.circleLayer = [CAShapeLayer new];
    self.circleLayer.lineWidth = self.lineWidth*0.5;
    self.circleLayer.fillColor = nil;
    self.circleLayer.strokeColor = self.lineColor.CGColor;
    self.circleLayer.frame = self.bounds;
    self.circleLayer.lineCap = kCALineCapRound;
    self.circleLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.height/2) radius: self.width * self.size startAngle: (M_PI * -60)/180 endAngle: (M_PI * -120)/180 clockwise: NO].CGPath;
    [self.layer addSublayer: self.circleLayer];
}


@end
