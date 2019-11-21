//
//  RegisterView.h
//  YLScoketTest
//
//  Created by hoggen on 2019/11/14.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegisterView : UIView

@property (assign, nonatomic) BOOL isChecked;
/** 获取验证码 按钮 */
@property (weak, nonatomic) UIButton * codeBtn;


/** 电话号码 输入框 */
@property (weak, nonatomic) UITextField * phoneField;

/** 昵称*/
@property (weak, nonatomic) UITextField * nameField;
/** 7聊号*/
@property (weak, nonatomic) UITextField * codeNameField;
/** 验证码 输入框 */
@property (weak, nonatomic) UITextField * codeField;
/** 设置密码 输入框 */
@property (weak, nonatomic) UITextField * secretField;


@property (weak, nonatomic) UIButton * saveBtn;



@end

NS_ASSUME_NONNULL_END
