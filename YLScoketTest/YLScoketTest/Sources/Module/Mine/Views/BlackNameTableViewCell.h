//
//  BlackNameTableViewCell.h
//  YLScoketTest
//
//  Created by hoggen on 2020/1/8.
//  Copyright © 2020 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlackNameTableViewCell : UITableViewCell

@property (strong, nonatomic)  YLUserModel *model;
@property (strong, nonatomic)  UIButton *deleteButton;

+ (instancetype)cellInTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
