//
//  YLChatFaceItemView.h
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/25.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageModel.h"

//一页视图

@interface YLChatFaceItemView : UIView

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) UIControlEvents controlEvents;

- (void) showFaceGroup:(ChatFaceGroup *)group formIndex:(int)fromIndex count:(int)count;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
