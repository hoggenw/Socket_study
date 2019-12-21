//
//  YLPersonalCenterCell.m
//  YLScoketTest
//
//  Created by hoggen on 2019/12/20.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "YLPersonalCenterCell.h"


@interface YLPersonalCenterCell()

@property (nonatomic, retain)UIImageView *cellImageView;
@property (nonatomic, retain)UILabel *titleLabel;

@end

@implementation YLPersonalCenterCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSubviews];
    }
    return self;
}

-(void)setSubviews
{
    self.cellImageView = [UIImageView new];
    self.cellImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.cellImageView];
    [self.cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.contentView).insets(UIEdgeInsetsMake(13, 15, 13, 0));
    }];
    
    self.titleLabel = [UILabel makeLabel:^(LabelMaker *make) {
        make.font(FONT(15)).textColor(RGBA(56, 63, 71, 1)).addToSuperView(self.contentView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView).insets(UIEdgeInsetsMake(15, 0, 15, 0));
        make.left.equalTo(self.cellImageView.mas_right).mas_offset(12);
    }];
    
    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zhankai_gray"]];
    [self.contentView addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).mas_offset(-10);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = RGBA(223, 225, 234, 1);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.bottom.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0.5, 0, 0));
    }];
}

-(void)setCellDict:(NSDictionary *)cellDict
{
    _cellDict = cellDict;
    
    [self.cellImageView setImage:[UIImage imageNamed:_cellDict[@"imageString"]]];
    self.titleLabel.text = _cellDict[@"title"];
}


@end
