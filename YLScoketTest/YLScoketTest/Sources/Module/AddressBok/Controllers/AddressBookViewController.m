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
#import "SelectMemberWithSearchView.h"
#import "SelectContactCell.h"


@interface AddressBookViewController ()<SelectMemberWithSearchViewDelegate>
@property (nonatomic, strong) AddressBookViewModel *viewModel;
@property (nonatomic, strong) NSArray *rowArr;
@property (nonatomic, strong) NSArray *sectionArr;
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) UITableView *indexTableView;
@property (nonatomic, strong) SelectMemberWithSearchView *searchView;
@property (nonatomic, strong) NSMutableArray<YLUserModel *> *contactArray;// 数据
@property (nonatomic, strong) NSMutableArray<FiendshipModel *> *friendsArray;


@end

@implementation AddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initDatasource];
}

-(void)initUI {
    self.view.backgroundColor = [UIColor lightGrayColor];
    // 头部搜索view
    self.searchView = [SelectMemberWithSearchView new];
    _searchView.delegate = self;
    _searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_searchView];
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(52));
        make.top.equalTo(self.view.mas_top).offset(kNavigationHeight);
    }];
    
    
    
    //      // 列表
    //      self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchView.frame)+0.5, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-52-64-0.5) style:(UITableViewStylePlain)];
    //      _listTableView.delegate = self;
    //      _listTableView.dataSource = self;
    //      _listTableView.showsVerticalScrollIndicator = NO;
    //      _listTableView.backgroundColor = [UIColor whiteColor];
    //      _listTableView.tableFooterView = [[UIView alloc] init];
    //      [self.view addSubview:_listTableView];
    //      [_listTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SelectContactCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([SelectContactCell class])];
    //
    //      // 索引
    //      self.indexTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 20, _sectionArr.count*20) style:(UITableViewStylePlain)];
    //      _indexTableView.center = CGPointMake([UIScreen mainScreen].bounds.size.width-20,self.view.center.y);
    //      _indexTableView.delegate = self;
    //      _indexTableView.dataSource = self;
    //      _indexTableView.scrollEnabled = NO;
    //      _indexTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //      _indexTableView.showsVerticalScrollIndicator = NO;
    //      _indexTableView.backgroundColor = [UIColor clearColor];
    //      _indexTableView.tableFooterView = [[UIView alloc] init];
    //      [self.view addSubview:_indexTableView];
    //      [_indexTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
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
}

#pragma mark -------- custome delegate --------
- (void)removeMemberFromSelectArray:(YLUserModel *)member indexPath:(NSIndexPath *)indexPath {
    
    [_contactArray enumerateObjectsUsingBlock:^(YLUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //
        //        if ([obj.name isEqualToString:member.name]) {
        //            [self.selectArray removeObject:obj];
        //            [_listTableView reloadData];
        //            [self updateRightBarButtonItem];
        //        }
    }];
}

@end
