//
//  YLHintView.m
//  ftxmall
//
//  Created by 王留根 on 2017/8/28.
//  Copyright © 2017年 wanthings. All rights reserved.
//

#import "YLHintView.h"
#import "YLLabel.h"
#import "Masonry.h"
#import "MBProgressHUD.h"

@interface YLHintView ()

@property (nonatomic,strong) YLLabel * hintLabel;

@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic,strong)NSTimer *misTimer;

@property(nonatomic,assign)BOOL isExistence;

@property(nonatomic,weak)MBProgressHUD *hud ;

@property (nonatomic, strong)UIView * backView;

@property (nonatomic, strong)UILabel * timeLabel;

@property (nonatomic, strong)MBProgressHUD *progressHUD;


@end

@implementation YLHintView

-(instancetype)init{
    @throw [NSException exceptionWithName:@"" reason:@"不能用此方法构造" userInfo:nil];
}

-(instancetype)initPrivate{
    if (self = [super init]) {
        
    }
    return self;
}

-(void)dealloc{
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
+(instancetype)shareHintView{
    static YLHintView *manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[self alloc]initPrivate];
        }
    });
    return manager;
}


//提示订单未在限定的时间支付取消订单
+(UIView *)hintViewWith:(NSString *)timeString{
    //单例初始化
    YLHintView *manager= [self shareHintView];
    manager.tag = 3333;
    
    if (manager !=  nil) {
        //如果没有显示提示
        if (manager.timeLabel == nil) {
             manager.timeLabel = [UILabel new];
        }else{
            [manager.timeLabel removeFromSuperview];
            manager.timeLabel = nil;
            manager.timeLabel = [UILabel new];
        }
    }

    manager.timeLabel.userInteractionEnabled = YES;
    manager.timeLabel.clipsToBounds = YES;
    manager.timeLabel.textAlignment = NSTextAlignmentLeft;
    manager.timeLabel.font = [UIFont systemFontOfSize:11];
    manager.timeLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    manager.timeLabel.textColor = [UIColor whiteColor];
    manager.timeLabel.text = [NSString stringWithFormat:@"温馨提示:订单提交后%@分钟内未成功支付，订单将自动取消",timeString];
    manager.timeLabel.numberOfLines = 1;
    //初始化成功
    return manager.timeLabel;
}

+(void)deleteButtonAction {
    YLHintView *manager= [YLHintView shareHintView];
    [manager.timeLabel removeFromSuperview];
    manager.timeLabel = nil;
}

/**显示笨页面提示*/
+(void)showMessageOnThisPage:(NSString *)message {
    //单例初始化
    YLHintView *manager= [self shareHintView];
    manager.tag = 3333;
    //初始化成功
    if (manager !=  nil) {
        //如果没有显示提示
        if (manager.hintLabel == nil) {
            [self showHintView:message];
        }else{
            [self hintViewRemoveFromSuperview];
            [self showHintView:message];
            
        }
    }
}
+(void)hintViewRemoveFromSuperview {
    YLHintView *manager = [[[UIApplication sharedApplication].delegate window] viewWithTag:3333];
    [manager.hintLabel removeFromSuperview];
    manager.hintLabel = nil;
    
    if (manager.timer) {
        [manager.timer invalidate];
        manager.timer = nil;
    }
}

+(void)showHintView:(NSString *)message{
    
    YLHintView *manager= [self shareHintView];
    manager.hintLabel = [YLLabel new];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    [[[UIApplication sharedApplication].delegate window] addSubview:manager.hintLabel];
    [manager.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(window.mas_centerX);
        make.centerY.equalTo(window.mas_centerY).offset(-10);
        make.width.greaterThanOrEqualTo(@(100));
        make.width.lessThanOrEqualTo(@(220));
        make.height.greaterThanOrEqualTo(@(43));
    }];
    
    [[[UIApplication sharedApplication].delegate window] addSubview:manager];
    
    manager.hintLabel.layer.cornerRadius = 5;
    manager.hintLabel.userInteractionEnabled = NO;
    manager.hintLabel.clipsToBounds = YES;
    manager.hintLabel.textAlignment = NSTextAlignmentCenter;
    manager.hintLabel.font = [UIFont systemFontOfSize:15];
    manager.hintLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    manager.hintLabel.textColor = [UIColor whiteColor];
    manager.hintLabel.text = message;
    manager.hintLabel.numberOfLines = 0;
    manager.timer = [NSTimer scheduledTimerWithTimeInterval: 1.8 target:self selector:@selector(hintViewRemoveFromSuperview) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:manager.timer
                                 forMode: NSDefaultRunLoopMode];
}

+(void)loadAnimationShow {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [MBProgressHUD showHUDAddedTo:window animated:YES];
}

+(void)removeLoadAnimation {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:window animated:YES];
    });
    
    
}

+(void)loadAnimationShowOnView:(UIView *)sectionView hint:(NSString *)hintString{
    if ([YLHintView shareHintView].progressHUD != nil) {
        [[YLHintView shareHintView].progressHUD removeFromSuperview];
        [YLHintView shareHintView].progressHUD = nil;
    }
    [YLHintView shareHintView].progressHUD = [[MBProgressHUD alloc] init];
    [YLHintView shareHintView].progressHUD.label.text = (hintString == nil? @"加载中..." : hintString); //设置进度框中的提示文字
    [YLHintView shareHintView].progressHUD.label.font = [UIFont systemFontOfSize: 13];
    [YLHintView shareHintView].progressHUD.removeFromSuperViewOnHide = true;
    [sectionView addSubview: [YLHintView shareHintView].progressHUD];
    [[YLHintView shareHintView].progressHUD showAnimated:YES]; //显示进度框
}

+(void)removeLoadAnimationFromView:(UIView *)sectionView  hint:(NSString *)hintString{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[YLHintView shareHintView].progressHUD hideAnimated: YES]; //显示进度框
        [YLHintView shareHintView].progressHUD = nil;
    });
    
}

+(void)loadAnimationShowOnView:(UIView *)sectionView {
    
    [MBProgressHUD showHUDAddedTo:sectionView animated:YES];
}

+(void)removeLoadAnimationFromView:(UIView *)sectionView {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:sectionView animated:YES];
    });
    
}

-(void)loadAnimationShow {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    self.hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
}

-(void)removeLoadAnimation {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [MBProgressHUD hideHUDForView:window animated:YES];
    self.hud = nil;
    
}

+(UIColor *)colorWithHex:(NSInteger)hexRGBValue {
    return [UIColor colorWithRed:(((hexRGBValue & 0xFF0000) >> 16) / 255.0)
                           green:(((hexRGBValue & 0xFF00) >> 8) / 255.0)
                            blue:((hexRGBValue & 0xFF) / 255.0)
                           alpha:1.0];
}

@end
