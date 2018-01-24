//
//  ChatBoxViewController.m
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/19.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "ChatBoxViewController.h"
#import "YLChatFaceView.h"
#import "YLChatBoxView.h"
#import "YLChatBoxMoreView.h"
#import "ChatMessageModel.h"

#define HEIGHT_CHATBOXVIEW  215// 更多 view
@interface ChatBoxViewController ()<YLChatBoxDelegate>

@property (nonatomic, assign) CGRect keyboardFrame;
@property (nonatomic, strong) YLChatBoxView *chatBox;
@property (nonatomic, strong) YLChatBoxMoreView *chatBoxMoreView;
@property (nonatomic, strong) YLChatFaceView *chatBoxFaceView;

@end

@implementation ChatBoxViewController

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification  object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardWillHideNotification object: nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.chatBox];
    /**
     *  添加两个键盘回收通知
     */
    // 即将隐藏
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // 键盘的Frame值即将发生变化的时候创建的额监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  回收键盘方法
 *  
 */
- (BOOL) resignFirstResponder
{
    
    if (self.chatBox.status != YLChatBoxStatusNothing && self.chatBox.status != YLChatBoxStatusShowVoice)
    {
        // 回收键盘
        [self.chatBox resignFirstResponder];
        /**
         *  在外层已经判断是不是声音状态 和 Nothing 状态了，且判断是都不是才进来的，下面在判断是否多余了？
         *  它是判断是不是要设置成Nothing状态
         */
        self.chatBox.status = (self.chatBox.status == YLChatBoxStatusShowVoice ? self.chatBox.status : YLChatBoxStatusNothing);
        
        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)])
        {
            [UIView animateWithDuration:0.3 animations:^{
                
                [_delegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight];
                
            } completion:^(BOOL finished) {
                
                [self.chatBoxFaceView removeFromSuperview];
                [self.chatBoxMoreView removeFromSuperview];
                
            }];
        }
    }
    
    return [super resignFirstResponder];
}

/**
 *   在控制器里面添加键盘的监听，
 *
 *  @return <#return value description#>
 */
#pragma mark - Private Methods
- (void)keyboardWillHide:(NSNotification *)notification{
    self.keyboardFrame = CGRectZero;
    if (_chatBox.status == YLChatBoxStatusShowFace || _chatBox.status == YLChatBoxStatusShowMore) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
        
        [_delegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight];
    }
}

/**
 *  点击了 textView 的时候，这个方法的调用是比  - (void) textViewDidBeginEditing:(UITextView *)textView 要早的。
 
 */
- (void)keyboardFrameWillChange:(NSNotification *)notification{
    
    // 键盘的Frame
    // po self.keyboardFrame 第一次点击 textview 的时候的值
    // (origin = (x = 0, y = 409), size = (width = 375, height = 258))
    // po self.chatBox.curHeight   49
    
    self.keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (_chatBox.status == YLChatBoxStatusShowKeyboard && self.keyboardFrame.size.height <= HEIGHT_CHATBOXVIEW) {
        
        return;
        
    }
    else if ((_chatBox.status == YLChatBoxStatusShowFace || _chatBox.status == YLChatBoxStatusShowMore) && self.keyboardFrame.size.height <= HEIGHT_CHATBOXVIEW) {
        
        return;
        
    }
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
        
        // 改变控制器.View 的高度 键盘的高度 + 当前的 49
        [_delegate chatBoxViewController:self didChangeChatBoxHeight: self.keyboardFrame.size.height + self.chatBox.curHeight];
        
    }
}

#pragma mark - YLChatBoxDelegate

- (void)chatBox:(YLChatBoxView *)chatBox changeStatusForm:(YLChatBoxStatus)fromStatus to:(YLChatBoxStatus)toStatus {
    
    switch (toStatus) {
        case YLChatBoxStatusShowKeyboard: {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.chatBoxFaceView  removeFromSuperview];
                [self.chatBoxMoreView removeFromSuperview];
            });
            return;
        }
        case YLChatBoxStatusShowVoice:{
            if (fromStatus == YLChatBoxStatusShowMore || fromStatus == YLChatBoxStatusShowFace) {
                [UIView animateWithDuration:0.3 animations:^{
                    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                        
                        [_delegate chatBoxViewController:self didChangeChatBoxHeight:HEIGHT_TABBAR];
                        
                    }
                } completion:^(BOOL finished) {
                    
                    [self.chatBoxFaceView removeFromSuperview];
                    [self.chatBoxMoreView removeFromSuperview];
                }];
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                        
                        [_delegate chatBoxViewController:self didChangeChatBoxHeight:HEIGHT_TABBAR];
                    }
                }];
            }
            return;
        }
        case YLChatBoxStatusShowFace:{
            /**
             *   变化到展示 表情View 的状态，这个过程中，根据 fromStatus 区分，要是是声音和无状态改变过来的，则高度变化是一样的。 其他的高度就是另外一种，根据 fromStatus 来进行一个区分。
             */
            if (fromStatus == YLChatBoxStatusShowVoice || fromStatus == YLChatBoxStatusNothing) {
                self.chatBoxFaceView.top = self.chatBox.curHeight;
                [self.view addSubview: self.chatBoxFaceView];
                [UIView animateWithDuration: 0.3 animations:^{
                    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                        
                        [_delegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight + HEIGHT_CHATBOXVIEW];
                    }
                }];
            }else{
                // 表情高度变化
                self.chatBoxFaceView.top = self.chatBox.curHeight + HEIGHT_CHATBOXVIEW;
                [self.view addSubview:self.chatBoxFaceView];
                [UIView animateWithDuration:0.3 animations:^{
                    self.chatBoxFaceView.top = self.chatBox.curHeight;
                } completion:^(BOOL finished) {
                    [self.chatBoxMoreView removeFromSuperview];
                }];
                // 整个界面高度变化
                if (fromStatus != YLChatBoxStatusShowMore) {
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                            [_delegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight + HEIGHT_CHATBOXVIEW];
                        }
                    }];
                }
            }
            return;
        }
            
        case YLChatBoxStatusShowMore:{
            // 显示更多面板
            if (fromStatus == YLChatBoxStatusShowVoice || fromStatus == YLChatBoxStatusNothing) {
                self.chatBoxMoreView.top = self.chatBox.curHeight;
                [self.view addSubview:self.chatBoxMoreView];
                
                [UIView animateWithDuration:0.3 animations:^{
                    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                        [_delegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight + HEIGHT_CHATBOXVIEW];
                    }
                }];
            }
            else {
                
                self.chatBoxMoreView.top = self.chatBox.curHeight + HEIGHT_CHATBOXVIEW;
                [self.view addSubview:self.chatBoxMoreView];
                [UIView animateWithDuration:0.3 animations:^{
                    self.chatBoxMoreView.top = self.chatBox.curHeight;
                } completion:^(BOOL finished) {
                    [self.chatBoxFaceView removeFromSuperview];
                }];
                
                if (fromStatus != YLChatBoxStatusShowFace) {
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                            [_delegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight + HEIGHT_CHATBOXVIEW];
                        }
                    }];
                }
            }
            return;
        }
            
        default:
            break;
    }
    
}
/**
 *  发送文本消息
 */
- (void)chatBox:(YLChatBoxView *)chatBox sendTextMessage:(NSString *)textMessage {
    
    ChatMessageModel * message = [[ChatMessageModel alloc] init];
    message.messageType = YLMessageTypeText;
    message.ownerTyper = YLMessageOwnerTypeSelf;
    message.text = textMessage;
    message.date = [NSDate  date];
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController: sendMessage:)]) {
        
        [_delegate chatBoxViewController:self sendMessage:message];
        
    }
    
}
- (void)chatBox:(YLChatBoxView *)chatBox changeChatBoxHeight:(CGFloat)height {
    self.chatBoxFaceView.top = height;
    self.chatBoxMoreView.top = height;
    if (_delegate && [_delegate respondsToSelector: @selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
        float changedHieght = (self.chatBox.status == YLChatBoxStatusShowFace ? HEIGHT_CHATBOXVIEW : self.keyboardFrame.size.height) + height;
        [_delegate chatBoxViewController: self didChangeChatBoxHeight: changedHieght];
    }
}


#pragma mark - Getter
- (YLChatBoxView *) chatBox
{
    // 6 的初始化 0.0.375.49
    if (_chatBox == nil) {
        _chatBox = [[YLChatBoxView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HEIGHT_TABBAR)];
        _chatBox.delegate = self; // 0 0 宽 49
    }
    
    return _chatBox;
    
}

// 添加创建更多View
- (YLChatBoxMoreView *) chatBoxMoreView
{
    if (_chatBoxMoreView == nil) {
        _chatBoxMoreView = [[YLChatBoxMoreView alloc] initWithFrame:CGRectMake(0, HEIGHT_TABBAR, ScreenWidth, HEIGHT_CHATBOXVIEW)];
        
    }
    return _chatBoxMoreView;
}


-(YLChatFaceView *) chatBoxFaceView
{
    if (_chatBoxFaceView == nil) {
        _chatBoxFaceView = [[YLChatFaceView alloc] initWithFrame:CGRectMake(0, HEIGHT_TABBAR, ScreenWidth, HEIGHT_CHATBOXVIEW)];
        
    }
    return _chatBoxFaceView;
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


























