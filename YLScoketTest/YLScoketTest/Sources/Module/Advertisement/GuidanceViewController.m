//
//  GuidanceViewController.m
//  iOSProject
//
//  Created by 王留根 on 2018/11/16.
//  Copyright © 2018年 hoggenWang.com. All rights reserved.
// 引导页

#import "GuidanceViewController.h"
#import "YLUITabBarViewController.h"
#import "YLNavigationController.h"
#import "LoginViewController.h"

#define PAGE_NUMBER 5

@interface GuidanceViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, strong)UIScrollView *scrollView;
@end

@implementation GuidanceViewController


-(void)dealloc {
    self.scrollView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGuide];
}

- (void)initGuide
{
    self.view.backgroundColor = [UIColor whiteColor];
    CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    self.scrollView = [UIScrollView new];
    [self.scrollView setContentSize:CGSizeMake(size.width * PAGE_NUMBER + 1, 0)];
    [self.scrollView setPagingEnabled:YES];  //视图整页显示
    [self.scrollView setBounces:NO]; //避免弹跳效果,避免把根视图露出来
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    //    UIPageControl *pageControl = [[UIPageControl alloc] init];
    //
    //    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    //    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    //    pageControl.numberOfPages = PAGE_NUMBER;
    
    
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [imageview setImage:[UIImage imageNamed:@"guide-page1.png"]];
    [self.scrollView addSubview:imageview];
    
    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(size.width, 0, size.width, size.height)];
    [imageview1 setImage:[UIImage imageNamed:@"guide-page2.png"]];
    [self.scrollView addSubview:imageview1];

    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(size.width*2, 0, size.width, size.height)];;
    [imageview2 setImage:[UIImage imageNamed:@"guide-page3.png"]];
    [self.scrollView addSubview:imageview2];

    UIImageView *imageview3 = [[UIImageView alloc] initWithFrame:CGRectMake(size.width*3, 0, size.width, size.height)];
    [imageview3 setImage:[UIImage imageNamed:@"guide-page4.png"]];
    [self.scrollView addSubview:imageview3];

    UIImageView *imageview4 = [[UIImageView alloc] initWithFrame:CGRectMake(size.width*4, 0, size.width, size.height)];
    [imageview4 setImage:[UIImage imageNamed:@"guide-page5.png"]];
    [self.scrollView addSubview:imageview4];
    
    imageview4.userInteractionEnabled = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//在imageview3上加载一个透明的button
    [button addTarget:self action:@selector(goToHomePage) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.alpha = 0.80;
    
    [self.view addSubview:self.scrollView];
    //    [self.view addSubview:pageControl];
    [imageview4 addSubview:backgroundView];
    [imageview4 addSubview:button];
    
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.equalTo(self.view.mas_top).offset(0);
        maker.left.equalTo(self.view.mas_left).offset(0);
        maker.right.equalTo(self.view.mas_right).offset(0);
        maker.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    //    [pageControl mas_makeConstraints:^(MASConstraintMaker *maker) {
    //        maker.bottom.equalTo(self.view.mas_bottom).offset(-20);
    //        maker.centerX.equalTo(self.view.mas_centerX).offset(0);
    //    }];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.bottom.equalTo(imageview4.mas_bottom).offset(-80);
        maker.left.equalTo(imageview4.mas_left).offset(0);
        maker.right.equalTo(imageview4.mas_right).offset(0);
        maker.height.equalTo(@120);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.edges.equalTo(imageview4);
    }];
    
    //    self.pageControl = pageControl;
}

- (void)goToHomePage {
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"firstLaunch"];
        AppDelegate *AppDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
           if ([AccountManager sharedInstance].isLogin) {
               YLUITabBarViewController * tabarVC = [[YLUITabBarViewController alloc] initWithChildVCInfoArray:  nil];
                    AppDele.window.rootViewController = tabarVC;
           }else{
               AppDele.window.rootViewController =  [[YLNavigationController alloc] initWithRootViewController:[LoginViewController new]];;
           }
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX > (PAGE_NUMBER - 1) * ScreenWidth) {
        [self goToHomePage];
    }
    //    self.pageControl.currentPage = lround(scrollView.contentOffset.x / width);
}


@end
