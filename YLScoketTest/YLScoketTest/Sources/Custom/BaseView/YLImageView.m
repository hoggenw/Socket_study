//
//  YLImageView.m
//  YLScoketTest
//
//  Created by 王留根 on 2018/2/2.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLImageView.h"
#import <objc/message.h>

@interface YLImageView()
@property (nonatomic,copy) NSString * kDTActionHandlerTapGestureKey;
@property (nonatomic,copy) NSString * kDTActionHandlerTapBlockKey;

@end

@implementation YLImageView


-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = true;
        self.kDTActionHandlerTapGestureKey = @"kDTActionHandlerTapGestureKey";
        self.kDTActionHandlerTapBlockKey = @"kDTActionHandlerTapBlockKey";
    }
    
    
    return  self;
}

-(void)setTapActionWithBlock:(void (^)(void))block {
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &_kDTActionHandlerTapGestureKey);
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(__handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &_kDTActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &_kDTActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_RETAIN);
    
    
    // 移除关联对象
    void objc_removeAssociatedObjects ( id object );
}

- (void)__handleActionForTapGesture:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        void(^action)(void) = objc_getAssociatedObject(self, &_kDTActionHandlerTapBlockKey);
        
        if (action)
        {
            action();
        }
    }
}

@end
