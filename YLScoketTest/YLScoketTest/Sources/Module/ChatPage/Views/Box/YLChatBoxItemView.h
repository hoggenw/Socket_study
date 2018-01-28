//
//  YLChatBoxItemView.h
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/25.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLChatBoxItemView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageName;

+ (YLChatBoxItemView *) createChatBoxMoreItemWithTitle:(NSString *)title
                                              imageName:(NSString *)imageName;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
