//
//  RegisterViewController.m
//  YLScoketTest
//
//  Created by hoggen on 2019/11/14.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "RegisterViewController.h"

#import "RegisterView.h"

@interface RegisterViewController ()

@property (nonatomic, strong) RegisterView * registerView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialUserInterface];
    // Do any additional setup after loading the view.
}

- (void)initialUserInterface
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"注册";
    _registerView = [RegisterView new];
    [self.view addSubview: _registerView];
    [_registerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kNavigationHeight);
    }];
    
    [[_registerView rac_signalForSelector:@selector(registerAction)] subscribeNext:^(RACTuple * _Nullable x) {
        
    }];
    
    [[_registerView rac_signalForSelector:@selector(showAgreement)] subscribeNext:^(RACTuple * _Nullable x) {
           
    }];
    
    [[_registerView rac_signalForSelector:@selector(codeBtnClick:)] subscribeNext:^(RACTuple * _Nullable x) {
              
       }];
    
    
    
    
}

@end
