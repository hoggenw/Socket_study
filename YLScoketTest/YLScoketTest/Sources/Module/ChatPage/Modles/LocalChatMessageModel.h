//
//  LocalChatMessageModel.h
//  YLScoketTest
//
//  Created by hoggen on 2020/3/9.
//  Copyright © 2020 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessageModel.h"
#import "YlmessageModel.pbobjc.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalChatMessageModel : NSObject


#pragma mark - 位置消息
@property (nonatomic, strong) NSString *messageId;                    // 消息id

@property(nonatomic, readwrite, copy) NSString *messageOtherUserId;

@property(nonatomic, readwrite, copy) NSString *fromUserId;

@property(nonatomic, readwrite, copy) NSString *fromName;
/** 头像 */
@property(nonatomic, readwrite, copy) NSString *fromAvatar;

@property(nonatomic, readwrite, copy) NSString *toUserUserId;

@property(nonatomic, readwrite, copy) NSString *toUserName;
/** 头像 */
@property(nonatomic, readwrite, copy) NSString *toUserAvatar;

@property (nonatomic, strong) NSString *dateString;                 // 格式化的发送时间

@property (nonatomic, assign) YLMessageType messageType;            // 消息类型
@property (nonatomic, assign) YLMessageOwnerType ownerTyper;        // 发送者类型
@property (nonatomic, assign) YLMessageReadState readState;         // 读取状态
@property (nonatomic, assign) YLMessageSendState sendState;         // 发送状态

#pragma mark - 文字消息
@property (nonatomic, strong) NSString *textString;                       // 文字信息

#pragma mark - 图片消息
@property (nonatomic, strong) NSString *messageSource;    //文件资源路径

#pragma mark - 位置消息
@property (nonatomic, strong) NSString *address;                    // 地址

#pragma mark - 语音消息
@property (nonatomic, assign) NSUInteger voiceSeconds;              // 语音时间

@property (nonatomic, strong) NSDate *date;    //消息时间



+ (LocalChatMessageModel *)localChatMessageModelchangeWith:(YLMessageModel *)pMessage;
+ (ChatMessageModel *)chatMessageModelChangeWith:(LocalChatMessageModel *)pMessage;

@end

NS_ASSUME_NONNULL_END
