//
//  YLSliderSelectView.m
//  iOSProject
//
//  Created by 王留根 on 2018/11/26.
//  Copyright © 2018年 hoggenWang.com. All rights reserved.
//

#import "YLSliderSelectView.h"

@interface YLSliderSelectView ()
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) CGFloat mainWidth;
@property (nonatomic, strong) UIView * slider;
@property (nonatomic, assign) NSInteger  selectFlag;
@end

@implementation YLSliderSelectView


- (instancetype)initWithFrame:(CGRect)frame{
    self  =  [super initWithFrame:frame];
    if (self)
    {
        self.slider = [UIView new];
        self.mainWidth = frame.size.width;
        _titles = [NSArray array];
        
    }
    return self;
}

- (void)refreshTitels:(NSArray *)titles {
    for (int i = 0;  i < self.titles.count;  i++) {
        UIButton *sender = [self viewWithTag: (i + 200)];
        NSString * title = [NSString stringWithFormat:@"%@(%@)",_titles[i],titles[i]];
        NSLog(@"%@ == %@",title,titles[i]);
        [sender setTitle:title forState:UIControlStateNormal];
    }
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles;
    self.totalCount = titles.count;
    if (self.mainWidth <= 30) {
        self.mainWidth = ScreenWidth;
    }
    CGFloat width = self.mainWidth / titles.count;
    for (int i = 0; i < titles.count; i++) {
        UIButton * button = [UIButton buttonWithType: UIButtonTypeCustom];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor: [UIColor colorWithHexString:@"333333"] forState: UIControlStateNormal];
        [button setTitleColor: [UIColor colorWithHexString:@"f1516f"] forState: UIControlStateSelected];
        [button.titleLabel setFont: [UIFont boldSystemFontOfSize: 15]];
        [self addSubview:button];
        button.tag = 200 + i;
        [button addTarget:self action:@selector(selectButtonAction:) forControlEvents: UIControlEventTouchUpInside];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(width));
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.left.equalTo(self).offset(i * width);
        }];
        
    }
    UIButton * button = [self viewWithTag: 200];
    [button setSelected: true];
    [self addSubview: _slider];
    self.slider.backgroundColor = [UIColor colorWithHexString:@"f1516f"];
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(2));
        make.bottom.equalTo(self);
        make.centerX.equalTo(self.mas_left).offset(width / 2.0);
        make.width.equalTo(@(width - 30));
    }];
    self.selectFlag =  200;
    if (self.delegate != nil) {
        [self.delegate buttonAction: button.tag];
    }
}

-(void)setType:(NSInteger)type {
    if (type < _titles.count) {
        UIButton *sender = [self viewWithTag: (type + 200)];
        [self selectButtonAction: sender];
    }
}

- (void)selectButtonAction: (UIButton *)sender {
    [self setButtonSelectedToNo];
    [sender setSelected: true];
    if (self.selectFlag == sender.tag) {
        //NSLog(@"测试返回");
        return;
    }
    self.selectFlag = sender.tag;
    //NSLog(@"测试继续");
    CGFloat centerXmargin = (self.mainWidth / self.totalCount) * ((sender.tag - 200) + 0.5);
    [self.slider mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(centerXmargin);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
    
    if (self.delegate != nil) {
        [self.delegate buttonAction: sender.tag];
    }
}



- (void)setButtonSelectedToNo {
    for (int i = 0; i < self.totalCount; i++) {
        UIButton * button = [self viewWithTag: 200 + i];
        [button setSelected: false];
    }
}



@end
