//
//  FriendInfoViewController.m
//  YLScoketTest
//
//  Created by hoggen on 2020/1/17.
//  Copyright © 2020 ios-mac. All rights reserved.
//

#import "FriendInfoViewController.h"

@interface FriendInfoViewController ()

@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *departLabel;

@end

@implementation FriendInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubviews];
    // Do any additional setup after loading the view.
}

- (void)setSubviews
{
    _header = [UIImageView new];
    _header.clipsToBounds = YES;
    _header.layer.cornerRadius = 25.f;
    [self.view addSubview:_header];
    [_header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.left.equalTo(self.view).mas_offset(20);
        make.top.equalTo(self.view).mas_offset(25);
        make.bottom.equalTo(self.view).mas_offset(-25);
    }];
    
    _nameLabel = [UILabel makeLabel:^(LabelMaker *make) {
        make.font(BOLD_FONT(16)).textColor(TEXT_BLACK_COLOR).addToSuperView(self.view);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.header).mas_offset(5);
        make.left.equalTo(self.header.mas_right).mas_offset(10);
    }];
    
    _positionLabel = [UILabel makeLabel:^(LabelMaker *make) {
        make.font(BOLD_FONT(14)).textColor(TEXT_BLACK_COLOR).addToSuperView(self.view);
    }];
    [_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).mas_offset(10);
    }];
    
    _departLabel = [UILabel makeLabel:^(LabelMaker *make) {
        make.font(FONT(14)).textColor(LIGHT_BLACK_COLOR).addToSuperView(self.view);
    }];
    [_departLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.header).mas_offset(-5);
        make.left.equalTo(self.header.mas_right).mas_offset(10);
    }];
}

@end
