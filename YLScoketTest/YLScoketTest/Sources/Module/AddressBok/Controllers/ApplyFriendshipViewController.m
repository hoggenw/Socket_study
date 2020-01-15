//
//  ApplyFriendshipViewController.m
//  YLScoketTest
//
//  Created by hoggen on 2020/1/14.
//  Copyright © 2020 ios-mac. All rights reserved.
//

#import "ApplyFriendshipViewController.h"
#import "SearchFriendView.h"
#import "AddressBookViewModel.h"
#import "FiendshipModel.h"
#import "ApplyFriendshipTableViewCell.h"
#import "ApplyDetailViewController.h"

@interface ApplyFriendshipViewController ()<UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) AddressBookViewModel *viewModel;
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray<FiendshipModel *> *friendsArray;

@end

@implementation ApplyFriendshipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

-(void)initUI {
    self.view.backgroundColor = UIColor.whiteColor ;
    // 头部搜索view
    _searchTextField = [UITextField makeSearchTextFieldWithBackgroundColor:GRAY_BACKGROUND_COLOR font:FONT(14) textColor:TEXT_GRAY_COLOR_2 placeholder:@"请输入手机号或7聊号"];
    _searchTextField.enablesReturnKeyAutomatically = NO;
    //_searchTextField.enabled = NO;
    [self.view addSubview:_searchTextField];
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(15).priorityHigh();
        make.top.equalTo(self.view.mas_top).offset(kNavigationHeight + 15);
        make.right.equalTo(self.view.mas_right).mas_offset(-15).priorityHigh();
        make.height.mas_equalTo(30);
    }];
    _searchTextField.delegate = self;
    _searchTextField.layer.cornerRadius = 2.f;
    
    self.listTableView = [UITableView MakeTableView:^(TableViewMaker *make) {
        make.backgroundColor(GRAY_BACKGROUND_COLOR).rowHeight(60).separatorColor(LINE_COLOR).separatorInset(UIEdgeInsetsMake(0, 15, 0, 15)).tableFooter([UIView new]).dataSource(self).delegate(self).addToSuperView(self.view);
    }];
    _listTableView.showsVerticalScrollIndicator = NO;
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchTextField.mas_bottom).offset(15);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self initDatasource];
    
}
-(void)initDatasource {
    _viewModel = [AddressBookViewModel new];
    @weakify(self)
    [_viewModel.applyFriendscommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        
        @strongify(self)
        if (x != nil)
        {
            self.friendsArray = x;
     
            [self.listTableView reloadData];
        }
        
        
    }];
    [_viewModel getApplyFriendscommand];
}




#pragma mark - action event ===

#pragma mark - action event ===



#pragma mark- TextField delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"搜索");
    return false;
}


#pragma mark- TextField delegate

#pragma mark -------- tableview --------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.friendsArray count] > 0) {
        [self.view  removeNoDataView];
        
    }else {
        [self.view showNoDataViewWithFrame:CGRectMake(0, kNavigationHeight, self.view.width, self.view.height-kNavigationHeight)];
    }
    return self.friendsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FiendshipModel *model = self.friendsArray[indexPath.row];
    ApplyFriendshipTableViewCell *cell = [ApplyFriendshipTableViewCell cellInTableView: self.listTableView];
    cell.model = model;
    cell.detailButton.tag = 500 + indexPath.row;
    @weakify(self)
    [[cell rac_signalForSelector:@selector(detailBtnClicked:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        RACTupleUnpack(UIButton *button) = x;
        FiendshipModel *temp = self.friendsArray[button.tag - 500];
        [self toDetailController:temp];
    }];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FiendshipModel *model = self.friendsArray[indexPath.row];
    [self toDetailController:model];
}

-(void)toDetailController:(FiendshipModel *)model {
    ApplyDetailViewController * vc = [ApplyDetailViewController new];
    vc.model = model;
    PUSH(vc);
    
}

@end
