//
//  YLPersonalHeaderView.m
//  YLScoketTest
//
//  Created by hoggen on 2019/12/20.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "YLPersonalHeaderView.h"



@interface YLPersonalHeaderView()

@property (nonatomic, strong) UIImageView *informationView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *position;
@property (nonatomic, strong) UILabel *chatLabel;
@end

@implementation YLPersonalHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = GRAY_BACKGROUND_COLOR;
        [self setSubviews];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _headerView.layer.cornerRadius = 26.f;
    _headerView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headerView.layer.borderWidth = 2;
    
//    _settlementBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_settlementBtn.imageView.width, 0, _settlementBtn.imageView.width);
//    _settlementBtn.imageEdgeInsets = UIEdgeInsetsMake(0, _settlementBtn.titleLabel.width, 0, -_settlementBtn.titleLabel.width);
//
//    _settledBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -_settlementBtn.imageView.width, 0, _settlementBtn.imageView.width);
//    _settledBtn.imageEdgeInsets = UIEdgeInsetsMake(0, _settlementBtn.titleLabel.width, 0, -_settlementBtn.titleLabel.width);
}

-(void)setSubviews
{
    UserModel *userModel = [AccountManager sharedInstance].fetch;
    
    _informationView = [UIImageView new];
    _informationView.image = IMAGE(@"mine_background_photo");
    _informationView.userInteractionEnabled = YES;
    [self addSubview:_informationView];
    [_informationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(154.f);
    }];
    
    UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerBtnClicked)];
    [_informationView addGestureRecognizer:headerTap];
    
    _headerView = [UIImageView new];
    _headerView.clipsToBounds = YES;
    [_headerView sd_setImageWithURL:[NSURL URLWithString:userModel.avatar] placeholderImage:IMAGE(@"self_header")];
    [_informationView addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(52);
        make.left.equalTo(self.informationView).mas_offset(20).priorityHigh();
        make.top.equalTo(self.informationView).mas_offset(66);
    }];

    _name = [UILabel makeLabel:^(LabelMaker *make) {
        make.text(userModel.name).font(BOLD_FONT(18)).textColor(UIColor.whiteColor).addToSuperView(self.informationView);
    }];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_right).mas_offset(16);
        make.top.equalTo(self.informationView).mas_offset(70);
    }];

    _position = [UILabel makeLabel:^(LabelMaker *make) {
        make.text(@"").font(BOLD_FONT(14)).textColor(UIColor.whiteColor).addToSuperView(self);
    }];
    [_position mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_right).mas_offset(10).priorityHigh();
        make.top.equalTo(self.name.mas_top);
        make.bottom.equalTo(self.name.mas_bottom).mas_offset(3);
        make.right.equalTo(self.informationView).mas_offset(-10);
    }];

    _chatLabel = [UILabel makeLabel:^(LabelMaker *make) {
        make.text([NSString stringWithFormat:@"7聊号： %@", userModel.codeName]).font(BOLD_FONT(14)).numberOfLines(0).textColor(UIColor.whiteColor).addToSuperView(self);
    }];
    [_chatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).mas_offset(10);
        make.left.equalTo(self.name);
        make.right.equalTo(self.informationView).mas_offset(-10);
    }];

}


@end
