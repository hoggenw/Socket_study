//
//  YLNavigationController.m
//  FTXExperienceStore
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import "YLNavigationController.h"

@interface YLNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation YLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 当导航控制器管理的子控制器自定义了leftBarButtonItem，则子控制器左边缘右滑失效。解决方案一
    self.interactivePopGestureRecognizer.delegate = self;
    self.interactivePopGestureRecognizer.enabled  = YES;    // default is Yes
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - delegate <UIGestureRecognizerDelegate>

// 左滑功能是否开启
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer{
    BOOL sholdBeginFlag = YES;
    
    //判断是否为rootViewController
    if (self.navigationController && self.navigationController.viewControllers.count == 1)
    {
        sholdBeginFlag =  NO;
    }
    // 根据当前控制器的类型决定是否开启
    else if (![self shouldRightSwipeWithChildViewController:self.childViewControllers.lastObject])
    {
        sholdBeginFlag =  NO;
    }
    return sholdBeginFlag;
}

- (BOOL)shouldRightSwipeWithChildViewController:(UIViewController *)childVC
{
    BOOL shouldFlag = YES;
    
    NSArray *notSwipeVCNames = @[];
    for (NSString *vcName in notSwipeVCNames) {
        if ([childVC isKindOfClass:[NSClassFromString(vcName) class]]) {
            shouldFlag = NO;
            break;
        }
    }
    return shouldFlag;
}


@end
