//
//  SearchUserTableViewCell.m
//  YLScoketTest
//
//  Created by hoggen on 2020/7/20.
//  Copyright © 2020 ios-mac. All rights reserved.
//

#import "SearchUserTableViewCell.h"


@interface SearchUserTableViewCell ()
@property (strong, nonatomic)  UIImageView *contactAvatarImg;
@property (strong, nonatomic)  UILabel *contactNameLabel;
@property (strong, nonatomic)  UILabel *remarkLabel;
@property (strong, nonatomic)  UILabel *applyLabel;
@end

@implementation SearchUserTableViewCell

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
    
    static NSString * const identifier = @"SearchUserTableViewCell";
    SearchUserTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        // 代码创建
        cell=  [SearchUserTableViewCell new];
        
    }
    
    return cell;
}




-(void)setModel:(SearchUserModel *)model {
    _model = model;
    
    if (model.isFriend) {
         self.detailButton.hidden = true;
           self.applyLabel.text = @"已添加";
    }else{
          self.applyLabel.text = @"";
         self.detailButton.hidden = false;
    }
    [self.contactAvatarImg sd_setImageWithURL:[NSURL URLWithString:model.avatar]  placeholderImage: IMAGE(@"other_header")];
    self.contactNameLabel.text = model.userName;
    self.remarkLabel.text =[NSString stringWithFormat:@"七聊号： %@",model.codeName] ;
   

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
            make.titleForState(@"查看",UIControlStateNormal).titleColorForState(UICOLOR(0x8EDEE9),UIControlStateNormal).backgroundColor([UIColor colorWithHex:0xf3f4f5]).addAction(self, @selector(detailBtnClicked:), UIControlEventTouchUpInside).addToSuperView(self).titleFont(FONT(13));
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
