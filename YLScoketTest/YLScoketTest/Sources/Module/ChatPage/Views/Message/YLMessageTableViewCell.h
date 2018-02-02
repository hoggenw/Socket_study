//
//  YLMessageTableViewCell.h
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/23.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatMessageModel;
@class YLImageView;

@interface YLMessageTableViewCell : UITableViewCell


@property(nonatomic,strong) ChatMessageModel * messageModel;
/**
 *  其他的cell 继承与这个cell，这个cell中只有头像是共有的，就只写头像，其他的就在各自cell中去写。
 */
@property (nonatomic, strong) YLImageView *avatarImageView;                 // 头像
@property (nonatomic, strong) YLImageView *messageBackgroundImageView;      // 消息背景
@property (nonatomic, strong) UIImageView *messageSendStatusImageView;      // 消息发送状态

@end
