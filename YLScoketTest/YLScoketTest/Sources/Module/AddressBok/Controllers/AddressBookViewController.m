//
//  AddressBookViewController.m
//  YLScoketTest
//
//  Created by Alexander on 2019/10/29.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "AddressBookViewController.h"
#import "AddressBookViewModel.h"
#import "FiendshipModel.h"
#import "SelectFriendCellTableViewCell.h"
#import "SearchFriendView.h"
#import "IndexTableViewCell.h"


@interface AddressBookViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) AddressBookViewModel *viewModel;
@property (nonatomic, strong) NSArray *rowArr;
@property (nonatomic, strong) NSArray *sectionArr;
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) UITableView *indexTableView;
@property (nonatomic, strong) SearchFriendView *searchView;
@property (nonatomic, strong) NSMutableArray<YLUserModel *> *contactArray;// 数据
@property (nonatomic, strong) NSMutableArray<FiendshipModel *> *friendsArray;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) BOOL isScrollToShow;
@property (nonatomic, strong) UIButton *tipViewBtn;

@end

@implementation AddressBookViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        @weakify(self)
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:Y_Notification_Reload_Friend_Group object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            @strongify(self)
            if (self.viewModel) {
                [self.viewModel getFriendscommand];
            }
        }];
        self.selectIndex = 1;
        self.isScrollToShow = YES;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

-(void)initUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf3f4f5"];
    // 头部搜索view
    _searchView = [SearchFriendView new];
    [self.view addSubview:_searchView];
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kNavigationHeight);
        make.height.mas_equalTo(140);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchAction)];
    [_searchView addGestureRecognizer:tap];
    
    
    [[_searchView rac_signalForSelector:@selector(buttonClickAction:)] subscribeNext:^(RACTuple * _Nullable x) {
        RACTupleUnpack(UIButton *button) = x;
        if ([button.titleLabel.text isEqualToString:@"新建群聊"])
        {
            NSLog(@"新建群聊");
            
        }
        else if ([button.titleLabel.text isEqualToString:@"好友申请"])
        {
            NSLog(@"好友申请");
        }
        else if ([button.titleLabel.text isEqualToString:@"添加好友"])
        {
            NSLog(@"添加好友");
        }
        
    }];
    // 列表
    self.listTableView = [UITableView MakeTableView:^(TableViewMaker *make) {
        make.backgroundColor(GRAY_BACKGROUND_COLOR).rowHeight(52.0).separatorColor(LINE_COLOR).separatorInset(UIEdgeInsetsMake(0, 15, 0, 15)).tableFooter([UIView new]).registerCell([SelectFriendCellTableViewCell class], @"SelectFriendCellTableViewCell").dataSource(self).delegate(self).addToSuperView(self.view);
    }];
    _listTableView.showsVerticalScrollIndicator = NO;
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom).offset(10);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.indexTableView = [UITableView MakeTableView:^(TableViewMaker *make) {
        make.backgroundColor([UIColor clearColor]).rowHeight(20.0).separatorColor(LINE_COLOR).tableFooter([UIView new]).registerCell([IndexTableViewCell class], @"IndexTableViewCell").dataSource(self).delegate(self).addToSuperView(self.view);
    }];
    self.indexTableView.scrollEnabled = NO;
    self.indexTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initDatasource];
    
}

-(void)initDatasource {
    _contactArray = [NSMutableArray array];
    _viewModel = [AddressBookViewModel new];
    @weakify(self)
    [_viewModel.friendscommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        
        @strongify(self)
        if (x != nil)
        {
            self.friendsArray = x;
            [_contactArray removeAllObjects];
            for (FiendshipModel  *model in self.friendsArray ) {
                if ([model.friend.userId isEqualToString: [[AccountManager sharedInstance] fetch].userID]) {
                    [_contactArray addObject: model.user];
                }else{
                    [_contactArray addObject: model.friend];
                }
            }
            [self friendsDataDeal];
        }
        
        
    }];
    [_viewModel getFriendscommand];
}

- (void)friendsDataDeal {
    _rowArr = [AddressBookViewModel getContactListDataBy:self.contactArray];
    _sectionArr = [AddressBookViewModel getContactListSectionBy:[_rowArr mutableCopy]];
    [self.indexTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_right).offset(-20);
        make.centerY.equalTo(self.listTableView.mas_centerY);
        make.width.equalTo(@(30));
        make.height.equalTo(@(_sectionArr.count*20));
    }];
    [self.listTableView reloadData];
    [self.indexTableView  reloadData];
}

- (void)searchAction
{
    NSLog(@"网络用户搜索");
}
#pragma mark -------- tableview --------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_contactArray count] > 0) {
        [self.view  removeNoDataView];
        
    }else {
        [self.view showNoDataViewWithFrame:CGRectMake(0, kNavigationHeight+140, self.view.width, self.view.height-140-kNavigationHeight)];
    }
    return tableView == _listTableView ? _sectionArr.count-1 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return tableView == _listTableView ? [_rowArr[section] count] : _sectionArr.count;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return tableView == _listTableView ? 30.0 : 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView == _listTableView) {
        UIView *header = [[UIView alloc] init];
        header.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 30)];
        label.text = [_sectionArr objectAtIndex:section+1];
        label.textColor = [UIColor blackColor];
        [header addSubview:label];
        return header;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _listTableView) {
        YLUserModel *model = _rowArr[indexPath.section][indexPath.row];
        SelectFriendCellTableViewCell *cell = [SelectFriendCellTableViewCell cellInTableView: self.listTableView];
        cell.model = model;
        return cell;
    }
    else {
        IndexTableViewCell *cell = [IndexTableViewCell cellInTableView: self.indexTableView];
        if (indexPath.row == 0) {
            [cell showImage];
        }else {
            
            if (self.selectIndex == indexPath.row) {
                [cell selected];
            }else {
                [cell notSelected];
            }
            cell.contactNameLabel.text = _sectionArr[indexPath.row];
        }
         cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _listTableView) {
        YLUserModel *model = _rowArr[indexPath.section][indexPath.row];
        NSLog(@"选择朋友");
    }else {
        if (indexPath.row != 0) {
            self.isScrollToShow = NO;
            self.selectIndex = indexPath.row;
            [_indexTableView reloadData];
            [_listTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row-1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [self showTipViewWithIndex:indexPath];
        }
    }
}
/**
 显示tipView
 */
- (void)showTipViewWithIndex:(NSIndexPath *)indexPath {
    
    CGFloat y = CGRectGetMinY(_indexTableView.frame) + indexPath.row*20;
    self.tipViewBtn.frame = CGRectMake(CGRectGetMinX(_indexTableView.frame)-70, y-12, 65, 50);
    [self.view addSubview:self.tipViewBtn];
    self.tipViewBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    NSString *title = _sectionArr[self.selectIndex];
    [self.tipViewBtn setTitle:title forState:(UIControlStateNormal)];
    [self performSelector:@selector(dismissTipViewBtn) withObject:nil afterDelay:0.5];
}

- (void)dismissTipViewBtn {
    
    [self.tipViewBtn removeFromSuperview];
}
#pragma mark --------   --------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (self.isScrollToShow) {
        // 获取当前屏幕可见范围的indexPath
        NSArray *visiblePaths = [_listTableView indexPathsForVisibleRows];
        
        if (visiblePaths.count < 1) {
            return;
        }
        
        NSIndexPath *indexPath0 = visiblePaths[0];

        // 判断是否已滑到最底部
        CGFloat height = scrollView.frame.size.height;
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
        
        NSIndexPath *indexPath;
        if (bottomOffset <= height || fabs(bottomOffset - height) < 1) {
            //在最底部（显示最后一个索引字母）
            NSInteger row = _sectionArr.count-1;
            indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            self.selectIndex = indexPath.row;
        }else {
            indexPath = [NSIndexPath indexPathForRow:indexPath0.section inSection:0];
            self.selectIndex = indexPath.row+1;
        }
        
        [_indexTableView reloadData];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    // 重置
    if (!self.isScrollToShow) {
        self.isScrollToShow = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 重置
    if (!self.isScrollToShow) {
        self.isScrollToShow = YES;
    }
}

- (UIButton *)tipViewBtn {
    
    if (!_tipViewBtn) {
        _tipViewBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _tipViewBtn.enabled = NO;
        [_tipViewBtn setBackgroundImage:[UIImage imageNamed:@"chat_letterbg"] forState:(UIControlStateNormal)];
        _tipViewBtn.titleLabel.textColor = [UIColor whiteColor];
        [_tipViewBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    }
    
    return _tipViewBtn;
}

@end
