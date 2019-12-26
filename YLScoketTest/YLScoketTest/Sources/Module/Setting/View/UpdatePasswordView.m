//
//  UpdatePasswordView.m
//  YLScoketTest
//
//  Created by hoggen on 2019/12/26.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "UpdatePasswordView.h"



@interface UpdatePasswordView () <UITextFieldDelegate>
@property (nonatomic, retain)UIButton *sureBtn;
@end

@implementation UpdatePasswordView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setSubViews];
    }
    return self;
}
-(void)setSubViews
{
    UIView *backView = [[UIView alloc]init];
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(133);
    }];
    
    
    NSMutableArray *views = [NSMutableArray array];
    for (int index = 0; index<3; index++) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = UIColor.whiteColor;
        [backView addSubview:view];
        [views addObject:view];
    }
    
    self.oldPassword = [UITextField makeTextField:^(TextFieldMaker *make) {
        make.placeholder(@"请输入原密码").delegate(self).clearMode(UITextFieldViewModeWhileEditing).secureTextEntry(YES).addToSuperView(backView);
    }];
    
    self.nowPassword = [UITextField makeTextField:^(TextFieldMaker *make) {
        make.placeholder(@"请输入新密码").delegate(self).clearMode(UITextFieldViewModeWhileEditing).secureTextEntry(YES).addToSuperView(backView);
    }];
    
    self.surePassword = [UITextField makeTextField:^(TextFieldMaker *make) {
        make.placeholder(@"请确认新密码").delegate(self).clearMode(UITextFieldViewModeWhileEditing).secureTextEntry(YES).addToSuperView(backView);
    }];
    
    
    //layout
    [views mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:1 leadSpacing:0 tailSpacing:0];
    [views mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).mas_offset(0);
    }];
    
    NSArray *textFileds = @[self.oldPassword,self.nowPassword,self.surePassword];
    [textFileds mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:1 leadSpacing:0 tailSpacing:0];
    [textFileds mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    self.sureBtn = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.titleFont(FONT(16)).titleForState(@"确认修改",UIControlStateNormal).titleColorForState(UIColor.whiteColor,UIControlStateNormal).addAction(self,@selector(sureBtnClicked),UIControlEventTouchUpInside).addToSuperView(self);
        make.backgroundImageForState([UIImage imageWithColor:RGBA(142, 222, 233, 1)],UIControlStateDisabled);
        make.backgroundImageForState([UIImage imageWithColor:[UIColor colorWithHex:0x1DBDD4]],UIControlStateNormal);
        make.backgroundImageForState([UIImage imageWithColor:RGBA(27, 175, 196, 1)],UIControlStateHighlighted);
    }];
#pragma clang diagnostic pop

    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 43, 0, 43));
        make.top.equalTo(backView.mas_bottom).mas_offset(75);
        make.height.mas_equalTo(44);
    }];
    
    RAC(self.sureBtn,enabled) = [RACSignal combineLatest:@[RACObserve(self,self.oldPassword.text),RACObserve(self,self.nowPassword.text),RACObserve(self,self.surePassword.text)] reduce:^id (NSString *oldPassword,NSString *nowPassword,NSString *surePassword){
        return @((oldPassword.length>0)&&(nowPassword.length>0)&&(surePassword.length>0));
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) return NO;
    else if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"]) return NO;
    return YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.sureBtn.layer.cornerRadius = 4;
    self.sureBtn.clipsToBounds = YES;
}

@end
