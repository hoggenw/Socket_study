//
//  MIneViewController.m
//  YLScoketTest
//
//  Created by Alexander on 2019/10/29.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import "MIneViewController.h"
#import "MIneViewModel.h"
#import "YLPersonalHeaderView.h"
#import "YLPersonalCenterCell.h"

@interface MIneViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) MIneViewModel * viewModel;
@property (nonatomic, strong) YLPersonalHeaderView *headerView;
@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation MIneViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden: true];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden: false];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
    [self bindViewModel];
}

- (void)initUI {
    
      _headerView = [[YLPersonalHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 164)];
        _tableView = [UITableView MakeTableView:^(TableViewMaker *make) { make.delegate(self).dataSource(self).registerCell([YLPersonalCenterCell class],NSStringFromClass([YLPersonalCenterCell class])).tableHeader(self.headerView).backgroundColor(GRAY_BACKGROUND_COLOR).rowHeight(44).separatorStyle(UITableViewCellSeparatorStyleNone).addToSuperView(self.view);
        }];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(-HEIGHT_STATUSBAR);
        }];
        
    [[_headerView rac_signalForSelector:@selector(headerBtnClicked)] subscribeNext:^(RACTuple * _Nullable x) {
            //NSLog(@"进入个人中心");
        UIViewController *controller = [NSClassFromString(@"PersonalProfileController") new];
        controller.hidesBottomBarWhenPushed = true;
          PUSH(controller);
     }];
    
}

- (void)bindViewModel {
    
    _viewModel = [MIneViewModel new];
    _dataSource = _viewModel.dataSource;
    [_tableView reloadData];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLPersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YLPersonalCenterCell class])];
    cell.cellDict = self.dataSource[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dataDict = _dataSource[indexPath.row];
    NSString *pushController = dataDict[@"pushController"];
    if (pushController&&[pushController length]>0&&[[[NSClassFromString(pushController) alloc]init] isKindOfClass:[UIViewController class]])
    {
        UIViewController *controller = [NSClassFromString(pushController) new];
        controller.hidesBottomBarWhenPushed = true;
        controller.title = dataDict[@"title"];
        [self.navigationController pushViewController:controller animated:false];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
