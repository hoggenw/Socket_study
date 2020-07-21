//
//  SearchUserTableViewCell.h
//  YLScoketTest
//
//  Created by hoggen on 2020/7/20.
//  Copyright © 2020 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchUserTableViewCell : UITableViewCell


@property (strong, nonatomic)  SearchUserModel *model;
@property (strong, nonatomic)  UIButton *detailButton;

+ (instancetype)cellInTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
