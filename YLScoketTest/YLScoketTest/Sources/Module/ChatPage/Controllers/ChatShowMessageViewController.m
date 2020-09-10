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
@property (nonatomic, assign) int page;


@end

@implementation ChatShowMessageViewController


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Y_Notification_Refresh_ChatMessage_State  object: nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
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
    
    
    /**
     *  通知更新
     */
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName: Y_Notification_Refresh_ChatMessage_State object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        self.dataArray = [[[LocalSQliteManager sharedInstance] selectLocalChatMessageModelBeforePageByDESC:self.page userId:self.user.userID] mutableCopy];
        self.dataArray = [self addSystemModel: self.dataArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
             [self scrollToBottom];
        });
        
    }];
    
    /**
     *  下拉加载更多数据
     */
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        self.page +=1;
        [self pushData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    
}

-(void)pushData {
    NSMutableArray <ChatMessageModel *> *addArray = [[[LocalSQliteManager sharedInstance] selectLocalChatMessageModelByDESC:self.page userId:self.user.userID] mutableCopy];
    for (ChatMessageModel *model in  self.dataArray) {
        [addArray addObject: model];
    }
    
    self.dataArray = [self addSystemModel:addArray];
    [self.tableView.mj_header endRefreshing];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
         [self scrollToBottom];
    });
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.dataArray = [[[LocalSQliteManager sharedInstance] selectLocalChatMessageModelByDESC:self.page userId:self.user.userID] mutableCopy];
    self.dataArray = [self addSystemModel: self.dataArray];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    [self scrollToBottom];
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
    
    
    if (message == NULL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
             [self scrollToBottom];
        });
        
    }else{
        /**
         *  数据源添加一条消息，刷新数据
         */
        [self.dataArray addObject:message];
        self.dataArray = [self addSystemModel: self.dataArray];
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
             [self scrollToBottom];
        });
        [ChatDealUtils setMessageStateReaded: self.user.userID];
    }
    
    
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
    
    if (indexPath.row >= _dataArray.count) {
        return nil;
    }
    
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
    if (indexPath.row >= _dataArray.count) {
        return 0;
    }
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


- (NSMutableArray<ChatMessageModel *>  *)addSystemModel:(NSMutableArray<ChatMessageModel *> *)sourceData{
    
    self.imageMessageModels = [NSMutableArray array];
    NSMutableArray<ChatMessageModel *>  * cleanArray = [NSMutableArray array];
    for (ChatMessageModel * temp in sourceData) {
        if (temp.ownerTyper != YLMessageOwnerTypeSystem) {
            [cleanArray addObject: temp];
        }
    }

    
    NSMutableArray<ChatMessageModel *>  * midArray = [NSMutableArray array];
    NSDate * midDate = [NSDate date];
    for (int i = 0; i < cleanArray.count; i ++) {
        ChatMessageModel * temp = cleanArray[i];
        if (i == 0) {
            midDate = temp.date;
            ChatMessageModel * systemModel =[ChatMessageModel new];
            systemModel.ownerTyper = YLMessageOwnerTypeSystem;
            systemModel.messageType = YLMessageTypeSystem;
            systemModel.text = [self dateToString: midDate];
            [midArray addObject: systemModel];
        }else{
            //设置时间间隔（秒）5261（这个我是计算出来的，不知道4102有没有简便的1653方法 )
            NSTimeInterval time = 10 * 60;//10分钟
            //得到一年之前的当前时间（-：表回示答向前的时间间隔（即去年），如果没有，则表示向后的时间间隔（即明年））
            NSDate * tenMinutesLater = [midDate dateByAddingTimeInterval: time];
            int result = [NSDate compareDate:tenMinutesLater withDate: temp.date];
            if (result == 1) {
                midDate = temp.date;
                ChatMessageModel * systemModel =[ChatMessageModel new];
                systemModel.ownerTyper = YLMessageOwnerTypeSystem;
                systemModel.messageType = YLMessageTypeSystem;
                systemModel.text = [self dateToString: midDate];
                [midArray addObject: systemModel];
            }
        }
        [midArray addObject: temp];
        if (temp.messageType == YLMessageTypeImage) {
              [self.imageMessageModels addObject: temp];
        }
        
    }
    return  midArray;
    
}

-(NSString *)dateToString:(NSDate *)date {
    NSString *timeString = @"";
    if ([NSDate ifToday: date]) {
        timeString = [date formatHHMM];
    }else if([NSDate ifYesterday:date]) {
        timeString = [NSString stringWithFormat:@"昨天   %@",[date formatHHMM]] ;
    }else{
        timeString =   [date formatYYMMDDHHMMSS];
    }
    return timeString;
}

@end

