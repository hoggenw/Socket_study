//
//  ChatListTableViewCell.h
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/19.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatListUserModel;

@interface ChatListTableViewCell :  UITableViewCell

@property(nonatomic,strong) ChatListUserModel * userModel;

@end
