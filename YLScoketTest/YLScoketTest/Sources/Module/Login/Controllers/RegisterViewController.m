//
//  RegisterViewController.m
//  YLScoketTest
//
//  Created by hoggen on 2019/11/14.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterViewModel.h"
#import "RegisterView.h"

@interface RegisterViewController ()

@property (nonatomic, strong) RegisterView * registerView;


@property (nonatomic, strong) RegisterViewModel * registerViewModel;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialUserInterface];
    [self bindViewModel];
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
        if (!_registerView.isChecked) {
            [YLHintView showMessageOnThisPage:@"需要你仔细阅读且同意用户协议"];
            return ;
        }
        _registerView.saveBtn.enabled = false;
        NSDictionary * info = @{@"password":_registerView.secretField.text,@"phone":_registerView.phoneField.text,@"name":_registerView.nameField.text,@"code":_registerView.codeField.text};
        _registerViewModel.registerInfo = info;
        
        
    }];
    
    [[_registerView rac_signalForSelector:@selector(showAgreement)] subscribeNext:^(RACTuple * _Nullable x) {
           
    }];
    
}


- (void)bindViewModel {
    @weakify(self)
    _registerViewModel = [RegisterViewModel new];
    [_registerViewModel.registerCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
                 if (x == nil)
                 {
                      _registerView.saveBtn.enabled = true;
                 }
                 else
                 {
                     if (self.successblock) {
                         NSDictionary * info = @{@"password":_registerView.secretField.text,@"phone":_registerView.phoneField.text};
                         self.successblock(info);
                     }
                 }
    }];
    
    
}

@end
