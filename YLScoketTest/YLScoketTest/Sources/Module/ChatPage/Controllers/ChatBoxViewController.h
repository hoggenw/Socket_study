//
//  ChatBoxViewController.h
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/19.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatBoxViewController;
@class ChatMessageModel;

@protocol ChatBoxViewControllerDelegate <NSObject>

// chatBoxView 高度改变
- (void)chatBoxViewController:(ChatBoxViewController *)chatboxViewController
       didChangeChatBoxHeight:(CGFloat)height;
// 发送消息
- (void) chatBoxViewController:(ChatBoxViewController *)chatboxViewController
                   sendMessage:(ChatMessageModel *)message;

@end

@interface ChatBoxViewController : UIViewController

@property (nonatomic,weak) id<ChatBoxViewControllerDelegate> delegate;



@end
