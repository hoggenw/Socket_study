//
//  ApplyFriendshipTableViewCell.m
//  YLScoketTest
//
//  Created by hoggen on 2020/1/14.
//  Copyright © 2020 ios-mac. All rights reserved.
//

#import "ApplyFriendshipTableViewCell.h"


@interface ApplyFriendshipTableViewCell ()
@property (strong, nonatomic)  UIImageView *contactAvatarImg;
@property (strong, nonatomic)  UILabel *contactNameLabel;
@property (strong, nonatomic)  UILabel *remarkLabel;
@property (strong, nonatomic)  UILabel *applyLabel;
@end

@implementation ApplyFriendshipTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


// 便利构造
+ (instancetype)cellInTableView:(UITableView *)tableView
{
    // 重用机制
    
    static NSString * const identifier = @"ApplyFriendshipTableViewCell";
    ApplyFriendshipTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        // 代码创建
        cell=  [ApplyFriendshipTableViewCell new];
        
    }
    
    return cell;
}




-(void)setModel:(FiendshipModel *)model {
    _model = model;
    
    
    if ([model.friend.userId isEqualToString: [[AccountManager sharedInstance] fetch].userID]) {
        
        [self.contactAvatarImg sd_setImageWithURL:[NSURL URLWithString:model.user.avatar]  placeholderImage: IMAGE(@"other_header")];
        self.contactNameLabel.text = model.user.name;
        self.remarkLabel.text = model.userRemark ?model.userRemark :[NSString stringWithFormat:@"我是 %@",model.user.name] ;
        self.detailButton.hidden = false;
        self.applyLabel.text = @"";
        
    }else{
        [self.contactAvatarImg sd_setImageWithURL:[NSURL URLWithString:model.friend.avatar]  placeholderImage: IMAGE(@"other_header")];
        self.contactNameLabel.text = model.friend.name;
        self.remarkLabel.text = model.userRemark ?model.userRemark :[NSString stringWithFormat:@"我是 %@",model.user.name] ;
        self.applyLabel.text= @"已申请";
        self.detailButton.hidden = true;
    }
    
}


- (UIImageView *)contactAvatarImg
{
    if (_contactAvatarImg == nil) {
        _contactAvatarImg = [[UIImageView alloc] init];
        [_contactAvatarImg.layer setMasksToBounds:YES];
        [_contactAvatarImg.layer setCornerRadius:2.0f];
        [self.contentView addSubview:_contactAvatarImg];
        [_contactAvatarImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.height.equalTo(@(36));
        }];
        
    }
    return _contactAvatarImg;
}

- (UILabel *)remarkLabel
{
    if (_remarkLabel == nil) {
        _remarkLabel = [[UILabel alloc] init];
        [_remarkLabel setFont:[UIFont systemFontOfSize:14]];
        _remarkLabel.textColor = [UIColor colorWithHex:0x666666];
        [self.contentView addSubview:_remarkLabel];
        [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contactAvatarImg.mas_right).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
            make.right.equalTo(self.detailButton.mas_right);
        }];
    }
    return _remarkLabel;
}

- (UILabel *)contactNameLabel
{
    if (_contactNameLabel == nil) {
        _contactNameLabel = [[UILabel alloc] init];
        [_contactNameLabel setFont:[UIFont systemFontOfSize:15]];
        _contactNameLabel.textColor = [UIColor colorWithHex:0x333333];
        [self.contentView addSubview:_contactNameLabel];
        [_contactNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contactAvatarImg.mas_right).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(8);
            make.right.equalTo(self.detailButton.mas_right);
        }];
    }
    return _contactNameLabel;
}
- (UILabel *)applyLabel
{
    if (_applyLabel == nil) {
        _applyLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
            make.font(FONT(14)).textColor([UIColor colorWithHex:0x666666]).text(@"已申请").textAlignment(NSTextAlignmentRight);
        }];
        [self.contentView addSubview:_applyLabel];
        [_applyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.width.equalTo(@(60));
        }];
    }
    return _applyLabel;
}

- (UIButton *)detailButton {
    if (_detailButton == nil) {
        _detailButton = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
            make.titleForState(@"查看",UIControlStateNormal).titleColorForState(UIColor.greenColor,UIControlStateNormal).backgroundColor([UIColor colorWithHex:0xf3f4f5]).addAction(self, @selector(detailBtnClicked:), UIControlEventTouchUpInside).addToSuperView(self).titleFont(FONT(13));
        }];
        [self.contentView addSubview:_detailButton];
        _detailButton.layer.cornerRadius = 2;
        _detailButton.clipsToBounds = true;
        [_detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.width.equalTo(@(40));
        }];
    }
    return _detailButton;
}

@end
