//
//  UIScrollView+Extension.m
//  ftxmall
//
//  Created by 王留根 on 2019/3/19.
//  Copyright © 2019 wanthings. All rights reserved.
//

#import "UIScrollView+Extension.h"

@implementation UIScrollView (Extension)

//重写touchesBegin方法

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //主要代码实现：
    
    [[self nextResponder] touchesBegan:touches withEvent:event];
    
    //
    
    [super touchesBegan:touches withEvent:event];
    
}

@end
