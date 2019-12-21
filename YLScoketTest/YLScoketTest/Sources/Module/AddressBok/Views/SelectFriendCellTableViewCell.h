//
//  SelectFriendCellTableViewCell.h
//  YLScoketTest
//
//  Created by hoggen on 2019/12/19.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectFriendCellTableViewCell : UITableViewCell
@property (strong, nonatomic)  YLUserModel *model;


+ (instancetype)cellInTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
