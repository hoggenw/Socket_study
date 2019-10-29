//
//  PopupView.h
//  Telegraph
//
//  Created by 王留根 on 2018/5/11.
//

#import <UIKit/UIKit.h>


@interface PopupView : UIView

@property (nonatomic, weak) id<NormalActionWithInfoDelegate> delegate;
@property (nonatomic, assign) PopupViewType type;

- (instancetype)initWithNoneView;
- (instancetype)initWithChicoeProject;
- (void)selfViewHidden;

@end

