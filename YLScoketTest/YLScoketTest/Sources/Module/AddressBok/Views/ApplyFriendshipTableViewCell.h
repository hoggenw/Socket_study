//
//  ApplyFriendshipTableViewCell.h
//  YLScoketTest
//
//  Created by hoggen on 2020/1/14.
//  Copyright © 2020 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FiendshipModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ApplyFriendshipTableViewCell : UITableViewCell

@property (strong, nonatomic)  FiendshipModel *model;
@property (strong, nonatomic)  UIButton *detailButton;

+ (instancetype)cellInTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
