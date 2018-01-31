//
//  YLPhotoPreviewCell.h
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/30.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLPhotoPreviewCell : UICollectionViewCell

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, copy) void (^singleTapGestureBlock)(CGRect imageRect);
@property (nonatomic, copy) void (^longPressGestureBlock)(UIImage *image);

- (void)recoverSubviews;

@end
