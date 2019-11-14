//
//  RegisterView.m
//  YLScoketTest
//
//  Created by hoggen on 2019/11/14.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "RegisterView.h"


@interface RegisterView ()


/** 电话号码 输入框 */
@property (weak, nonatomic) UITextField * phoneField;
@property (weak, nonatomic)  UILabel * phoneLabelHint;

/** 昵称*/
@property (weak, nonatomic) UITextField * nameField;
@property (weak, nonatomic)  UILabel * nameLabelHint;

/** 验证码 输入框 */
@property (weak, nonatomic) UITextField * codeField;
/** 设置密码 输入框 */
@property (weak, nonatomic) UITextField * secretField;

/** 确认密码 输入框 */
@property (weak, nonatomic) UITextField * secondSecretField;
@property (weak, nonatomic)  UILabel * secretLabelHint;

@property (weak, nonatomic) UIButton * saveBtn;

@property (strong, nonatomic) UIButton * policyButton;

@property (weak, nonatomic) UIButton * secretBtn;

@property (weak, nonatomic) UIButton * secondSecretBtn;

@end


@implementation RegisterView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isChecked = true;
        [self initialUI];
    }
    return self;
}


- (void)initialUI {
    
    // 1.注册 视图
       UIView * infoView = ({
           UIView * view = [[UIView alloc] init];
           [self addSubview:view];
           view.backgroundColor = [UIColor whiteColor];
           [view mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.equalTo(self).offset(20);
               make.right.equalTo(self).offset(-20);
               make.top.equalTo(self).offset(20);
           }];
           view;
       });
       [self initialInfoView:infoView];

     #pragma clang diagnostic ignored "-Wundeclared-selector"
    UIButton * regiterButton = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.titleForState(@"注   册",UIControlStateNormal).titleFont(FONT(17)).addAction(self,@selector(registerAction),UIControlEventTouchUpInside).backgroundImageForState([UIImage imageWithColor:UIColor.blueColor], UIControlStateNormal).backgroundImageForState([UIImage imageWithColor:UICOLOR(0x8EDEE9)], UIControlStateDisabled).addToSuperView(self);
    }];
    regiterButton.layer.cornerRadius = 6;
    regiterButton.clipsToBounds = true;
    [regiterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(infoView.mas_bottom).offset(30);
        make.height.equalTo(@(38));
    }];
    _saveBtn = regiterButton;
    
    _policyButton = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.titleForState(@" 我已阅读并同意",UIControlStateNormal).titleFont(FONT(13)).addAction(self,@selector(checkPolicy),UIControlEventTouchUpInside).titleColorForState(UICOLOR(0x333333), UIControlStateNormal).addToSuperView(self);
    }];
    [_policyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(_saveBtn.mas_bottom).offset(15);
        make.height.equalTo(@(30));
        make.bottom.equalTo(self.mas_bottom).offset(-20);
    }];
    _policyButton.enabled = true;
    
    UILabel * button3 =  [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@" 《7聊用户协议》 ").font(FONT(13)).textColor(UIColor.redColor).addToSuperView(self);
    }];
    UITapGestureRecognizer *dtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAgreement)];
    [button3 addGestureRecognizer:dtap];
    [button3 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_policyButton.mas_right);
         make.height.top.bottom.equalTo(_policyButton);
        
    }];
    [self checkPolicy];
       
    [self bindRC];
    
    
    
    
}

-(void)bindRC {
    
    RAC(self.saveBtn,enabled) = [RACSignal combineLatest:@[self.secretField.rac_textSignal,self.secondSecretField.rac_textSignal,self.phoneField.rac_textSignal,self.codeField.rac_textSignal,self.nameField.rac_textSignal] reduce:^id _Nonnull(NSString *pwdF, NSString *pwd, NSString *phone, NSString *code,NSString *name){
        if (pwdF.length > 0 && pwd.length > 0 && phone.length > 0 && code.length > 0 && name.length > 0 && name.length <= 10 && pwdF.length < 20) {
            
            BOOL equal = [pwdF isEqualToString: pwd];
          
            return @(equal && phone.isPhoneNumber);
        }
        
        return @(false);
    }];
    
   RAC(self.phoneLabelHint,text) = [RACSignal combineLatest:@[self.phoneField.rac_textSignal] reduce:^id _Nonnull(NSString *phone){
        if ( phone.length > 0 ) {
            return phone.isPhoneNumber ? @"": @"输入合规的中国大陆电话号码";
        }
       return @"";
    }];
    
    RAC(self.secretLabelHint,text) = [RACSignal combineLatest:@[self.secretField.rac_textSignal,self.secondSecretField.rac_textSignal] reduce:^id _Nonnull(NSString *pwdF, NSString *pwd){
        if (pwdF.length > 0 && pwd.length > 0 && pwdF.length < 20) {
            
            BOOL equal = [pwdF isEqualToString: pwd];
            return equal ? @"": @"设置两次密码需要一致";
        }
        
       return @"";
    }];
    
    RAC(self.nameLabelHint,text) = [RACSignal combineLatest:@[self.nameField.rac_textSignal] reduce:^id _Nonnull(NSString *name){
           if ( name.length >= 15) {
               return  @"昵称需要在1-10个字符j之间";
           }
           
          return @"";
       }];
    
  

    
}



- (void)initialInfoView:(UIView *)infoView
{
    CGFloat viewHeight = 40;
    CGFloat intervalHeight = 20;
    
    // 1.电话 输入框
    UIView *phoneView = ({
        UIView *view = [[UIView alloc] init];
        [infoView addSubview:view];
        [self setUpLineView:view leftTitle:@"手机号" bottomNeedLine:YES];
        UITextField *textField = nil;
        [self setUpRightInLineView:view rightField:&textField placeHolder:@"请输入您的手机号码" widthString:@"手机号"];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(infoView);
            make.top.equalTo(infoView);
            make.height.equalTo(@(viewHeight));
        }];
        self.phoneField = textField;
        self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
        view;
    });
    _phoneLabelHint =  [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
           make.text(@"").font(FONT(13)).textColor(UIColor.redColor).addToSuperView(self);
       }];
    [_phoneLabelHint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(infoView);
        make.top.equalTo(phoneView.mas_bottom).offset(2);
        make.height.equalTo(@(15));
    }];
    
    //昵称
    // 1.电话 输入框
    UIView *nameView = ({
           UIView *view = [[UIView alloc] init];
           [infoView addSubview:view];
           [self setUpLineView:view leftTitle:@"昵称" bottomNeedLine:YES];
           UITextField *textField = nil;
           [self setUpRightInLineView:view rightField:&textField placeHolder:@"请输入您的昵称" widthString:@"昵称"];
           [view mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.and.right.and.height.equalTo(phoneView);
               make.top.equalTo(phoneView.mas_bottom).offset(intervalHeight);
           }];
           self.nameField = textField;
           view;
    });
    
    _nameLabelHint =  [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
              make.text(@"").font(FONT(13)).textColor(UIColor.redColor).addToSuperView(self);
          }];
       [_nameLabelHint mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.and.right.equalTo(infoView);
           make.top.equalTo(nameView.mas_bottom).offset(2);
           make.height.equalTo(@(15));
       }];
    
    // 2.验证码
    UIView *codeView = ({
        
        UIView *view = [[UIView alloc] init];
        [infoView addSubview:view];
        [self setUpLineView:view leftTitle:@"验证码" bottomNeedLine:YES];
        UITextField *textField = nil;
        [self setUpRightInLineView:view rightField:&textField placeHolder:@"图片验证码" widthString:@"验证码"];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.height.equalTo(phoneView);
            make.top.equalTo(nameView.mas_bottom).offset(intervalHeight);
        }];
        [textField mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(view).offset(-120);
            
        }];
        textField.clearButtonMode = UITextFieldViewModeNever;

        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:button];
        
        [button addTarget:self action:@selector(codeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"获取验证码" forState: UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize: 14];
        [button setTitleColor: [UIColor blueColor] forState: UIControlStateNormal];
        [button setTitleColor: [UIColor lightGrayColor] forState: UIControlStateDisabled];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.and.top.and.height.equalTo(view);
            make.width.equalTo(@(120));
        }];
        [button addLineWithSide: LineViewSideInLeft lineColor: [UIColor lightGrayColor] lineHeight: 0.5 leftMargin: 10 rightMargin:10];
        button.enabled = true;
        self.codeBtn = button;
        self.codeField = textField;
        self.codeField.keyboardType = UIKeyboardTypeNumberPad;
        view;
        
    });
    
    // 2.地区选择 按钮
    UIView *secretView = ({
        
        UIView *view = [[UIView alloc] init];
        [infoView addSubview:view];
        [self setUpLineView:view leftTitle:@"设置密码" bottomNeedLine:YES];
        UITextField *textField = nil;
        [self setUpRightInLineView:view rightField:&textField placeHolder:@"6-20位字母、数字组合" widthString:@"设置密码"];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.height.equalTo(phoneView);
            make.top.equalTo(codeView.mas_bottom).offset(intervalHeight);
        }];
        
        [textField mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(view).offset(-32);
            
        }];
        CGFloat btnWH = 32;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage: IMAGE(@"common_hidden_logo") forState:UIControlStateNormal];
        [button setImage: IMAGE(@"common_show_icon") forState:UIControlStateSelected];
        [button addTarget: self action:@selector(showPassWord:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview: button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.top.equalTo(view);
            make.width.equalTo(@(btnWH));
        }];
        self.secretBtn = button;
        self.secretField = textField;
        self.secretField.secureTextEntry = true;
        view;

    });
    
    // 3.详细地址 输入框
    UIView *secondSecretView = ({
        UIView *view = [[UIView alloc] init];
        [infoView addSubview:view];
        [self setUpLineView:view leftTitle:@"确认密码" bottomNeedLine:YES];
        UITextField *textField = nil;
        [self setUpRightInLineView:view rightField:&textField placeHolder:@"确认密码" widthString:@"确认密码"];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.height.equalTo(phoneView);
            make.top.equalTo(secretView.mas_bottom).offset(intervalHeight);
            // bottom
            make.bottom.equalTo(infoView);
        }];
        [textField mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(view).offset(-32);
            
        }];
        
        CGFloat btnWH = 32;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage: IMAGE(@"common_hidden_logo") forState:UIControlStateNormal];
        [button setImage: IMAGE(@"common_show_icon") forState:UIControlStateSelected];
        [button addTarget: self action:@selector(showPassWord:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview: button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.top.equalTo(view);
            make.width.equalTo(@(btnWH));
        }];
        self.secondSecretBtn = button;
        self.secondSecretField = textField;
        self.secondSecretField.secureTextEntry = true;
        view;
    });
    
    _secretLabelHint =  [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
           make.text(@"").font(FONT(13)).textColor(UIColor.redColor).addToSuperView(self);
       }];
    [_secretLabelHint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(infoView);
        make.top.equalTo(secondSecretView.mas_bottom).offset(2);
        make.height.equalTo(@(15));
    }];
    


    
}

- (void)setUpRightInLineView:(UIView *)lineView rightField:(UITextField **)rightField placeHolder:(NSString *)placeHolder widthString:(NSString *)titleString
{
    CGFloat leftViewW = [titleString sizeWithFont:[UIFont systemFontOfSize: 14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineMargin:0].width;
    CGFloat leftMargin = 10 + leftViewW + 20;
    CGFloat rightMargin = 10;
    
    UITextField *textField = [[UITextField alloc] init];
    [lineView addSubview:textField];
    textField.placeholder = placeHolder;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.font = [UIFont systemFontOfSize:14];
    textField.textColor = [UIColor blackColor];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView).offset(leftMargin);
        make.right.equalTo(lineView).offset(-rightMargin);
        make.top.and.bottom.equalTo(lineView);
    }];

    
    *rightField = textField;
}

- (void)setUpLineView:(UIView *)lineView leftTitle:(NSString *)leftTitle bottomNeedLine:(BOOL)bottomNeedLine
{
    CGFloat leftMargin = 10;
    
    // left Label
    UILabel *label = [[UILabel alloc] init];
    [lineView addSubview:label];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    label.text = leftTitle;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView).offset(leftMargin);
        make.centerY.equalTo(lineView);
        // 右侧使用
        //        CGFloat width = [@"区域选择" sizeWithFont:[[PSTheme sharedInstance] fontNormal] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineMargin:0].width;
        //        make.width.equalTo(@(width));
    }];
    
    // bottom Line
    if (bottomNeedLine) {
        lineView.layer.borderWidth = 0.5;
        lineView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        lineView.layer.cornerRadius = 2;
        lineView.clipsToBounds = true;
        UIView *lineView2 = [[UIView alloc] init];
        [lineView addSubview:lineView2];
        //TODO 这里的约束应修正为最原生的约束，实现完全独立，而不是依赖masonry
        lineView2.backgroundColor = [UIColor lightGrayColor];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(label.mas_right).offset(10);
            
            make.top.equalTo(lineView).offset(10);
            make.bottom.equalTo(lineView).offset(-10);
            make.width.equalTo(@(0.5));
            
        }];
       
    }
    
}

-(void)checkPolicy {
    _isChecked = !_isChecked;
       if (_isChecked)
       {
           [_policyButton setImage:[UIImage imageNamed:@"reading-interaction"] forState:UIControlStateNormal];
       }
       else
       {
           [_policyButton setImage:[UIImage imageNamed:@"check-"] forState:UIControlStateNormal];
       }
}

- (void)showPassWord:(UIButton *)sender {
    self.secretBtn.selected = !sender.selected;
    self.secondSecretBtn.selected = self.secretBtn.selected;
    self.secretField.secureTextEntry = !sender.selected;
    self.secondSecretField.secureTextEntry = !sender.selected;
}
@end
