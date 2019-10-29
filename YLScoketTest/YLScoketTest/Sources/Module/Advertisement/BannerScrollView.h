//
//  BannerScrollView.h
//  test
//
//  Created by 王留根 on 16/4/15.
//  Copyright © 2016年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BannerScrollView : UIView<UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger currentPageIndex;

/**
 * @brief 初始化方法
 * @param interval 滚动的时间间, 必须大于0
 */
- (instancetype)initWithFrame:(CGRect)frame duration:(NSTimeInterval)interval urls:(NSArray <NSString *> *) urls;

/** 获取page总数 */
@property (nonatomic, copy) NSInteger (^totalPageCount)(void);

/** 获取pageIndex下的视图 */
@property (nonatomic, copy) void (^endActionBlock)(void);

/** 点击指定视图触发事件 */
@property (nonatomic, copy) void (^tapActionBlock)(NSInteger index);


@end
