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


- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor: [UIColor myColorWithRed:244 green:244 blue:246 alpha: 1]];
        [self addSubview:self.topLine];
        [self addSubview:self.faceMenuView];
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        
    }
    
    return self;
    
}

/**
 *  添加scrollView 添加 pageController
 */

-(void) setFrame:(CGRect)frame
{
    
    [super setFrame:frame];
    [self.scrollView  setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - HEIGHT_BOTTOM_VIEW - 18)];
    [self.pageControl setFrame:CGRectMake(0, self.scrollView.height + 3, frame.size.width, 8)];
    /**
     *  开始就添加三张？
     */
    for (YLChatFaceItemView *pageView in self.facePageViewArray) {
        
        [self.scrollView addSubview:pageView];
    }
}

#pragma mark - YLChatBoxFaceMenuViewDelegate 三个代理方法
- (void) chatBoxFaceMenuView:(YLChatFaceMenuVIew *)chatBoxFaceMenuView didSelectedFaceMenuIndex:(NSInteger)index
{
    
    /**
     *   这个index 就是菜单栏中的表情组的 index ，其实这里是想通过选中的 表情组的index来更新 ScrollView
     */
    _curGroup = [[[ChatFaceHeleper sharedFaceHelper] faceGroupArray] objectAtIndex:index];
    if (_curGroup.facesArray == nil) {
        /**
         *   这个groupID 就是该组特有的 ID 例如，系统表情就是 0 自己添加的一组就是 1 等等
         */
        _curGroup.facesArray = [[ChatFaceHeleper sharedFaceHelper] getFaceArrayByGroupID:_curGroup.groupID];
    }
    
    [self reloadScrollView];
    
}


/**
 *  菜单发送按钮
 */
- (void) chatBoxFaceMenuViewSendButtonDown
{
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxFaceViewDeleteButtonDown)]) {
        
        [_delegate chatBoxFaceViewSendButtonDown];
    }
}


/**
 *  添加表情按钮。方法没有完善好
 */
- (void) chatBoxFaceMenuViewAddButtonDown
{
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxFaceViewSendButtonDown)]) {
        
        [_delegate chatBoxFaceViewSendButtonDown];
    }
}


#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    //
    int page = scrollView.contentOffset.x / self.width;
    if (page > _curPage && (page * ScreenWidth - scrollView.contentOffset.x) < ScreenWidth * 0.2) {
        
        // 向右翻
        [self showFaceFageAtIndex:page];
        
    }
    
    else if (page < _curPage && (scrollView.contentOffset.x - page * ScreenWidth) < ScreenWidth * 0.2) {
        
        [self showFaceFageAtIndex:page];
        
    }
    
}


#pragma mark - Event Response
- (void) didSelectedFace:(UIButton *)sender
{
    if (sender.tag == -1) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxFaceViewDeleteButtonDown)]) {
            
            [_delegate chatBoxFaceViewDeleteButtonDown];
            
        }
    }
    else {
        
        ChatFace *face = [_curGroup.facesArray objectAtIndex:sender.tag];
        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxFaceViewDidSelectedFace:type:)]) {
            
            [_delegate chatBoxFaceViewDidSelectedFace:face type:_curGroup.faceType];
        }
    }
}

- (void) pageControlClicked:(UIPageControl *)pageControl
{
    [self showFaceFageAtIndex:pageControl.currentPage];
    [self.scrollView scrollRectToVisible:CGRectMake(pageControl.currentPage * ScreenWidth, 0, ScreenWidth, self.scrollView.height) animated:YES];
    
}

/**
 *  不同的组对应的pagecontrol 就是不同的，你点击了不同的组，就要重新加载该组的 pageControl和 scrollView
 *
 */
#pragma mark - Private Methods
- (void) reloadScrollView
{
    /**
     *  这里是要计算表情要显示多少页，要不是自己添加的表情，就是一页 20  个这个样显示，要是自己添加的，就是 8 个显示。
     *  这里的 page  计算，有141个表情， /20 = 7   %20 = 1  7+1=8 就是8页。但下面这样子写要是有 142 个呢， 就变成了 9 页。。。
     */
    
    int page = (int)(self.curGroup.facesArray.count / (self.curGroup.faceType == YLFaceTypeEmoji ? 20 : 8)) + (int)(self.curGroup.facesArray.count % (self.curGroup.faceType == YLFaceTypeEmoji ? 20 : 8));
    [self.pageControl setNumberOfPages:page];
    // WIDTH_SCREEN 屏幕宽
    [self.scrollView setContentSize:CGSizeMake(ScreenWidth * page, self.scrollView.height)];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, ScreenWidth, self.scrollView.height) animated:NO];
    _curPage = -1;
    [self showFaceFageAtIndex:0];
    
}

- (void) showFaceFageAtIndex:(NSUInteger)index
{
    
    // 第一次进去 _curPage = -1  第二次 0  返回第一张 1  再回第二张 0
    if (index == _curPage) {
        
        return;
        
    }
    
    [self.pageControl setCurrentPage:index];
    int count = _curGroup.faceType == YLFaceTypeEmoji ? 20 : 8;
    if (_curPage == -1) {
        
        YLChatFaceItemView *pageView1 = [self.facePageViewArray objectAtIndex:0];
        [pageView1 showFaceGroup:_curGroup formIndex:0 count:0];
        [pageView1 setOrigin:CGPointMake(-ScreenWidth, 0)];
        [pageView1 addTarget:self action:@selector(didSelectedFace:) forControlEvents:UIControlEventTouchUpInside];
        
        YLChatFaceItemView *pageView2 = [self.facePageViewArray objectAtIndex:1];
        [pageView2 showFaceGroup:_curGroup formIndex:0 count:count];
        [pageView2 setOrigin:CGPointMake(0, 0)];
        [pageView2 addTarget:self action:@selector(didSelectedFace:) forControlEvents:UIControlEventTouchUpInside];
        
        YLChatFaceItemView *pageView3 = [self.facePageViewArray objectAtIndex:2];
        [pageView3 showFaceGroup:_curGroup formIndex:count count:count];
        [pageView3 addTarget:self action:@selector(didSelectedFace:) forControlEvents:UIControlEventTouchUpInside];
        [pageView3 setOrigin:CGPointMake(ScreenWidth, 0)];
        
    }
    else {
        
        if (_curPage < index) {
            
            YLChatFaceItemView *pageView1 = [self.facePageViewArray objectAtIndex:0];
            [pageView1 showFaceGroup:_curGroup formIndex:(int)(index + 1) * count count:count];
            [pageView1 setOrigin:CGPointMake((index + 1) * ScreenWidth, 0)];
            [self.facePageViewArray removeObjectAtIndex:0];
            [self.facePageViewArray addObject:pageView1];
            
        }
        else {
            
            YLChatFaceItemView *pageView3 = [self.facePageViewArray objectAtIndex:2];
            [pageView3 showFaceGroup:_curGroup formIndex:(int)(index - 1) * count count:count];
            [pageView3 setOrigin:CGPointMake((index - 1) * ScreenWidth, 0)];
            [self.facePageViewArray removeObjectAtIndex:2];
            [self.facePageViewArray insertObject:pageView3 atIndex:0];
            
        }
        
    }
    
    _curPage = (int)index;
}






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
