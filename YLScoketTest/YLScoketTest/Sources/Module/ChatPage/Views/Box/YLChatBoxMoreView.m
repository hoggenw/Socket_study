//
//  YLChatBoxMoreView.m
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/23.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLChatBoxMoreView.h"

@interface YLChatBoxMoreView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation YLChatBoxMoreView
- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor: [UIColor myColorWithRed:244 green:244 blue:246 alpha:1]];
        [self addSubview:self.topLine];
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}

-(void)setFrame:(CGRect)frame {
    [super setFrame: frame];
    [self.scrollView setFrame:CGRectMake(0, 0.5, frame.size.width, frame.size.height - 18)];
    [self.pageControl setFrame:CGRectMake(0, self.height - 18, frame.size.width, 8)];
}

-(void)setItems:(NSMutableArray *)items {
    _items = items;
    
}

#pragma mark - Getter
- (UIScrollView *) scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        
        // 控制控件是否整页翻动(默认为NO)
        [_scrollView setPagingEnabled:YES];
        [_scrollView setScrollsToTop:NO];
        [_scrollView setDelegate:self];
    }
    return _scrollView;
}

- (UIPageControl *) pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        _pageControl.pageIndicatorTintColor = [UIColor myColorWithRed:188  green: 188 blue: 188 alpha: 0.6];
        [_pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (UIView *) topLine
{
    if (_topLine == nil) {
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        [_topLine setBackgroundColor: [UIColor myColorWithRed:188  green: 188 blue: 188 alpha: 0.6]];
    }
    return _topLine;
}

@end































