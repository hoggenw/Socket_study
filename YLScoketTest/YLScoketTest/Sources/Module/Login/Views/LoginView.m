//
//  LoginView.m
//  Telegraph
//
//  Created by 王留根 on 2018/4/23.
//

#import "LoginView.h"

#import "UserDefUtils.h"

@interface LoginView()

@property(nonatomic, assign) int time;//倒计时获取验证码
@property(nonatomic, strong) NSTimer *timer;//获取验证码的计时器
@property(nonatomic, copy) NSString * codeType;


@end

@implementation LoginView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.resendCodeButton setTitleColor: [UIColor darkGrayColor] forState: UIControlStateDisabled];
    [self.resendCodeButton setTitleColor: ThemeColor forState: UIControlStateNormal];
    self.resendCodeButton.enabled = true;
//    self.time = 61;
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    [self.codeTextFeild addLineWithSide:LineViewSideInBottom lineColor: [UIColor lightGrayColor] lineHeight: 0.5 leftMargin:0 rightMargin:0];
    self.codeTextFeild.keyboardType =  UIKeyboardTypeNumberPad;
    [self.phoneNumberTextFeild addLineWithSide:LineViewSideInBottom lineColor: [UIColor lightGrayColor] lineHeight: 0.5 leftMargin:0 rightMargin:0];
    [self.resendCodeButton addLineWithSide:LineViewSideInBottom lineColor: [UIColor lightGrayColor] lineHeight: 0.5 leftMargin:0 rightMargin:0];
    self.phoneNumberTextFeild.keyboardType =  UIKeyboardTypeNumberPad;
    
    [self.resendCodeButton setTitle: @"发送验证码" forState: UIControlStateNormal];
    self.resendCodeButton.titleLabel.font = [UIFont systemFontOfSize: 14];
    //self.codeHintLable.text = TGLocalized(@"Login.HaveNotReceivedCodeInternal");
    self.codeTextFeild.placeholder = @"短信验证码";
    self.phoneNumberTextFeild.placeholder = @"登录电话号码";
    
    [self.LoginButton setBackgroundImage:[UIImage imageWithColor: ThemeColor] forState: UIControlStateNormal];
    [self.LoginButton setBackgroundImage:[UIImage imageWithColor: [UIColor lightGrayColor]] forState: UIControlStateDisabled];
    self.LoginButton.layer.cornerRadius = 4;
    self.LoginButton.clipsToBounds = true;
    self.LoginButton.enabled = true;
    self.phoneNumberTextFeild.text = [UserDefUtils getStringForKey: @"LoginSucessSaveAccout"];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent: event];
    [self.codeTextFeild resignFirstResponder];
    [self.phoneNumberTextFeild resignFirstResponder];

}
//    用户注册user_register
//用户登录 user_login
//验证新手机 verify_newPhone
-(void)setGetCodeType:(NSString *)getCodeType{
    _getCodeType = getCodeType;
    if ([getCodeType isEqualToString:@"0"]) {
        [self.codeHintLable setHidden: false];
        [self.registeredButton setHidden: false];
        [self.changePhoneNumber setHidden: false];
        [self.resendCodeButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(120));
        }];
        self.codeTextFeild.placeholder = @"短信验证码";
        self.phoneNumberTextFeild.placeholder = @"登录电话号码";
        self.phoneNumberTextFeild.keyboardType = UIKeyboardTypeNumberPad;
        self.codeType = @"user_login";
         self.codeTextFeild.keyboardType =  UIKeyboardTypeNumberPad;
    }else if([getCodeType isEqualToString:@"1"]){
        [self.codeHintLable setHidden: true];
        [self.registeredButton setHidden: true];
        [self.changePhoneNumber setHidden: true];
        [self.resendCodeButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(0.01));
        }];
         self.codeTextFeild.placeholder = @"请输入登录密码";
        self.phoneNumberTextFeild.placeholder = @"请输入登录账号";
        self.phoneNumberTextFeild.keyboardType = UIKeyboardTypeASCIICapable;
         self.codeTextFeild.keyboardType =  UIKeyboardTypeASCIICapable;
        
    }else if([getCodeType isEqualToString:@"2"]){
        [self.codeHintLable setHidden: true];
        [self.registeredButton setHidden: true];
        [self.changePhoneNumber setHidden: true];
        [self.resendCodeButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(0.01));
        }];
        self.codeTextFeild.placeholder = @"请输入身份证号码";
        self.phoneNumberTextFeild.placeholder = @"请输入原手机号码";
        self.phoneNumberTextFeild.keyboardType = UIKeyboardTypeNumberPad;
        self.codeTextFeild.keyboardType =  UIKeyboardTypeASCIICapable;
        
    }
    else if([getCodeType isEqualToString:@"3"]){
        [self.codeHintLable setHidden: true];
        [self.registeredButton setHidden: true];
        [self.changePhoneNumber setHidden: true];
        [self.resendCodeButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(120));
        }];
        self.codeTextFeild.placeholder = @"短信验证码";
        self.phoneNumberTextFeild.placeholder = @"请输入新手机号码";
        self.codeType = @"verify_newPhone";
        self.codeTextFeild.keyboardType =  UIKeyboardTypeNumberPad;
        self.phoneNumberTextFeild.keyboardType = UIKeyboardTypeNumberPad;
    }
}



-(void)countdown
{
    self.time--;
    [self.resendCodeButton setEnabled:NO];

    [self.resendCodeButton setTitle:[NSString stringWithFormat:@"%2d后重新发送",self.time] forState: UIControlStateNormal];
    
    if (self.time == 0)
    {
        [self.timer invalidate];
        self.timer = nil;
        self.time = 61;
        [self.resendCodeButton setEnabled:YES];
        [self.resendCodeButton setTitle: @"发送验证码" forState:UIControlStateNormal];
        [self.resendCodeButton setEnabled:YES];
    }
}
- (IBAction)resendButtonAction:(UIButton *)sender {
    
    if (!([self.phoneNumberTextFeild.text hasPrefix:@"1"] && self.phoneNumberTextFeild.text.length == 11)) {
        [YLHintView showMessageOnThisPage: @"输入电话号码格式不正确"];
        return;
    }
    sender.enabled = false;
    NSLog(@"self.codeType : %@",self.codeType);
    NSDictionary * param = @{@"phone": self.phoneNumberTextFeild.text,@"type": self.codeType};

    
    
}

@end
