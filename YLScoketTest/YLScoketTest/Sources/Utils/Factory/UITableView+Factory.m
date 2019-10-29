//
//  UITableView+Factory.m
//  iOSProject
//
//  Created by Alexander on 2019/10/28.
//  Copyright © 2019 hoggenWang.com. All rights reserved.
//

#import "UITableView+Factory.h"



@interface TableViewMaker ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TableViewMaker
- (TableViewMaker *(^)(CGRect))frame
{
    return ^TableViewMaker *(CGRect rect){
        self.tableView.frame = rect;
        return self;
    };
}

- (TableViewMaker *(^)(UITableViewStyle))style
{
    return ^TableViewMaker *(UITableViewStyle style){
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];
        self.tableView.showsVerticalScrollIndicator = self.tableView.showsHorizontalScrollIndicator = NO;
        return self;
    };
}

- (TableViewMaker *(^)(id <UITableViewDataSource>))dataSource
{
    return ^TableViewMaker *(id <UITableViewDataSource> dataSource){
        self.tableView.dataSource = dataSource;
        return self;
    };
}
- (TableViewMaker *(^)(id <UITableViewDelegate>))delegate
{
    return ^TableViewMaker *(id <UITableViewDelegate> delegate){
        self.tableView.delegate = delegate;
        return self;
    };
}
- (TableViewMaker *(^)(CGFloat))rowHeight
{
    return ^TableViewMaker *(CGFloat height){
        self.tableView.rowHeight = height;
        return self;
    };
}

- (TableViewMaker *(^)(CGFloat))estimatedRowHeight
{
    return ^TableViewMaker *(CGFloat height){
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = height;
        return self;
    };
}

- (TableViewMaker *(^)(CGFloat))headerHeight
{
    return ^TableViewMaker *(CGFloat height){
        self.tableView.sectionHeaderHeight = height;
        return self;
    };
}

- (TableViewMaker *(^)(CGFloat))estimatedHeaderHeight
{
    return ^TableViewMaker *(CGFloat height){
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedSectionHeaderHeight = height;
        return self;
    };
}

- (TableViewMaker *(^)(CGFloat))footerHeight
{
    return ^TableViewMaker *(CGFloat height){
        self.tableView.sectionFooterHeight = height;
        return self;
    };
}

- (TableViewMaker *(^)(CGFloat))estimatedFooterHeight
{
    return ^TableViewMaker *(CGFloat height){
        self.tableView.sectionFooterHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedSectionFooterHeight = height;
        return self;
    };
}

- (TableViewMaker *(^)(Class, NSString *))registerCell
{
    return ^TableViewMaker *(Class class, NSString *identifier){
        [self.tableView registerClass:class forCellReuseIdentifier:identifier];
        return self;
    };
}

- (TableViewMaker *(^)(UIView *))tableHeader;
{
    return ^TableViewMaker *(UIView *header){
        self.tableView.tableHeaderView = header;
        return self;
    };
}

- (TableViewMaker *(^)(UIView *))tableFooter
{
    return ^TableViewMaker *(UIView *footer){
        self.tableView.tableFooterView = footer;
        return self;
    };
}

- (TableViewMaker *(^)(UIEdgeInsets))separatorInset
{
    return ^TableViewMaker *(UIEdgeInsets insets){
        self.tableView.separatorInset = insets;
        return self;
    };
}

- (TableViewMaker *(^)(UITableViewCellSeparatorStyle))separatorStyle
{
    return ^TableViewMaker *(UITableViewCellSeparatorStyle style){
        self.tableView.separatorStyle = style;
        return self;
    };
}

- (TableViewMaker *(^)(UIColor *))separatorColor
{
    return ^TableViewMaker *(UIColor *color){
        self.tableView.separatorColor = color;
        return self;
    };
}

- (TableViewMaker *(^)(UIView *))backgroundView
{
    return ^TableViewMaker *(UIView *view){
        self.tableView.backgroundView = view;
        return self;
    };
}

- (TableViewMaker *(^)(UIColor *))backgroundColor
{
    return ^TableViewMaker *(UIColor *color){
        self.tableView.backgroundColor = color;
        return self;
    };
}
- (TableViewMaker *(^)(UIView *))addToSuperView
{
    return ^TableViewMaker *(UIView *superView){
        [superView addSubview:self.tableView];
        return self;
    };
}

@end

@implementation UITableView (Factory)
+ (instancetype)MakeTableView:(void(^)(TableViewMaker *make))tableViewMaker
{
    TableViewMaker *maker = [TableViewMaker new];
    maker.tableView = [self new];
    maker.tableView.showsVerticalScrollIndicator = maker.tableView.showsHorizontalScrollIndicator = NO;
    tableViewMaker(maker);
    return maker.tableView;
}

@end
