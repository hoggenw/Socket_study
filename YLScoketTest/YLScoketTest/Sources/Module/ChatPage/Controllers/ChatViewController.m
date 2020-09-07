//
//  ChatViewController.m
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/19.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatBoxViewController.h"
#import "ChatUserModel.h"
#import "ChatShowMessageViewController.h"
#import "ChatMessageModel.h"
#import "YLSocketRocktManager.h"
#import "YLPhotoPreviewController.h"
#import "ChatListUserModel.h"
#import "YlmessageModel.pbobjc.h"


@interface ChatViewController ()<ChatShowMessageViewControllerDelegate,ChatBoxViewControllerDelegate,receiveMessageDelegate>

@property(nonatomic,assign) CGFloat viewHeight;

@property(nonatomic,strong)ChatShowMessageViewController * chatMessageVC;
@property(nonatomic,strong)ChatBoxViewController * chatBoxVC;
@property(nonatomic,strong) YLSocketRocktManager *manager;


@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.user.username;
    _manager = [YLSocketRocktManager shareManger];
    _manager.delegate = self;
    // 主屏幕的高度减去导航的高度，减去状态栏的高度。在PCH头文件
    _viewHeight = ScreenHeight - kNavigationHeight;
    [self.view  addSubview:self.chatMessageVC.view];
    [self addChildViewController:self.chatMessageVC];
    
    [self.view  addSubview:self.chatBoxVC.view];
    [self addChildViewController:self.chatBoxVC];

    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [ChatDealUtils setMessageStateReaded: self.user.userID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    //如果继续向super传值，则响应链被截断
    // [super routerEventWithName:eventName userInfo: userInfo];
    ChatMessageModel *model = [userInfo objectForKey:kChoiceCellMessageModelKey];
    if ([eventName isEqualToString:kRouterEventCellImageTapEventName]) {
        //点击图片
        if (model != nil) {
            [self chatImageCellPressed:model];
        }
        
    }
}
#pragma mark - Public Methods


#pragma mark - Events
// 图片cell的被点击
- (void)chatImageCellPressed:(ChatMessageModel *)model {
    if ([self.chatMessageVC.imageMessageModels containsObject:model]) {
        NSInteger  index = [self.chatMessageVC.imageMessageModels indexOfObject: model];
        YLPhotoPreviewController *photoPreview = [YLPhotoPreviewController new];
        photoPreview.currentIndex = index;
        photoPreview.models = self.chatMessageVC.imageMessageModels;
        photoPreview.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:photoPreview animated:YES completion:nil];
    }else{
        NSLog(@"消息不在记录里面");
    }
    
}

#pragma mark - Private Methods

- (ChatBoxViewController *)chatBoxVC {
    if (_chatBoxVC == nil) {
        _chatBoxVC = [ChatBoxViewController new];
        _chatBoxVC.view.frame = CGRectMake(0, ScreenHeight -  HEIGHT_TABBAR, ScreenWidth,  ScreenHeight);
        _chatBoxVC.delegate = self;
    }
    
    return _chatBoxVC;
}

- (ChatShowMessageViewController *)chatMessageVC {
    if (_chatMessageVC == nil) {
        _chatMessageVC = [[ChatShowMessageViewController  alloc] init];
        _chatMessageVC.view.frame = CGRectMake(0, HEIGHT_STATUSBAR + HEIGHT_NAVBAR, ScreenWidth, ScreenHeight - HEIGHT_TABBAR - HEIGHT_STATUSBAR - HEIGHT_NAVBAR);// 0  状态 + 导航 宽 viweH - tabbarH
        _chatMessageVC.delegate = self;// 代理
        _chatMessageVC.user = _user;
    }
    
    return _chatMessageVC;
}




#pragma mark - Extension Delegate or Protocol

# pragma mark -  receiveMessageDelegate

-(void)receiveMessage:(LocalChatMessageModel *)message {
    
    if (message == NULL) {
        [self.chatMessageVC addNewMessage:NULL];
        return;
    }
    ChatMessageModel *recMessage = [LocalChatMessageModel chatMessageModelChangeWith:message];
    [self.chatMessageVC addNewMessage:recMessage];
    
}
- (void)didTapChatMessageView:(ChatShowMessageViewController *)chatMessageViewController {
    [self.chatBoxVC resignFirstResponder];
}

//ChatBoxViewControllerDelegate

// chatBoxView 高度改变
- (void)chatBoxViewController:(ChatBoxViewController *)chatboxViewController
       didChangeChatBoxHeight:(CGFloat)height {
    self.chatMessageVC.view.height = _viewHeight - height;
    self.chatBoxVC.view.top = self.chatMessageVC.view.top + self.chatMessageVC.view.height;
    [self.chatMessageVC scrollToBottom];
    
}
// 发送消息
- (void) chatBoxViewController:(ChatBoxViewController *)chatboxViewController
                   sendMessage:(ChatMessageModel *)message {
    // 发送的消息数据模型
    UserModel * model = [AccountManager sharedInstance].fetch;
    YLUserModel * user = [YLUserModel new];
    user.name = model.name;
    user.avatar = model.avatar;
    user.userId = model.userID;
    
    
    YLUserModel * toModel = [YLUserModel new];
    toModel.userId = self.user.userID;
    toModel.name = self.user.username;
    toModel.avatar = self.user.avatarURL;
    
    message.from = user; //发送者
    message.toUser = toModel;
    [self.manager sendMassege:message];
   
    
}


@end


























