//
//  IndexTableViewCell.m
//  YLScoketTest
//
//  Created by hoggen on 2019/12/20.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "IndexTableViewCell.h"


@interface IndexTableViewCell ()

@end

@implementation IndexTableViewCell

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
    
    static NSString * const identifier = @"IndexTableViewCell";
    IndexTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        // 代码创建
        cell=  [IndexTableViewCell new];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}


-(void)showImage{
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_search_icon"]];
    img.center = self.contentView.center;
    [self.contentView addSubview:img];
    self.contactNameLabel.text = @"";
    self.contentView.backgroundColor = [UIColor clearColor];
}
-(void)selected{
    self.contentView.backgroundColor = [UIColor colorWithRed:1/255.0 green:190/255.0 blue:86/255.0 alpha:1];
    self.textLabel.textColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.masksToBounds = YES;
}
-(void)notSelected{
    self.contentView.backgroundColor = [UIColor clearColor];
    self.textLabel.textColor = [UIColor blackColor];
    self.contentView.layer.cornerRadius = 0;
    self.contentView.layer.masksToBounds = false;
}

- (UILabel *)contactNameLabel
{
    if (_contactNameLabel == nil) {
        _contactNameLabel = [[UILabel alloc] init];
        [_contactNameLabel setFont:[UIFont systemFontOfSize:14]];
        _contactNameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_contactNameLabel];
        [_contactNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@(20));
        }];
    }
    return _contactNameLabel;
}

@end
