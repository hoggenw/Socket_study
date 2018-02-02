//
//  TopViewAnimaton.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/2/1.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "TopViewAnimaton.h"
#import "TopArcView.h"

@interface TopViewAnimaton()

@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic,strong) UIColor * lineColor;
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,assign) NSTimeInterval time;

@property (nonatomic,strong) NSMutableArray * views;

@end

@implementation TopViewAnimaton


- (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth lindeColor:(UIColor *)lineColor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lineColor = lineColor;
        self.lineWidth = lineWidth;
        
        [self setUp];
    }
    return self;
}

- (void)setUp{
    //    int startAngle,endAngle;
    double  a[] = {0.1,0.2,0.3,0.4,0.5};
    for (int i = 0; i < 5; i++) {
        [self addLayer:a[i]];
    }
}

- (void)addLayer:(CGFloat)size{
    
    TopArcView *circleView1 = [[TopArcView alloc]initWithFrame:self.bounds lineWidth:self.lineWidth*2 lindeColor:[UIColor grayColor] size:size];
    circleView1.hidden = NO;
    [self addSubview:circleView1];
    
    TopArcView *circleView = [[TopArcView alloc]initWithFrame:self.bounds lineWidth:self.lineWidth*2 lindeColor:self.lineColor size:size];
    circleView.hidden = YES;
    [self addSubview:circleView];
    [self.views addObject:circleView];
}

- (void)startAnimation:(NSInteger)count{
    for (int i = 0; i < 5 ; i++) {
        TopArcView * view = self.views[i];
        if (i<count) {
            [view setHidden:NO];
        }else
            [view setHidden:YES];
        
    }
}
- (void)stopAnimation{
    for (TopArcView * view in self.views) {
        [view setHidden:YES];
    }
}


- (NSMutableArray *)views{
    if (!_views) {
        _views = [NSMutableArray array];
    }
    return _views;
}
@end
