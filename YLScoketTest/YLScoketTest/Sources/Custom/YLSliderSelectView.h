//
//  YLSliderSelectView.h
//  iOSProject
//
//  Created by 王留根 on 2018/11/26.
//  Copyright © 2018年 hoggenWang.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLSliderSelectView : UIView

@property (nonatomic,strong)NSArray<NSString *>* titles;
@property (nonatomic, weak) id<ActionSelcetControlDelegate> delegate;
@property (nonatomic, assign)NSInteger type;

- (void)refreshTitels:(NSArray *)titles;

@end

NS_ASSUME_NONNULL_END
