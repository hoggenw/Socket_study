//
//  UITableView+Factory.h
//  iOSProject
//
//  Created by Alexander on 2019/10/28.
//  Copyright © 2019 hoggenWang.com. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface TableViewMaker : NSObject

//默认style为UITableViewStylePlain 如需要设置为UITableViewStyleGrouped必须最先调用此方法
- (TableViewMaker *(^)(UITableViewStyle))style;

- (TableViewMaker *(^)(CGRect))frame;
- (TableViewMaker *(^)(id <UITableViewDataSource>))dataSource;
- (TableViewMaker *(^)(id <UITableViewDelegate>))delegate;
- (TableViewMaker *(^)(CGFloat))rowHeight;
- (TableViewMaker *(^)(CGFloat))estimatedRowHeight;
- (TableViewMaker *(^)(CGFloat))headerHeight;
- (TableViewMaker *(^)(CGFloat))estimatedHeaderHeight;
- (TableViewMaker *(^)(CGFloat))footerHeight;
- (TableViewMaker *(^)(CGFloat))estimatedFooterHeight;
- (TableViewMaker *(^)(Class, NSString *))registerCell;
- (TableViewMaker *(^)(UIView *))tableHeader;
- (TableViewMaker *(^)(UIView *))tableFooter;
- (TableViewMaker *(^)(UIEdgeInsets))separatorInset;
- (TableViewMaker *(^)(UITableViewCellSeparatorStyle))separatorStyle;
- (TableViewMaker *(^)(UIColor *))separatorColor;
- (TableViewMaker *(^)(UIView *))backgroundView;
- (TableViewMaker *(^)(UIColor *))backgroundColor;
- (TableViewMaker *(^)(UIView *))addToSuperView;

@end

@interface UITableView (Factory)

+ (instancetype)MakeTableView:(void(^)(TableViewMaker *make))tableViewMaker;

@end


NS_ASSUME_NONNULL_END
