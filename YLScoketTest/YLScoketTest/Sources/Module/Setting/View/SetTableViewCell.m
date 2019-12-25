//
//  SetTableViewCell.m
//  YLScoketTest
//
//  Created by hoggen on 2019/12/25.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "SetTableViewCell.h"


@interface SetTableViewCell()
@property (nonatomic, retain)UILabel *titleLabel;
@property (nonatomic, retain)UILabel *addInfoLabel;
@property (nonatomic, retain)UIImageView *arrow;
@end


@implementation SetTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSubviews];
    }
    return self;
}

-(void)setSubviews{
    self.titleLabel = [UILabel makeLabel:^(LabelMaker *make) {
        make.textColor(RGBA(56, 63, 71, 1)).font(FONT(15)).addToSuperView(self.contentView);
    }];
    self.addInfoLabel = [UILabel makeLabel:^(LabelMaker *make) {
        make.textColor(RGBA(148, 156, 172, 1)).font(FONT(15)).addToSuperView(self.contentView);
    }];
    
    self.arrow = [[UIImageView alloc]initWithImage:(IMAGE(@"mine_arrow_icon"))];
    [self.contentView addSubview:self.arrow];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.contentView).insets(UIEdgeInsetsMake(15, 15, 15, 0));
    }];
    
    [self.addInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView).insets(UIEdgeInsetsMake(15, 0, 15, 0));
        make.left.greaterThanOrEqualTo(self.titleLabel.mas_right).mas_offset(10);
        make.right.equalTo(self.arrow.mas_left).mas_offset(5);
    }];
    
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 0, 10, 10));
        make.height.width.mas_equalTo(24);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = RGBA(223, 225, 234, 1);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.bottom.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0.5, 0));
    }];
}

-(void)setSetDict:(NSDictionary *)setDict{
    _setDict = setDict;
    
    self.titleLabel.text = setDict[@"title"];
    
    self.addInfoLabel.text = setDict[@"addInfo"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
