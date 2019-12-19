//
//  SelectMemberCollectionCell.m
//  YLScoketTest
//
//  Created by hoggen on 2019/12/18.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "SelectMemberCollectionCell.h"

@implementation SelectMemberCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.memberHeadImg.layer.masksToBounds = YES;
    self.memberHeadImg.layer.cornerRadius = 3;
    self.memberHeadImg.contentMode = UIViewContentModeScaleAspectFill;
}

@end
