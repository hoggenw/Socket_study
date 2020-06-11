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

@property (nonatomic,copy) NSString * kDTActionHandlerLongTapGestureKey;
@property (nonatomic,copy) NSString * kDTActionHandlerLongTapBlockKey;

@end

@implementation YLImageView


-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = true;
        self.kDTActionHandlerTapGestureKey = @"kDTActionHandlerTapGestureKey";
        self.kDTActionHandlerTapBlockKey = @"kDTActionHandlerTapBlockKey";
        
        self.kDTActionHandlerLongTapGestureKey = @"kDTActionHandlerLongTapGestureKey";
        self.kDTActionHandlerLongTapBlockKey = @"kDTActionHandlerLongTapBlockKey";
    }
    
    
    return  self;
}

-(void)setLongTapActionWithBlock:(void (^)(void))block {
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &_kDTActionHandlerLongTapGestureKey);
       if (!gesture) {
           gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(__handleActionForTapLongGesture:)];
           gesture.minimumPressDuration = 1.2;
           [self addGestureRecognizer:gesture];
           objc_setAssociatedObject(self, &_kDTActionHandlerLongTapBlockKey, gesture, OBJC_ASSOCIATION_RETAIN);
       }
       objc_setAssociatedObject(self, &_kDTActionHandlerLongTapBlockKey, block, OBJC_ASSOCIATION_RETAIN);
       // 移除关联对象
       void objc_removeAssociatedObjects ( id object );
}

- (void)__handleActionForTapLongGesture:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        void(^action)(void) = objc_getAssociatedObject(self, &_kDTActionHandlerLongTapBlockKey);
        
        if (action)
        {
            action();
        }
    }
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
