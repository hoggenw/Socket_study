//
//  YLProgressView.h
//  ftxmall
//
//  Created by 王留根 on 2017/9/27.
//  Copyright © 2017年 wanthings. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLProgressView : UIView

@property(nonatomic, assign) NSTimeInterval totalTime;

-(void)startProgress:(CGFloat) progress;

- (void)stopProgress ;

@end
