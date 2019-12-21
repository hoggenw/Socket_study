//
//  SelectFriendCellTableViewCell.m
//  YLScoketTest
//
//  Created by hoggen on 2019/12/19.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "SelectFriendCellTableViewCell.h"


@interface SelectFriendCellTableViewCell ()
@property (strong, nonatomic)  UIImageView *contactAvatarImg;
@property (strong, nonatomic)  UILabel *contactNameLabel;
@end

@implementation SelectFriendCellTableViewCell

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
    
    static NSString * const identifier = @"SelectFriendCellTableViewCell";
    SelectFriendCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        // 代码创建
        cell=  [SelectFriendCellTableViewCell new];
        
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
            make.right.equalTo(self.contentView.mas_right);
        }];
    }
    return _contactNameLabel;
}

@end
