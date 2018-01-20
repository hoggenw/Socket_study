//
//  ChatListViewController.m
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/19.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatViewController.h"
#import "ChatListTableViewCell.h"
#import "ChatListUserModel.h"
#import "ChatUserModel.h"

#define ModelNumber 12

@interface ChatListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray * dataArray;
@property(nonatomic,strong) UITableView * tableView;


@end

@implementation ChatListViewController


#pragma mark - Override Methods


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Public Methods


#pragma mark - Events


#pragma mark - Private Methods
- (void)initialUI {
    self.tableView = [UITableView new];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[ChatListTableViewCell class] forCellReuseIdentifier:@"ChatListTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.bounces = YES;
    self.dataArray = [self getDataArray];
    [self.tableView reloadData];
}

-(NSMutableArray *)getDataArray {
    NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:20];
    for (int j  = 0; j < 2;  j ++) {
        for (int i  = 0; i < ModelNumber;  i ++) {
            ChatListUserModel *item1 = [[ChatListUserModel alloc] init];
            item1.from = [NSString stringWithFormat:@"王八%@",@(i)];
            item1.message = @"帅哥你好！！";
            item1.avatarURL = [NSURL URLWithString:@"send_head.jpg"];
            item1.messageCount = i;
            item1.date = [NSDate date];
            item1.needHint = i%2;
            [models addObject:item1];
        }
    }
    
    ChatListUserModel *item1 = [[ChatListUserModel alloc] init];
    item1.from = [NSString stringWithFormat:@"王八%@",@(100)];
    item1.message = @"帅哥你好！！";
    item1.avatarURL = [NSURL URLWithString:@"send_head.jpg"];
    item1.messageCount = 100;
    item1.date = [NSDate date];
    item1.needHint = true;
    [models addObject:item1];
    return models;
}


#pragma mark - Extension Delegate or Protocol

#pragma mark - tableView的delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ChatListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatListTableViewCell"];
    if (!cell) {
        cell = [[ChatListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ChatListTableViewCell"];
    }
    if (indexPath.row < _dataArray.count) {
         [cell setUserModel:_dataArray[indexPath.row]];
    }
    return cell;
}

#pragma mark  cell 点击界面之间的传值
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    ChatListUserModel *model = _dataArray[indexPath.row];
    
    ChatViewController *chatVC  = [ChatViewController new];
    /**
     下面的这个 TLUser 就是具体到用户的一个数据 model
     */
    ChatUserModel *user7 = [[ChatUserModel alloc] init];
    user7.username = model.from;
    user7.userID = @"XB";
    user7.nikename = @"小贝";
    user7.avatarURL = @"10.jpeg";
    chatVC.user = user7;
    
    // 隐藏底部的buttomBar 当 push 的时候
    chatVC.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:chatVC animated:YES];
    /**
     * 不加下面此句时，在二级栏目点击返回时，此行会由选中状态慢慢变成非选中状态。
     加上此句，返回时直接就是非选中状态。
     */
   
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}

-(UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]init];
    return view;
}

//侧滑
//实现了这个方法就有滑动的删除按钮了
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
//这个方法就是可以自己添加一些侧滑出来的按钮，并执行一些命令和按钮设置
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{

    //设置按钮(它默认第一个是修改系统的)
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"取消关注" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"取消关注操作第%@",@(indexPath.row));
    }];
    //设置按钮(它默认第一个是修改系统的)
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"删除操作第%@",@(indexPath.row));
    }];
    
    action.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0];
    action1.backgroundColor = [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f];
    return @[action1,action];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}




@end
