//
//  PersonalProfileController.m
//  YLScoketTest
//
//  Created by hoggen on 2019/12/31.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "PersonalProfileController.h"
#import "PersonInfoCell.h"

@interface PersonalProfileController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end
static NSString *personInfoCell = @"personInfoCell";
@implementation PersonalProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubviews];
    // Do any additional setup after loading the view.
}
- (void)setSubviews
{
    self.title = @"个人信息";
    
    _tableView = [UITableView MakeTableView:^(TableViewMaker *make) {
        make.style(UITableViewStyleGrouped).backgroundColor(UIColor.whiteColor).separatorStyle(UITableViewCellSeparatorStyleNone).delegate(self).dataSource(self).addToSuperView(self.view);
        
        make.registerCell([PersonInfoCell class], personInfoCell);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kNavigationHeight);
        make.left.bottom.right.equalTo(self.view);
    }];
    [_tableView reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return CGFLOAT_MIN;
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = GRAY_BACKGROUND_COLOR;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        return 47;
    }
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
     
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        PersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:personInfoCell];
        cell.model = [AccountManager sharedInstance].fetch;
        return cell;
    }
    else if (indexPath.section == 1)
    {
//        PersonSetCell *cell = [tableView dequeueReusableCellWithIdentifier:personSetCell];
//        cell.info = _dataSource[indexPath.section][indexPath.row];
        return [UITableViewCell new];
    }
     return [UITableViewCell new];
}

@end
