//
//  YLChatFaceView.m
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/24.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLChatFaceView.h"
#import "YLChatFaceItemView.h"
#import "YLChatFaceMenuVIew.h"
#import "YLChatFaceMenuVIew.h"


#define     HEIGHT_BOTTOM_VIEW          36.0f


@interface YLChatFaceView()<YLChatFaceMenuVIewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) ChatFaceGroup *curGroup;
@property (nonatomic, assign) int curPage;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) YLChatFaceMenuVIew *faceMenuView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *facePageViewArray;


@end
@implementation YLChatFaceView









#pragma mark - Getter
- (UIView *) topLine
{
    if (_topLine == nil) {
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        [_topLine setBackgroundColor: [UIColor myColorWithRed:188 green:188 blue:188 alpha:0.6]];
    }
    
    return _topLine;
    
}
- (YLChatFaceMenuVIew *) faceMenuView
{
    
    if (_faceMenuView == nil) {
        _faceMenuView = [[YLChatFaceMenuVIew alloc] initWithFrame:CGRectMake(0, self.height - HEIGHT_BOTTOM_VIEW, ScreenWidth, HEIGHT_BOTTOM_VIEW)];
        [_faceMenuView setDelegate:self];
        [_faceMenuView setFaceGroupArray:[[ChatFaceHeleper sharedFaceHelper] faceGroupArray]];
    }
    
    return _faceMenuView;
}


- (UIPageControl *) pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        _pageControl.pageIndicatorTintColor = [UIColor myColorWithRed:188 green:188 blue:188 alpha:0.6] ;
        [_pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (NSMutableArray *) facePageViewArray
{
    if (_facePageViewArray == nil) {
        _facePageViewArray = [[NSMutableArray alloc] initWithCapacity:3];
        for (int i = 0; i < 3; i ++) {
            
            YLChatFaceItemView *view = [[YLChatFaceItemView alloc] initWithFrame:self.scrollView.bounds];
            
            [_facePageViewArray addObject:view];
        }
    }
    
    return _facePageViewArray;
}

- (UIScrollView *) scrollView
{
    if (_scrollView == nil) {
        
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setScrollsToTop:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setDelegate:self];
        [_scrollView setPagingEnabled:YES];
        
    }
    
    return _scrollView;
}

@end
