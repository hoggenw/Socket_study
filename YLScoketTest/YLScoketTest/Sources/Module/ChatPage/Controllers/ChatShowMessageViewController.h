//
//  ChatShowMessageViewController.h
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/19.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatShowMessageViewController;
@class ChatMessageModel;

@protocol ChatShowMessageViewControllerDelegate <NSObject>

- (void)didTapChatMessageView:(ChatShowMessageViewController *)chatMessageViewController;


@end

@interface ChatShowMessageViewController : UITableViewController

@property (nonatomic,weak) id<ChatShowMessageViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray<ChatMessageModel *> * imageMessageModels;


- (void)scrollToBottom ;

- (void) addNewMessage:(ChatMessageModel *)message;

@end

