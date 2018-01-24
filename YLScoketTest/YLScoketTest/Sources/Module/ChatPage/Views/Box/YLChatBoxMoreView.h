//
//  YLChatBoxMoreView.h
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/23.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YLChatBoxItem) {
    YLChatBoxItemAlbum = 0,
    YLChatBoxItemCamera,
};
@class YLChatBoxMoreView;
@protocol YLChatBoxMoreViewDelegate <NSObject>

- (void)chatBoxMoreView:(YLChatBoxMoreView *)chatBoxMoreView didSelectItem:(YLChatBoxItem)itemType;

@end


@interface YLChatBoxMoreView : UIView

@property (nonatomic, strong) id<YLChatBoxMoreViewDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *items;

@end
