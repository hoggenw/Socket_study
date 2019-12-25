//
//  SetView.m
//  YLScoketTest
//
//  Created by hoggen on 2019/12/25.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "SetView.h"
#import "SetTableViewCell.h"


@interface SetView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain)UIButton *logoutBtn;
@end

@implementation SetView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setSubviews];
        
        self.backgroundColor = RGBA(242, 245, 249, 1);
    }
    return self;
}
-(void)setSubviews{
    self.tableView = [UITableView MakeTableView:^(TableViewMaker *make) {
        make.style(UITableViewStyleGrouped).headerHeight(0.1).footerHeight(10).delegate(self).dataSource(self).registerCell([SetTableViewCell class],NSStringFromClass([SetTableViewCell class])).separatorStyle(UITableViewCellSeparatorStyleNone).backgroundColor(RGBA(242, 245, 249, 1)).addToSuperView(self);
    }];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    self.logoutBtn = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.titleForState(@"退出登录",UIControlStateNormal).titleColorForState(RGBA(255, 98, 77, 1),UIControlStateNormal).backgroundColor(UIColor.whiteColor).addAction(self, @selector(logoutBtnClicked), UIControlEventTouchUpInside).addToSuperView(self);
    }];
#pragma clang diagnostic pop
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.bottom.equalTo(self.logoutBtn.mas_top).mas_offset(-10);
    }];
    
    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).mas_offset(-10);
        }else
            make.bottom.equalTo(self).mas_offset(-10);
        
        make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 15, 0, 15));
        make.height.mas_equalTo(44);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *temp = self.dataSource[section];
    return  temp.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SetTableViewCell class])];
    cell.setDict = self.dataSource[indexPath.section][indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *headerID = @"SetHeaderView";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:headerID];
    }
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSString *footerID = @"SetFooterView";
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerID];
    if (!footerView) {
        footerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:footerID];
    }
    return footerView;
}

-(void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    [self.tableView reloadData];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.logoutBtn.layer.cornerRadius = 4;
}

@end
