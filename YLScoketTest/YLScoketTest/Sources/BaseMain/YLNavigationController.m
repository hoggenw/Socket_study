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

#pragma mark - 自定义返回按钮图片
-(NSArray*)customLeftBackButton{
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
   
   // backButton.frame = CGRectMake(0, 0, 40, 16);
    
//    UIImage *image = [UIImage imageCompressForWidth:[UIImage imageNamed:@"bracket_left_black"] targetWidth:18];
    
    UIImage *image = [UIImage imageNamed:@"back_black"];
  
    [backButton setImage:image forState:UIControlStateNormal];
    
    backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [backButton addTarget:self
                   action:@selector(popAction)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    negativeSeperator.width = -20;
    
    // 注意下面这个顺序不要写错了，写错了顺序会导致写不出我们想要的效果
 
    return [NSArray arrayWithObjects:negativeSeperator,backItem,nil];
}

#pragma mark - 返回按钮事件
-(void)popAction
{
    [self popViewControllerAnimated:FALSE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[YLHintView shareHintView] removeLoadAnimation];
   
     if (self.childViewControllers.count >= 1)
       {
           viewController.hidesBottomBarWhenPushed = YES;
       }
    [super pushViewController:viewController animated:animated];
    //替换掉leftBarButtonItem
     if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1) {
         viewController.navigationItem.leftBarButtonItems =[self customLeftBackButton];
     }

}
-(UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [[YLHintView shareHintView] removeLoadAnimation];

    return [super popViewControllerAnimated: animated];
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
