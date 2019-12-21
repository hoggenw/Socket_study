//
//  IndexTableViewCell.h
//  YLScoketTest
//
//  Created by hoggen on 2019/12/20.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IndexTableViewCell : UITableViewCell

@property (strong, nonatomic)  UILabel *contactNameLabel;

-(void)showImage;
-(void)selected;
-(void)notSelected;


+ (instancetype)cellInTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
