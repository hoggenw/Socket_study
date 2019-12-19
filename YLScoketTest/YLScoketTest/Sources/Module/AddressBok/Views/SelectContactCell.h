//
//  SelectContactCell.h
//  YLScoketTest
//
//  Created by hoggen on 2019/12/18.
//  Copyright © 2019 ios-mac. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SelectContactCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIImageView *contactAvatarImg;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;

@end
