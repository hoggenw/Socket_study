//
//  SelectMemberWithSearchView.h
//  YLScoketTest
//
//  Created by hoggen on 2019/12/18.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SelectMemberWithSearchViewDelegate <NSObject>
// 点击collection cell取消选中
- (void)removeMemberFromSelectArray:(YLUserModel *)member
                          indexPath:(NSIndexPath *)indexPath;
@end

@interface SelectMemberWithSearchView : UIView

@property (nonatomic, weak) id<SelectMemberWithSearchViewDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITextField *textfield;

// 当选中人数发生改变时 更改collection view UI
- (void)updateSubviewsLayout:(NSMutableArray *)selelctArray;


@end
