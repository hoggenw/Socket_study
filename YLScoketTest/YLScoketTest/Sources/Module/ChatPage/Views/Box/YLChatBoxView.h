//
//  YLchatBoxView.h
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/23.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatFace;
@class YLChatBoxView;
@class ChatMessageModel;

typedef NS_ENUM(NSInteger, YLChatBoxStatus) {
    /**
     *  无状态
     */
    YLChatBoxStatusNothing,
    /**
     *  声音
     */
    YLChatBoxStatusShowVoice,
    /**
     *  表情
     */
    YLChatBoxStatusShowFace,
    /**
     *  更多
     */
    YLChatBoxStatusShowMore,
    /**
     *  键盘
     */
    YLChatBoxStatusShowKeyboard,
    
};

@protocol YLChatBoxDelegate <NSObject>

- (void)chatBox:(YLChatBoxView *)chatBox changeStatusForm:(YLChatBoxStatus)fromStatus to:(YLChatBoxStatus)toStatus;
/**
 *  发送消息
 */
- (void)chatBox:(YLChatBoxView *)chatBox sendTextMessage:(ChatMessageModel *)textMessage;
- (void)chatBox:(YLChatBoxView *)chatBox changeChatBoxHeight:(CGFloat)height;

@end





@interface YLChatBoxView : UIView

@property (nonatomic, assign) id<YLChatBoxDelegate>delegate;
@property (nonatomic, assign) YLChatBoxStatus status;
@property (nonatomic, assign) CGFloat curHeight;

- (void) addEmojiFace:(ChatFace *)face;
- (void) sendCurrentMessage;
- (void) deleteButtonDown;

@end
