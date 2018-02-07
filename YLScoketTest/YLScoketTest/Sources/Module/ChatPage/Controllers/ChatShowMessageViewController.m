//
//  ChatShowMessageViewController.m
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/19.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "ChatShowMessageViewController.h"
#import "ChatMessageModel.h"
#import "YLTextTableViewCell.h"
#import "YLImageMessageCell.h"
#import "YLVoiceMessageCell.h"
#import "YLSystemMessageCell.h"

@interface ChatShowMessageViewController ()

@property (nonatomic, strong) NSMutableArray <ChatMessageModel *> *dataArray;



@end

@implementation ChatShowMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor myColorWithRed:235 green:235 blue:235 alpha:1];
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(didTapView)]];
    // Do any additional setup after loading the view.
    
    /**
     *  注册四个 cell
     */
    [self.tableView registerClass:[YLTextTableViewCell class] forCellReuseIdentifier:@"YLTextTableViewCell"];
    [self.tableView registerClass:[YLImageMessageCell class] forCellReuseIdentifier:@"YLImageMessageCell"];
    [self.tableView registerClass:[YLVoiceMessageCell class] forCellReuseIdentifier:@"YLVoiceMessageCell"];
    [self.tableView registerClass:[YLSystemMessageCell class] forCellReuseIdentifier:@"YLSystemMessageCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)scrollToBottom {
    //当我们执行该方法是，有可能由于reload方法在等待主线程执行，而直接执行下面的方法，这时候还没有reload，cell，会出现数组越界的情况
    if (_dataArray.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger lastRowIndex =  [self.tableView numberOfRowsInSection: 0] - 1;
            //NSLog(@"scrollToBottom lastRowIndex: %@",@(lastRowIndex));
            if (lastRowIndex >= 0 && _dataArray.count >  [self.tableView numberOfRowsInSection: 0]) {
                [self.tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: lastRowIndex  inSection: 0] atScrollPosition: UITableViewScrollPositionBottom animated: YES];
            }else{
                [self.tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: (_dataArray.count - 1)  inSection: 0] atScrollPosition: UITableViewScrollPositionBottom animated: YES];
                
            }
        });
        // tableView 定位到的cell 滚动到相应的位置，后面的 atScrollPosition 是一个枚举类型
        
    }
}

- (void) addNewMessage:(ChatMessageModel *)message
{
    /**
     *  数据源添加一条消息，刷新数据
     */
    [self.dataArray addObject:message];
    if (message.messageType == YLMessageTypeImage) {
        [self.imageMessageModels addObject: message];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    
    [self scrollToBottom];
    
}



#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"addNewMessage self.dataArray: %@",@(self.dataArray.count));
    return _dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ChatMessageModel  * messageModel = _dataArray[indexPath.row];
    /**
     *  id类型的cell 通过取出来Model的类型，判断要显示哪一种类型的cell
     */
    id cell = [tableView dequeueReusableCellWithIdentifier: messageModel.cellIndentify forIndexPath:indexPath];
    // 给cell赋值
    [cell setMessageModel:messageModel];
    return cell;
    
}

#pragma mark - UITableViewCellDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatMessageModel *message = [_dataArray objectAtIndex:indexPath.row];
    
   // NSLog(@"message.cellHeight: %@",@(message.cellHeight));
    return message.cellHeight;
}


#pragma mark - Event Response
- (void) didTapView
{
    if (_delegate && [_delegate respondsToSelector:@selector(didTapChatMessageView:)]) {
        
        [_delegate didTapChatMessageView:self];
        
    }
    
}

- (NSMutableArray <ChatMessageModel *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(NSMutableArray<ChatMessageModel *> *)imageMessageModels {
    if (_imageMessageModels == nil) {
        _imageMessageModels = [NSMutableArray array];
    }
    return _imageMessageModels;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

