//
//  UpdatePasswordControllerViewController.m
//  YLScoketTest
//
//  Created by hoggen on 2019/12/26.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "UpdatePasswordControllerViewController.h"
#import "UpdatePasswordView.h"
#import "UpdatePasswordViewModel.h"

@interface UpdatePasswordControllerViewController ()

@property (nonatomic, retain)UpdatePasswordView *mainView;
@property (nonatomic, retain)UpdatePasswordViewModel *viewModel;

@end

@implementation UpdatePasswordControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"修改密码";
        
        self.mainView = [[UpdatePasswordView alloc]init];
        [self.view addSubview:self.mainView];
        
        [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(kNavigationHeight);
            make.left.bottom.right.equalTo(self.view);
        }];
        
        self.viewModel = [[UpdatePasswordViewModel alloc]init];
        
        @weakify(self)
        [self.viewModel.command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            if (x) {
                NSDictionary *result = (NSDictionary *)x;

                POP;
            }
        }];
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wundeclared-selector"
        [[self.mainView rac_signalForSelector:@selector(sureBtnClicked)]subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self)
            if([self.mainView.nowPassword.text isEqualToString:self.mainView.surePassword.text])
            {
                if ([self.mainView.nowPassword.text length] < 0 || [self.mainView.nowPassword.text length] > 20)
                {
                    [YLHintView showMessageOnThisPage:@"密码长度不得大于20位"];
                }
                else
                {
                    RACTupleUnpack(UIButton *btn) = x;
                    btn.enabled = NO;
//                    UserModel *userModel = [UserModel shareModel];
//                    self.viewModel.parame = @{@"newPassword":self.mainView.nowPassword.text,@"oldPassword":self.mainView.oldPassword.text,@"username":userModel.userName};
                }
            }
            else
            {
                [YLHintView showMessageOnThisPage:@"两次输入密码不一致"];
            };
        }];
}

@end
