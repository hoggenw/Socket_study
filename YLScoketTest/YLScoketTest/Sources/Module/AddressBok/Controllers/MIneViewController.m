//
//  MIneViewController.m
//  YLScoketTest
//
//  Created by Alexander on 2019/10/29.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "MIneViewController.h"
#import "MIneViewModel.h"
@interface MIneViewController ()

@property (nonatomic, strong) MIneViewModel * viewmodel;

@end

@implementation MIneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
    [self bindViewModel];
}

- (void)initUI {
    UIButton * quitButton = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.titleForState(@"退出",UIControlStateNormal).addAction(self,@selector(quit),UIControlEventTouchUpInside);
    }];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:quitButton];
    self.navigationItem.rightBarButtonItem = rightButton;
  
}

- (void)bindViewModel {
    
    _viewmodel = [MIneViewModel new];
    [self.viewmodel.quitLoginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        if (x == nil) {
            
        }else {
            UIWindow *window = [[UIApplication sharedApplication].delegate window];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message: @"确定退出当前账户吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                  POST_LOGINQUIT_NOTIFICATION;
            }];
            
            UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 
            }];
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            [window.rootViewController presentViewController:alertController animated:YES completion:nil];
            
           
        }
        
    }];
    
}

- (void)quit {
    [self.viewmodel.quitLoginCommand execute: nil];
}

@end
