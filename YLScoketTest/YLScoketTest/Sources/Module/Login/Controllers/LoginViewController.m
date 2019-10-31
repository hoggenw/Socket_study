//
//  LoginViewController.m
//  Vote
//
//  Created by 王留根 on 2018/6/13.
//  Copyright © 2018年 OwnersVote. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "YLUITabBarViewController.h"
#import "LoginViewModel.h"

@interface LoginViewController ()

@property (nonatomic, strong)LoginView * loginView;
@property (nonatomic, assign) NSInteger loginType;
@property (nonatomic, strong) LoginViewModel *viewModel;

@end

@implementation LoginViewController


#pragma mark - Override Methods

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    if (self.loginView.accountTF.text.isEmpty) {
        [self.loginView.accountTF becomeFirstResponder];
    }else{
        [self.loginView.pwdTF becomeFirstResponder];
    }

}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialUI];
    [self bindViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Private Methods
- (void)initialUI {
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"登录";
    self.navigationController.navigationBar.backgroundColor = UIColor.whiteColor;
    
     _loginView = [LoginView new];
    [self.view addSubview: self.loginView];
    [self.loginView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kNavigationHeight + 20);
        make.left.right.bottom.equalTo(self.view);
    }];
    @weakify(self)
    [[_loginView rac_signalForSelector:@selector(registerAction)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        
    }];
    
    
    [[_loginView rac_signalForSelector:@selector(confirmAction:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        RACTupleUnpack(UIButton *btn) = x;
        btn.enabled = false;
        self.viewModel.loginInfo = @{@"username":self.loginView.accountTF.text, @"password":self.loginView.pwdTF.text};
        
    }];
  
}

- (void)bindViewModel {
    @weakify(self)
             
    [[AccountManager sharedInstance] remove];
    _viewModel = [LoginViewModel new];
      [_viewModel.loginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
          @strongify(self)
          if (x == nil)
          {
              self.loginView.confirmBtn.enabled = YES;
          }
          else
          {
              UserModel *model = (UserModel *)x;
              self.viewModel.userId = model.userID;
          }
      }];
      
      [_viewModel.personalCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
          @strongify(self)
          NSLog(@"获取个人数据");
          AppDelegate *AppDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
          YLUITabBarViewController * tabarVC = [[YLUITabBarViewController alloc]initWithChildVCInfoArray:  nil];
         AppDele.window.rootViewController = tabarVC;
             
            
      }];
    
}
#pragma mark - Events



- (void)textFieldValueChanged:(UITextField *)textField
{

    
}

#pragma mark - Public Methods
#pragma mark 选择器代理





#pragma mark - Extension Delegate or Protocol

@end

