//
//  PersonInfoCell.m
//  YLScoketTest
//
//  Created by hoggen on 2019/12/31.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "PersonInfoCell.h"

@interface PersonInfoCell ()

@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *departLabel;

@end

@implementation PersonInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.whiteColor;
        [self setSubviews];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _header.layer.cornerRadius = 25.f;
}

- (void)setSubviews
{
    _header = [UIImageView new];
    _header.clipsToBounds = YES;
    [self.contentView addSubview:_header];
    [_header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.left.equalTo(self.contentView).mas_offset(20);
        make.top.equalTo(self.contentView).mas_offset(25);
        make.bottom.equalTo(self.contentView).mas_offset(-25);
    }];
    
    _nameLabel = [UILabel makeLabel:^(LabelMaker *make) {
        make.font(BOLD_FONT(16)).textColor(TEXT_BLACK_COLOR).addToSuperView(self.contentView);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.header).mas_offset(5);
        make.left.equalTo(self.header.mas_right).mas_offset(10);
    }];
    
    _positionLabel = [UILabel makeLabel:^(LabelMaker *make) {
        make.font(BOLD_FONT(14)).textColor(TEXT_BLACK_COLOR).addToSuperView(self.contentView);
    }];
    [_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).mas_offset(10);
    }];
    
    _departLabel = [UILabel makeLabel:^(LabelMaker *make) {
        make.font(FONT(14)).textColor(LIGHT_BLACK_COLOR).addToSuperView(self.contentView);
    }];
    [_departLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.header).mas_offset(-5);
        make.left.equalTo(self.header.mas_right).mas_offset(10);
    }];
}

-(void)setModel:(UserModel *)model {
    _model = model;
    _nameLabel.text = model.name;
   // _positionLabel.text = _info[@"position"];
    _departLabel.text = [NSString stringWithFormat:@"7聊号：%@",model.codeName];
    [_header sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"self_header"]];
}


@end
