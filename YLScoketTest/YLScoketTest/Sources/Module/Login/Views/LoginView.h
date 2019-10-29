//
//  LoginView.h
//  Telegraph
//
//  Created by 王留根 on 2018/4/23.
//

#import <UIKit/UIKit.h>



@interface LoginView : UIView

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *codeTextFeild;
@property (weak, nonatomic) IBOutlet UIButton *resendCodeButton;
@property (weak, nonatomic) IBOutlet UILabel *titleMessageShow;
@property (nonatomic, strong)NSString * getCodeType;
@property (weak, nonatomic) IBOutlet UILabel *codeHintLable;

@property (weak, nonatomic) IBOutlet UIButton *changePhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
@property (weak, nonatomic) IBOutlet UIButton *registeredButton;




-(void)setGetCodeType:(NSString *)getCodeType;
@end
