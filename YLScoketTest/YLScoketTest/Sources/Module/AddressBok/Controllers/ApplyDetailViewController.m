//
//  ApplyDetailViewController.m
//  YLScoketTest
//
//  Created by hoggen on 2020/1/14.
//  Copyright © 2020 ios-mac. All rights reserved.
//

#import "ApplyDetailViewController.h"

@interface ApplyDetailViewController ()
@property (nonatomic, strong) UIImageView *informationView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *chatLabel ;

@end

@implementation ApplyDetailViewController

- (void)viewDidLoad {
    self.title = @" ";
    [super viewDidLoad];
    [self initUI];
    
}
- (void)initUI {
    self.view.backgroundColor = [UIColor colorWithHex:0xf3f4f5];
    _headerView.layer.cornerRadius = 26.f;
    _headerView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headerView.layer.borderWidth = 2;
    _headerView.clipsToBounds = true;
    
    
    
    UserModel *userModel = [AccountManager sharedInstance].fetch;
    
    _informationView = [UIImageView new];
    _informationView.image = [UIImage imageWithColor:UIColor.whiteColor];
    _informationView.userInteractionEnabled = YES;
    [self.view addSubview:_informationView];
    [_informationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kNavigationHeight);
        make.height.mas_equalTo(100);
    }];
    
    _headerView = [UIImageView new];
    _headerView.clipsToBounds = YES;
    [_headerView sd_setImageWithURL:[NSURL URLWithString:userModel.avatar] placeholderImage:IMAGE(@"self_header")];
    [_informationView addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(52);
        make.left.equalTo(self.informationView).mas_offset(20).priorityHigh();
        make.centerY.equalTo(self.informationView.mas_centerY);
    }];
    
    _name = [UILabel makeLabel:^(LabelMaker *make) {
        make.text(userModel.name).font(BOLD_FONT(18)).textColor([UIColor colorWithHex:0x333333]).addToSuperView(self.informationView);
    }];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_right).mas_offset(16);
        make.top.equalTo(self.headerView.mas_top);
    }];

    
    _chatLabel = [UILabel makeLabel:^(LabelMaker *make) {
        make.text([NSString stringWithFormat:@"7聊号： %@", userModel.codeName]).font(BOLD_FONT(14)).numberOfLines(0).textColor([UIColor colorWithHex:0x666666]).addToSuperView(self.view);
    }];
    [_chatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).mas_offset(10);
        make.left.equalTo(self.name);
        make.right.equalTo(self.informationView).mas_offset(-10);
    }];
    
}

@end
