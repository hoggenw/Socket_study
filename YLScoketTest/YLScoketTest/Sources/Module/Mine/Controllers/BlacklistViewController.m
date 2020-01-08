//
//  BlacklistViewController.m
//  YLScoketTest
//
//  Created by hoggen on 2019/12/31.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "BlacklistViewController.h"
#import "BlacklistViewModel.h"
#import "BlackNameTableViewCell.h"
#import "FiendshipModel.h"

@interface BlacklistViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) BlacklistViewModel *viewModel;
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray<YLUserModel *> *dataArray;// 数据
@property (nonatomic, strong) NSMutableArray<FiendshipModel *> *friendsArray;
@end

@implementation BlacklistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
-(void)initUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf3f4f5"];
    // 列表
    self.listTableView = [UITableView MakeTableView:^(TableViewMaker *make) {
        make.backgroundColor(GRAY_BACKGROUND_COLOR).rowHeight(52.0).separatorColor(LINE_COLOR).separatorInset(UIEdgeInsetsMake(0, 15, 0, 15)).tableFooter([UIView new]).dataSource(self).delegate(self).addToSuperView(self.view);
    }];
    _listTableView.showsVerticalScrollIndicator = NO;
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kNavigationHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self initDatasource];
    
}

-(void)initDatasource {
    _dataArray = [NSMutableArray array];
    _viewModel = [BlacklistViewModel new];
    @weakify(self)
    [_viewModel.blackListCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        
        @strongify(self)
        if (x != nil)
        {
            self.friendsArray = x;
            [_dataArray removeAllObjects];
            for (FiendshipModel  *model in self.friendsArray ) {
                if ([model.friend.userId isEqualToString: [[AccountManager sharedInstance] fetch].userID]) {
                    [_dataArray addObject: model.user];
                }else{
                    [_dataArray addObject: model.friend];
                }
            }
            [self.listTableView reloadData];
        }
        
        
    }];
    [_viewModel.deleteBlackshipCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        
        @strongify(self)
        if (x != nil)
        {
            [YLHintView showMessageOnThisPage:@"删除成功"];
            [self.viewModel getBlackList];
        }
        
        
    }];
    [_viewModel getBlackList];
}


#pragma mark -------- tableview --------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.dataArray count] > 0) {
        [self.view  removeNoDataView];
        
    }else {
        [self.view showNoDataViewWithFrame:CGRectMake(0, kNavigationHeight, self.view.width, self.view.height-kNavigationHeight)];
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLUserModel *model = self.dataArray[indexPath.row];
    BlackNameTableViewCell *cell = [BlackNameTableViewCell cellInTableView: self.listTableView];
    cell.model = model;
    cell.deleteButton.tag = 500 + indexPath.row;
    @weakify(self)
    [[cell rac_signalForSelector:@selector(deleteBtnClicked:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        RACTupleUnpack(UIButton *button) = x;
        NSInteger index = button.tag - 500;
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message: @"确定要将该用户移出黑名单吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            FiendshipModel * model = self.friendsArray[index];
            YLUserModel * blackModel = self.dataArray[index];
            NSMutableDictionary * input = [NSMutableDictionary dictionary];
            input[@"id"] = model.idStr;
            input[@"userId"] = [[AccountManager sharedInstance] fetch].userID;
            input[@"friendId"] = blackModel.userId;
            [self.viewModel deleteBlackship:input];
            NSLog(@"移除黑名单");
        }];
        
        UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [window.rootViewController presentViewController:alertController animated:YES completion:nil];
        
        
    }];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

