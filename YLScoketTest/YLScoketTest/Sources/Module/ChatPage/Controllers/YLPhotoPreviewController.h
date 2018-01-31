//
//  YLPhotoPreviewController.h
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/30.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatMessageModel;
@interface YLPhotoPreviewController : UIViewController

@property (nonatomic, strong) NSArray<ChatMessageModel *> *models;
///< Index of the photo user click / 用户点击的图片的索引
@property (nonatomic, assign) NSInteger currentIndex;

@end
