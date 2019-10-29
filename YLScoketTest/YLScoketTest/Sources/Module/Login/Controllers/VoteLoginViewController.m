//
//  VoteLoginViewController.m
//  Vote
//
//  Created by 王留根 on 2018/6/13.
//  Copyright © 2018年 OwnersVote. All rights reserved.
//

#import "VoteLoginViewController.h"
#import "LoginView.h"
#import "YLUITabBarViewController.h"

@interface VoteLoginViewController ()

@property (nonatomic, strong)LoginView * loginView;
@property (nonatomic, assign) NSInteger loginType;

@end

@implementation VoteLoginViewController


#pragma mark - Override Methods

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Private Methods
- (void)initialUI {
    self.navigationItem.title = @"登录";
    self.navigationController.navigationBar.backgroundColor = UIColor.whiteColor;
    
    self.loginView =  [[[NSBundle mainBundle]loadNibNamed:@"LoginView" owner:self options:nil]firstObject];//初始化这个view，固定方法
    [self.view addSubview: self.loginView];
    [self.loginView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kNavigationHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.loginView.codeTextFeild addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    self.loginView.getCodeType = @"1";
    self.loginType = 2;
    [self.loginView.LoginButton addTarget: self action:@selector(loginButtonAction) forControlEvents: UIControlEventTouchUpInside];
  
}
#pragma mark - Events

-(void)loginButtonAction {
    

    NSDictionary *param = @{@"community_name":self.loginView.phoneNumberTextFeild.text, @"pwd":self.loginView.codeTextFeild.text
                            };
    
    UserModel * user = [UserModel new];
    user.userID = @"1";
    user.name = @"王大大";
    // user.logintType = @"2";
    user.accessToken = @"tokenisthis";
    // user.phone = self.loginView.phoneNumberTextFeild.text;
    [UserDefUtils saveString:self.loginView.phoneNumberTextFeild.text  forKey: @"LoginSucessSaveAccout"];
    [[AccountManager sharedInstance] update: user];
    AppDelegate *AppDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    YLUITabBarViewController * tabarVC = [[YLUITabBarViewController alloc] initWithChildVCInfoArray:  nil];
    AppDele.window.rootViewController = tabarVC;

}

- (void)textFieldValueChanged:(UITextField *)textField
{

    
}

#pragma mark - Public Methods
#pragma mark 选择器代理





#pragma mark - Extension Delegate or Protocol

@end
