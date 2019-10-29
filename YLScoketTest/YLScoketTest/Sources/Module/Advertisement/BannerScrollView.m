//
//  BannerScrollView.m
//  test
//
//  Created by 王留根 on 16/4/15.
//  Copyright © 2016年 ios-mac. All rights reserved.
//

#import "BannerScrollView.h"
#import "NSTimer+Extension.h"
#import "YLProgressView.h"
#import "UIImage+GIF.h"

#define VIEW_WIDTH  [[UIScreen mainScreen]bounds].size.width
#define VIEW_HEIGHT CGRectGetHeight(self.bounds)

@interface BannerScrollView ()

@property (nonatomic, strong) NSMutableArray *contentViews;
@property (nonatomic, readonly) NSTimeInterval animationInterval;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *jumpButton;
@property (nonatomic, strong) YLProgressView * progressView ;

@end

@implementation BannerScrollView

- (void)dealloc {
    _scrollView.delegate = nil;
    if (self.animationTimer != nil) {
        [self.animationTimer invalidate];
        self.animationTimer = nil;
    }
}
- (instancetype)initWithFrame:(CGRect)frame duration:(NSTimeInterval)interval urls:(NSArray<NSString *> *)urls{
    self  =  [super initWithFrame:frame];
    
    if (self) {
        if (interval > 0) {
            self.animationTimer  =  [NSTimer scheduledTimerWithTimeInterval:interval
                                                                   target:self
                                                                 selector:@selector(animationTimerDidFire:)
                                                                 userInfo:nil
                                                                  repeats:YES];
            [self.animationTimer pauseTimer];
        }
        _animationInterval  =  interval;
        self.clipsToBounds  =  YES;
        _scrollView  =  [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.scrollsToTop  =  YES;
        _scrollView.pagingEnabled  =  YES;
        _scrollView.delegate  =  self;
        [_scrollView.panGestureRecognizer setEnabled: false];
        _scrollView.contentOffset  =  CGPointMake(0, 0);
        _scrollView.contentSize  =  CGSizeMake(urls.count * VIEW_WIDTH, VIEW_HEIGHT);
        [self addSubview:_scrollView];
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, VIEW_HEIGHT - 30, VIEW_WIDTH, 10)];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.userInteractionEnabled = NO;
        [self addSubview:self.pageControl];
        for (int i = 0; i < urls.count; i ++) {
            UIImageView * imageView = [UIImageView new];
            imageView.frame = CGRectMake(i * VIEW_WIDTH, 0, VIEW_WIDTH, VIEW_HEIGHT);
            imageView.userInteractionEnabled = YES;
            imageView.tag = 200 + i;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapped:)]];
            NSString * imageString =  urls[i];
            if ([[imageString componentsSeparatedByString:@"."].lastObject isEqualToString:@"gif"]) {
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:imageString]];
                SDImageCache* cache = [SDImageCache sharedImageCache];
                //此方法会先从memory中取。
                
                NSData  *imageData  = [cache diskImageDataForKey:key];
                imageView.image = [UIImage sd_imageWithGIFData:imageData];
            }else{
               [imageView sd_setImageWithURL: [NSURL URLWithString: imageString]];
            }
            
            [_scrollView addSubview:imageView];
        }
        _progressView = [[YLProgressView alloc] initWithFrame:CGRectMake(VIEW_WIDTH - 75, VIEW_HEIGHT - 80, 50, 50)];
        [self addSubview: _progressView];
        _jumpButton = [UIButton new];
        _jumpButton.frame = CGRectMake(0, 0, 50, 50);
        _jumpButton.backgroundColor = [UIColor clearColor];
        [_jumpButton setTitle: [NSString stringWithFormat:@"跳过"] forState: UIControlStateNormal];
        [_jumpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _jumpButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [_jumpButton addTarget:self action:@selector(jumpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _jumpButton.clipsToBounds = YES;
        [_progressView addSubview:_jumpButton];
        [self bringSubviewToFront: _pageControl];
    }
    return self;
}

- (void)jumpButtonAction:(UIButton *)sender {
    if (_endActionBlock != nil) {
        self.endActionBlock();
        _scrollView.delegate = nil;
        if (self.animationTimer != nil) {
            [self.animationTimer invalidate];
            self.animationTimer = nil;
          }
    }
}

- (void)contentViewTapped:(UITapGestureRecognizer *)sender {
    long index = sender.view.tag - 200;
    if (_tapActionBlock != nil) {
        _tapActionBlock(index);
    }
}

- (void)timeCountDwon {
    self.totalPages = self.totalPages - 1;
     //[_jumpButton setTitle:[NSString stringWithFormat:@"跳过(%@)", @(self.totalPages)]forState: UIControlStateNormal];
    if (self.totalPages == 0) {
        if (_endActionBlock != nil) {
            _scrollView.delegate = nil;
            if (self.animationTimer != nil) {
                [self.animationTimer invalidate];
                self.animationTimer = nil;
            }
            [self.progressView stopProgress];
            self.endActionBlock();
            
        }
    }
}

// 设置总页数之后，启动动画
- (void)setTotalPageCount:(NSInteger (^)(void))totalPageCount{
    
    self.totalPages  =  totalPageCount();
    if (self.totalPages >=2) {
        self.totalPages = 2;
    }
    self.progressView.totalTime = self.totalPages * _animationInterval;
    self.pageControl.numberOfPages  =  self.totalPages;
    self.currentPageIndex = 0;
    [self.animationTimer resumeTimerAfterInterval:_animationInterval];
    [self.progressView startProgress: 1];
}


- (void)hidePageControl{
    
    self.pageControl.hidden  =  YES;
}


#pragma mark - 响应事件 -

- (void)animationTimerDidFire:(NSTimer *)timer{
    self.currentPageIndex += 1;
    self.currentPageIndex = self.currentPageIndex >= 2 ? 2 : self.currentPageIndex;
   // NSLog(@"========================%@======================%@====",@(self.currentPageIndex),@(VIEW_WIDTH * self.currentPageIndex));
     [self.scrollView setContentOffset:CGPointMake(VIEW_WIDTH * self.currentPageIndex, 0) animated:YES];
    
    [self timeCountDwon];
}

#pragma mark - Scroll view delegate -

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.animationTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.animationTimer resumeTimerAfterInterval: 1];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    self.pageControl.currentPage  =  self.currentPageIndex;
}
//减速停止时执行
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
   // [scrollView setContentOffset:CGPointMake(VIEW_WIDTH, 0) animated:YES];
}

@end
