//
//  BlackNameTableViewCell.m
//  YLScoketTest
//
//  Created by hoggen on 2020/1/8.
//  Copyright © 2020 ios-mac. All rights reserved.
//

#import "BlackNameTableViewCell.h"

@interface BlackNameTableViewCell ()
@property (strong, nonatomic)  UIImageView *contactAvatarImg;
@property (strong, nonatomic)  UILabel *contactNameLabel;

@end

@implementation BlackNameTableViewCell

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
    
    static NSString * const identifier = @"BlackNameTableViewCell";
    BlackNameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        // 代码创建
        cell=  [BlackNameTableViewCell new];
        
    }
    
    return cell;
}




-(void)setModel:(YLUserModel *)model {
    _model = model;
    [self.contactAvatarImg sd_setImageWithURL:[NSURL URLWithString:model.avatar]  placeholderImage: IMAGE(@"other_header")];
    self.contactNameLabel.text = model.name;
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


- (UILabel *)contactNameLabel
{
    if (_contactNameLabel == nil) {
        _contactNameLabel = [[UILabel alloc] init];
        [_contactNameLabel setFont:[UIFont systemFontOfSize:16]];
        [self.contentView addSubview:_contactNameLabel];
        [_contactNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contactAvatarImg.mas_right).offset(10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.deleteButton.mas_right);
        }];
    }
    return _contactNameLabel;
}

- (UIButton *)deleteButton {
    if (_deleteButton == nil) {
        _deleteButton = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
            make.titleForState(@"移除黑名单",UIControlStateNormal).titleColorForState(RGBA(255, 98, 77, 1),UIControlStateNormal).backgroundColor(UIColor.whiteColor).addAction(self, @selector(deleteBtnClicked:), UIControlEventTouchUpInside).addToSuperView(self).titleFont(FONT(13));
          }];
        [self.contentView addSubview:_deleteButton];
        _deleteButton.layer.cornerRadius = 2;
        _deleteButton.layer.borderWidth = 0.5;
        _deleteButton.layer.borderColor = [UIColor redColor].CGColor;
        _deleteButton.clipsToBounds = true;
        [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.width.equalTo(@(70));
        }];
    }
    return _deleteButton;
}

@end
