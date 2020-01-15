//
//  AddressBookViewModel.h
//  YLScoketTest
//
//  Created by hoggen on 2019/11/19.
//  Copyright © 2019 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressBookViewModel : NSObject

@property (nonatomic, strong) RACCommand *friendscommand;
@property (nonatomic, strong) RACCommand *applyFriendscommand;

-(void)getFriendscommand;

-(void)getApplyFriendscommand;

// 获取排序后的通讯录列表
+ (NSMutableArray *) getContactListDataBy:(NSMutableArray *)array;
// 获取分区数(索引列表)
+ (NSMutableArray *) getContactListSectionBy:(NSMutableArray *)array;

@end

NS_ASSUME_NONNULL_END
