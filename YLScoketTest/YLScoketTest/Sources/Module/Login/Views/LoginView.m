//
//  LoginView.m
//  Telegraph
//
//  Created by 王留根 on 2018/4/23.
//

#import "LoginView.h"

#import "UserDefUtils.h"

@interface LoginView()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *forgetBtn;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIView *accountLine;
@property (nonatomic, strong) UIView *pwdLine;

@end

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setSubviews];
    }
    return self;
}
- (void)setSubviews {
    self.backgroundColor = UIColor.whiteColor;
    UIImageView *logoImageView = [UIImageView new];
    logoImageView.image = [UIImage imageNamed:@"common_icon_logo"];
    [self addSubview: logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.height.mas_equalTo(100);
        make.centerX.equalTo(self);
    }];
    NSAttributedString *placeholder1 = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSFontAttributeName:FONT(14), NSForegroundColorAttributeName:[UIColor colorWithHex:0xB4BDCA]}];
      _accountTF = [UITextField makeTextField:^(TextFieldMaker *make) {
          make.attributedPlaceholder(placeholder1).textAlignment(NSTextAlignmentLeft).textColor([UIColor colorWithHex:0x333333]).font(FONT(16)).keyboardType(UIKeyboardTypeNumbersAndPunctuation).delegate(self).clearMode(UITextFieldViewModeWhileEditing).returnKeyType(UIReturnKeyNext).addToSuperView(self);
      }];
      _accountTF.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"account"];
      [_accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self).mas_offset(43);
          make.right.equalTo(self).mas_offset(-43);
          make.height.mas_equalTo(44);
          make.top.equalTo(logoImageView.mas_bottom).mas_offset(48);
      }];
      
      NSAttributedString *placeholder2 = [[NSAttributedString alloc] initWithString:@"请输入登录密码" attributes:@{NSFontAttributeName:FONT(14), NSForegroundColorAttributeName:UICOLOR(0xB4BDCA)}];
      _pwdTF = [UITextField makeTextField:^(TextFieldMaker *make) {
          make.attributedPlaceholder(placeholder2).textAlignment(NSTextAlignmentLeft).textColor(UICOLOR(0x333333)).font(FONT(16)).delegate(self).clearMode(UITextFieldViewModeWhileEditing).returnKeyType(UIReturnKeyGo).secureTextEntry(YES).addToSuperView(self);
      }];
      _pwdTF.enablesReturnKeyAutomatically = YES;
      [_pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self).mas_offset(43);
          make.right.equalTo(self).mas_offset(-90);
          make.height.mas_equalTo(44);
          make.top.equalTo(self.accountTF.mas_bottom).mas_offset(20);
      }];
    
    UIButton *secureStatusBtn = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.imageForState(IMAGE(@"common_hidden_logo"), UIControlStateNormal).imageForState(IMAGE(@"common_show_icon"), UIControlStateSelected).addAction(self, @selector(secureAction:), UIControlEventTouchUpInside).addToSuperView(self);
    }];
    [secureStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.centerY.equalTo(self.pwdTF);
        make.right.equalTo(self).mas_offset(-55);
    }];
    
    #pragma clang diagnostic ignored "-Wundeclared-selector"
    _registerBtn = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
           make.titleForState(@"前往注册", UIControlStateNormal).titleColorForState(UIColor.blueColor, UIControlStateNormal).titleFont(FONT(13)).addAction(self, @selector(registerAction), UIControlEventTouchUpInside).addToSuperView(self);
       }];
    
    
    _confirmBtn = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
           make.backgroundImageForState([UIImage imageWithColor:UIColor.blueColor], UIControlStateNormal).backgroundImageForState([UIImage imageWithColor:UIColor.blueColor], UIControlStateHighlighted).backgroundImageForState([UIImage imageWithColor:UICOLOR(0x8EDEE9)], UIControlStateDisabled);
           make.titleColorForState(UIColor.whiteColor, UIControlStateNormal).titleForState(@"登 录", UIControlStateNormal).titleFont(BOLD_FONT(18)).addAction(self, @selector(confirmAction:), UIControlEventTouchUpInside).addToSuperView(self);
       }];
    
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-40);
//         make.left.equalTo(self.mas_left).offset(40);
        make.top.equalTo(self.pwdTF.mas_bottom).mas_offset(25);
    }];
    



    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(44));
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-40);
        make.top.equalTo(self.registerBtn.mas_bottom).offset(55);
    }];
      
    RAC(self.confirmBtn,enabled) = [RACSignal combineLatest:@[_accountTF.rac_textSignal,_pwdTF.rac_textSignal] reduce:^id _Nonnull(NSString *account, NSString *pwd){
        return @(account.isPhoneNumber && pwd.length > 0);
    }];
    UIView * line1 =[self.accountTF addLineWithSide:LineViewSideOutBottom lineColor:UIColor.lightGrayColor lineHeight:0.5 leftMargin:0 rightMargin:0];
    UIView * line2 = [self.pwdTF addLineWithSide:LineViewSideOutBottom lineColor:UIColor.lightGrayColor lineHeight:0.5 leftMargin:0 rightMargin:-47];
    _confirmBtn.layer.cornerRadius = 5;
    _confirmBtn.clipsToBounds = true;
    
    _accountLine = [UIView new];
       _accountLine.backgroundColor = UIColor.greenColor;
       [self addSubview:_accountLine];
       [_accountLine mas_makeConstraints:^(MASConstraintMaker *make) {
           make.bottom.centerX.equalTo(line1);
           make.height.mas_equalTo(1.f);
           make.width.mas_equalTo(0);
       }];

       _pwdLine = [UIView new];
       _pwdLine.backgroundColor = UIColor.greenColor;
       [self addSubview:_pwdLine];
       [_pwdLine mas_makeConstraints:^(MASConstraintMaker *make) {
           make.bottom.centerX.equalTo(line2);
           make.height.mas_equalTo(1.f);
           make.width.mas_equalTo(0);
       }];
//
//    [_confirmBtn setHidden:false];
}
- (void)confirmAction:(UIButton *)button {}
- (void)secureAction:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    _pwdTF.secureTextEntry = !sender.isSelected;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _accountTF)
    {
        [_pwdTF becomeFirstResponder];
        return NO;
    }
    else if (textField == _pwdTF)
    {
        if ([_accountTF.text length] == 11)
        {
            [self confirmAction:_confirmBtn];
        }
        else
        {
            [YLHintView showMessageOnThisPage:@"请输入正确的手机号"];
        }
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _accountTF)
    {
        [_accountLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
    else
    {
        [_pwdLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
    [UIView animateWithDuration:.3f animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _accountTF)
    {
        [_accountLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.accountTF.width);
        }];
    }
    else
    {
        [_pwdLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.accountTF.width);
        }];
    }
    [UIView animateWithDuration:.3f animations:^{
        [self layoutIfNeeded];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) return YES;
    else if ([string isEqualToString:@" "]) return NO;
    else if (textField == _accountTF && textField.text.length >= 11) return NO;
    else if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"]) return NO;
    return YES;
}

@end
