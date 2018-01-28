//
//  YLChatFaceMenuVIew.h
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/25.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLChatFaceMenuVIew;

@protocol YLChatFaceMenuVIewDelegate <NSObject>
/**
 *  表情菜单界面的添加按钮点击事件
 */
- (void) chatBoxFaceMenuViewAddButtonDown;
/**
 *  发送事件
 */
- (void) chatBoxFaceMenuViewSendButtonDown;


- (void) chatBoxFaceMenuView:(YLChatFaceMenuVIew *)chatBoxFaceMenuView didSelectedFaceMenuIndex:(NSInteger)index;

@end

@interface YLChatFaceMenuVIew : UIView

@property (nonatomic, weak) id<YLChatFaceMenuVIewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *faceGroupArray;

@end
