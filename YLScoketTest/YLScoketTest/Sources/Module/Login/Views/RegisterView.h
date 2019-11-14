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

@end

NS_ASSUME_NONNULL_END
