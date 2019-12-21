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
            make.edges.equalTo(self.view);
        }];
        
    [[_headerView rac_signalForSelector:@selector(headerBtnClicked)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"进入个人中心");
     }];
    
     UIButton * quitButton  = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
         make.titleForState(@"退出登录",UIControlStateNormal).titleColorForState([UIColor colorWithDisplayP3Red:255 green:98 blue:77 alpha:1],UIControlStateNormal).backgroundColor([UIColor colorWithHex:0x87CEFA]).addAction(self, @selector(quit), UIControlEventTouchUpInside).addToSuperView(self.view);
     }];
    [quitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-70);
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.height.mas_equalTo(44);
    }];
    quitButton.layer.cornerRadius = 5;
    quitButton.clipsToBounds = true;
    
}

- (void)bindViewModel {
    
    _viewModel = [MIneViewModel new];
    [self.viewModel.quitLoginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
         POST_LOGINQUIT_NOTIFICATION;
    }];
    _dataSource = _viewModel.dataSource;
    [_tableView reloadData];
    
}

- (void)quit {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message: @"确定退出当前账户吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.viewModel.quitLoginCommand execute: nil];
    }];
    
    UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [window.rootViewController presentViewController:alertController animated:YES completion:nil];
    
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
        controller.title = dataDict[@"title"];
        PUSH(controller);
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
