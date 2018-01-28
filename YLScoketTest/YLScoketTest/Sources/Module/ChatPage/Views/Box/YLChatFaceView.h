//
//  YLChatFaceView.h
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/24.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageModel.h"


@protocol YLChatBoxFaceViewDelegate <NSObject>

- (void) chatBoxFaceViewDidSelectedFace:(ChatFace *)face type:(YLFaceType)type;
- (void) chatBoxFaceViewDeleteButtonDown;
- (void) chatBoxFaceViewSendButtonDown;

@end

@interface YLChatFaceView : UIView

@property (nonatomic, weak) id<YLChatBoxFaceViewDelegate>delegate;

@end
