//
//  YLChatFaceMenuVIew.m
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/25.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLChatFaceMenuVIew.h"


@interface YLChatFaceMenuVIew()

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIScrollView *scrollView;// 菜单滑动ScrollerView
@property (nonatomic, strong) NSMutableArray *faceMenuViewArray; // faceMenuViewArray 菜单栏上的按钮数组

@end

@implementation YLChatFaceMenuVIew

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.addButton];
        [self addSubview:self.scrollView];
    }
    
    return self;
    
}



@end
