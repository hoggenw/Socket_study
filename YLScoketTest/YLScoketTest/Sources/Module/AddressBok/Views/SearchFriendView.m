//
//  SearchFriendView.m
//  YLScoketTest
//
//  Created by hoggen on 2019/12/19.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "SearchFriendView.h"


@interface SearchFriendView ()

@property (nonatomic, strong) UITextField *searchTextField;

@end

@implementation SearchFriendView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = UIColor.whiteColor;
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews
{
    
    _searchTextField = [UITextField makeSearchTextFieldWithBackgroundColor:GRAY_BACKGROUND_COLOR font:FONT(14) textColor:TEXT_GRAY_COLOR_2 placeholder:@"请输入手机号或7聊号"];
    _searchTextField.enablesReturnKeyAutomatically = NO;
    _searchTextField.enabled = NO;
    [self addSubview:_searchTextField];
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).mas_offset(15).priorityHigh();
        make.right.equalTo(self).mas_offset(-15).priorityHigh();
        make.height.mas_equalTo(30);
    }];

    
    UIButton *groupSend = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.titleForState(@"新建群聊", UIControlStateNormal).titleColorForState(LIGHT_BLACK_COLOR, UIControlStateNormal).titleFont(FONT(14)).imageForState(IMAGE(@"fiends_group_icon"), UIControlStateNormal).addAction(self, @selector(buttonClickAction:), UIControlEventTouchUpInside).addToSuperView(self);
    }];
    [groupSend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.height.mas_equalTo(80);
        make.top.equalTo(self.searchTextField.mas_bottom).mas_offset(15);
    }];
    groupSend.titleEdgeInsets = UIEdgeInsetsMake(groupSend.imageView.intrinsicContentSize.height, -groupSend.imageView.intrinsicContentSize.width, 0, 0);
    groupSend.imageEdgeInsets = UIEdgeInsetsMake(-20, 0, groupSend.titleLabel.intrinsicContentSize.height, -groupSend.titleLabel.intrinsicContentSize.width);
    [groupSend addLineWithSide:LineViewSideInRight lineColor: UIColor.lightGrayColor lineHeight:0.5 leftMargin:0 rightMargin:0];
    
    UIButton *groupManage = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.titleForState(@"好友申请", UIControlStateNormal).titleColorForState(LIGHT_BLACK_COLOR, UIControlStateNormal).titleFont(FONT(14)).imageForState(IMAGE(@"friends_apply_icon"), UIControlStateNormal).addAction(self, @selector(buttonClickAction:), UIControlEventTouchUpInside).addToSuperView(self);
    }];
    [groupManage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(groupSend.mas_right);
        make.height.mas_equalTo(80);
        make.width.equalTo(groupSend);
        make.top.equalTo(self.searchTextField.mas_bottom).mas_offset(15);
    }];
    groupManage.titleEdgeInsets = UIEdgeInsetsMake(groupManage.imageView.intrinsicContentSize.height, -groupManage.imageView.intrinsicContentSize.width, 0, 0);
    groupManage.imageEdgeInsets = UIEdgeInsetsMake(-20, 0, groupManage.titleLabel.intrinsicContentSize.height, -groupManage.titleLabel.intrinsicContentSize.width);
    [groupManage addLineWithSide:LineViewSideInRight lineColor: UIColor.lightGrayColor lineHeight:0.5 leftMargin:0 rightMargin:0];
    
    
    UIButton *addFriend = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.titleForState(@"添加好友", UIControlStateNormal).titleColorForState(LIGHT_BLACK_COLOR, UIControlStateNormal).titleFont(FONT(14)).imageForState(IMAGE(@"fiends_add_icon"), UIControlStateNormal).addAction(self, @selector(buttonClickAction:), UIControlEventTouchUpInside).addToSuperView(self);
    }];
    [addFriend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(groupManage.mas_right);
        make.height.mas_equalTo(80);
        make.width.equalTo(groupManage);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.searchTextField.mas_bottom).mas_offset(15);
    }];
    addFriend.titleEdgeInsets = UIEdgeInsetsMake(addFriend.imageView.intrinsicContentSize.height, -addFriend.imageView.intrinsicContentSize.width, 0, 0);
    addFriend.imageEdgeInsets = UIEdgeInsetsMake(-20, 0, addFriend.titleLabel.intrinsicContentSize.height, -addFriend.titleLabel.intrinsicContentSize.width);
    
    [self layoutIfNeeded];
    
    _searchTextField.layer.cornerRadius = 2.f;
}

#pragma mark - setter

- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    _delegate = delegate;
    
    _searchTextField.delegate = _delegate;
}

@end
