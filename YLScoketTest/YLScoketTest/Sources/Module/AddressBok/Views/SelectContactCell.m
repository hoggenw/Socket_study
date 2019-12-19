//
//  SelectContactCell.m
//  YLScoketTest
//
//  Created by hoggen on 2019/12/18.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "SelectContactCell.h"

@implementation SelectContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _selectedBtn.userInteractionEnabled = NO;
    _contactAvatarImg.layer.masksToBounds = YES;
    _contactAvatarImg.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _selectedBtn.selected = NO;
    [_selectedBtn setImage:[UIImage imageNamed:@"circle_empty"] forState:(UIControlStateNormal)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
