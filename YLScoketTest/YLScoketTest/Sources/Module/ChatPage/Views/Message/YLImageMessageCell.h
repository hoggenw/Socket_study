//
//  YLImageMessageCell.h
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/23.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLMessageTableViewCell.h"

@class ChatMessageModel;

@interface YLImageMessageCell : YLMessageTableViewCell

@property (nonatomic, strong) UIImageView *messageImageView;
@property (nonatomic, copy) void (^imageViewCellTapAction)(ChatMessageModel *);


@end
